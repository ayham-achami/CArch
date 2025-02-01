//
//  AutoResolvableMacro+Arguments.swift
//

import SwiftSyntax

// MARK: - AutoResolvableMacro + ArgumentsType
extension AutoResolvableMacro {
    
    /// Типы аргументов макроса
    enum ArgumentLabel: String, MacroArgumentLabel {
        
        case options
        case implementations
        case shouldUseResolver
    }
}

// MARK: - AutoResolvableMacro + Arguments
extension AutoResolvableMacro {
    
    struct Arguments {
        
        static func `default`(for declSyntax: DeclSyntaxProtocol) -> Self {
            .init(options: .default(for: declSyntax), shouldUseResolver: true, implementations: [:])
        }
        
        let options: Options
        let shouldUseResolver: Bool
        let implementations: [String: String]
    }
}

// MARK: - AutoResolvableMacro + Options
extension AutoResolvableMacro {
    
    struct Options: OptionSet {
        
        static let `public` = Options(rawValue: 1 << 0)
        static let required = Options(rawValue: 1 << 1)
        static let convenience = Options(rawValue: 1 << 2)
    
        let rawValue: Int
    }
}

// MARK: - AutoResolvableMacro.Options + Default
extension AutoResolvableMacro.Options {
    
    static func `default`(for declSyntax: DeclSyntaxProtocol) -> Self {
        guard declSyntax.as(ClassDeclSyntax.self) != nil else { return [] }
        return [.convenience, .required]
    }
}

// MARK: - AutoResolvableMacro.Options + Parsing
extension AutoResolvableMacro.Options {
    
    static func parse(from expr: [ExprSyntax]) -> Self {
        expr.compactMap { $0.as(MemberAccessExprSyntax.self)?.declName.baseName.text }
            .reduce(into: Self.init()) { result, raw in
                switch raw {
                case "public": result.insert(.public)
                case "required": result.insert(.required)
                case "convenience": result.insert(.convenience)
                default: break
                }
            }
    }
}

// MARK: - AutoResolvableMacro + Property
extension AutoResolvableMacro {
    
    struct Property: Hashable {
        
        let name: String
        let type: String
    }
}
