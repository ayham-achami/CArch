//
//  ContractMacro+Parser.swift
//

import SwiftSyntax
import SwiftSyntaxMacros

// MARK: - ContractMacro + Parser
extension ContractMacro {
    
    /// <#Description#>
    enum Parser {
        
        /// Возвращает аргументы макроса
        /// - Parameters:
        ///   - attributes: `AttributeSyntax`
        ///   - protocolDecl: `ProtocolDeclSyntax`
        ///   - context: `MacroExpansionContext`
        static func arguments(from attributes: SwiftSyntax.AttributeSyntax,
                              decl protocolDecl: ProtocolDeclSyntax,
                              context: some SwiftSyntaxMacros.MacroExpansionContext) throws -> Arguments {
            let labeledList = attributes.arguments?.as(LabeledExprListSyntax.self)
            
            let component = try component(from: protocolDecl, with: context)
            let visibility = try visibility(from: protocolDecl, with: context)
            let isPublicAssembly = try isPublicAssembly(from: labeledList, with: context)
            let implementations = try implementations(from: labeledList, protocolDecl, with: context)
            
            return .init(
                component: component,
                visibility: visibility,
                isPublicAssembly: isPublicAssembly,
                implementations: implementations
            )
        }
        
        /// Возвращает CArch component
        /// - Parameters:
        ///   - protocolDecl: `ProtocolDeclSyntax`
        ///   - context: `MacroExpansionContext`
        static func component(from protocolDecl: ProtocolDeclSyntax,
                              with context: some SwiftSyntaxMacros.MacroExpansionContext) throws -> Arguments.Component {
            guard
                let inheritedTypes = protocolDecl.inheritanceClause?.inheritedTypes,
                !inheritedTypes.isEmpty
            else { throw ArgumentsType.Error.inherited }
            if inheritedTypes.contains("BusinessLogicAgent") {
                return .agent
            } else if inheritedTypes.contains("BusinessLogicService") {
                return .service
            } else if inheritedTypes.contains("BusinessLogicController") {
                return .controller
            } else if inheritedTypes.contains("BusinessLogicSingleton") {
                return .singleton
            } else if inheritedTypes.contains("BusinessLogicServicePool") {
                return .pool
            }
            throw ArgumentsType.Error.inherited
        }
        
        /// Возвращает область видимости
        /// - Parameters:
        ///   - protocolDecl: `ProtocolDeclSyntax`
        ///   - context: `ProtocolDeclSyntax`
        static func visibility(from protocolDecl: ProtocolDeclSyntax,
                               with context: some SwiftSyntaxMacros.MacroExpansionContext) throws -> ContractMacro.Arguments.Visibility? {
            protocolDecl.modifiers.visibility
        }
        
        /// Возвращает публичный ли класс X-Assembly
        /// - Parameters:
        ///   - labeledList: `LabeledExprListSyntax`
        ///   - context: `MacroExpansionContext`
        /// - Returns: description
        static func isPublicAssembly(from labeledList: SwiftSyntax.LabeledExprListSyntax?,
                                     with context: some SwiftSyntaxMacros.MacroExpansionContext) throws -> Bool {
            guard
                let element = labeledList?.first(where: { $0.label?.text == ArgumentsType.isPublicAssembly.rawValue })
            else { return false }
            guard
                let expression = element.expression.as(BooleanLiteralExprSyntax.self)
            else { throw ArgumentsType.Error.unknown(String(describing: element.expression.self)) }
            guard
                let isPublic = Bool(expression.literal.text)
            else { throw ArgumentsType.Error.unknown(expression.literal.text) }
            return isPublic
        }
        
        /// Возвращает доступные класс имплементация
        /// - Parameters:
        ///   - labeledList: `LabeledExprListSyntax`
        ///   - protocolDecl: `ProtocolDeclSyntax`
        ///   - context: `MacroExpansionContext`
        static func implementations(from labeledList: SwiftSyntax.LabeledExprListSyntax?,
                                    _ protocolDecl: ProtocolDeclSyntax,
                                    with context: some SwiftSyntaxMacros.MacroExpansionContext) throws -> [String: String] {
            guard
                let element = labeledList?.first(where: { $0.label?.text == ArgumentsType.implementations.rawValue })
            else { return ["\(protocolDecl.name.text)Implementation": "default"] }
            guard
                let expression = element.expression.as(ArrayExprSyntax.self)
            else { throw ArgumentsType.Error.convert }
            return expression
                .elements
                .map(\.expression)
                .compactMap { $0.as(FunctionCallExprSyntax.self)?.arguments.map(\.expression) }
                .reduce(into: []) { $0.append(contentsOf: $1) }
                .compactMap { $0.as(MemberAccessExprSyntax.self) }
                .map { $0.base?.as(DeclReferenceExprSyntax.self)?.baseName.text ?? $0.declName.baseName.text }
                .chunked(into: 2)
                .reduce(into: [:]) { $0[$1[0]] = $1[1] }
        }
    }
}

// MARK: - DeclModifierListSyntax + Visibility
extension DeclModifierListSyntax {
    
    /// Возвращает область видимости
    var visibility: ContractMacro.Arguments.Visibility? {
        let modifiers = map(\.name.text)
        if modifiers.contains(TokenSyntax.keyword(.public).text) {
            return .public
        } else if modifiers.contains(TokenSyntax.keyword(.private).text) {
            return .private
        }
        return nil
    }
}
