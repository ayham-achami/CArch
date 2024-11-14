//
//  AutoResolvableMacro.swift
//

import SwiftDiagnostics
import SwiftSyntax
import SwiftSyntaxMacros

/// <#Description#>
public struct AutoResolvableMacro: MemberMacro {
    
    public static func expansion(of node: AttributeSyntax,
                                 providingMembersOf declaration: some DeclGroupSyntax,
                                 in context: some MacroExpansionContext) throws -> [DeclSyntax] {
        try checkInitializerDecl(declaration, in: context)
        
        let initializersDecl = if let declaration = declaration.as(StructDeclSyntax.self) {
            try structDeclSyntax(declaration, node, context)
        } else if let declaration = declaration.as(ClassDeclSyntax.self) {
            try classDeclSyntax(declaration, node, context)
        } else if let declaration = declaration.as(ActorDeclSyntax.self) {
            try actorDeclSyntax(declaration, node, context)
        } else {
            throw SwiftObjectMacros.Error.notSupported(Self.self)
        }
        return initializersDecl.map(DeclSyntax.init)
    }
}

// MARK: - AutoResolvableMacro + ArgumentsType
extension AutoResolvableMacro {
    
    /// Типы аргументов макроса
    enum ArgumentsType: String {
        
        /// Ошибки парсинга аргументов макроса
        enum Error: Swift.Error, CustomStringConvertible {
            
            var description: String {
                switch self {
                case .convert:
                    return "Could not to convert argument"
                case .unknown(let string):
                    return "Unknown argument \(string) of macro"
                case .notSupported(let string):
                    return string
                }
            }
            
            case convert
            case unknown(String)
            case notSupported(String)
        }
        
        case options
        case implementations
        case shouldUseResolver
    }
}

// MARK: - AutoResolvableMacro + Arguments
extension AutoResolvableMacro {
    
    /// <#Description#>
    struct Arguments {
        
        /// <#Description#>
        static let `default` = Self(options: [], shouldUseResolver: true, implementations: [:])
        
        /// <#Description#>
        /// - Parameter options: <#options description#>
        /// - Returns: <#description#>
        static func `default`(options: Options) -> Self {
            .init(options: Self.default.options.union(options),
                  shouldUseResolver: Self.default.shouldUseResolver,
                  implementations: Self.default.implementations)
        }
        
        /// <#Description#>
        let options: Options
        
        /// <#Description#>
        let shouldUseResolver: Bool
        
        /// <#Description#>
        let implementations: [String: String]
    }
}

// MARK: - AutoResolvableMacro + Options
extension AutoResolvableMacro {
    
    /// <#Description#>
    struct Options: OptionSet {
        
        /// <#Description#>
        /// - Parameter expr: <#expr description#>
        /// - Returns: <#description#>
        static func parse(from expr: [ExprSyntax]) -> Self {
            let raws = expr.compactMap { $0.as(MemberAccessExprSyntax.self)?.declName.baseName.text }
            var options: Self = []
            if raws.contains("public") {
                options.insert(.public)
            }
            if raws.contains("required") {
                options.insert(.required)
            }
            if raws.contains("convenience") {
                options.insert(.convenience)
            }
            return options
        }
        
        /// <#Description#>
        static let `public` = Options(rawValue: 1 << 0)
        
        /// <#Description#>
        static let required = Options(rawValue: 1 << 1)
        
        /// <#Description#>
        static let convenience = Options(rawValue: 1 << 2)
        
        /// <#Description#>
        var modifiers: DeclModifierListSyntax {
            var modifiers: [TokenSyntax] = []
            if contains(.public) {
                modifiers.append(.keyword(.public))
            }
            if contains(.required) {
                modifiers.append(.keyword(.required))
            }
            if contains(.convenience) {
                modifiers.append(.keyword(.convenience))
            }
            return .init {
                for modifier in modifiers {
                    .init(name: modifier)
                }
            }
        }
        
        let rawValue: Int
    }
}

// MARK: - AutoResolvableMacro + Property
extension AutoResolvableMacro {
    
    /// <#Description#>
    struct Property: Hashable {
        
        /// <#Description#>
        let name: String
        
        /// <#Description#>
        let type: String
    }
}
