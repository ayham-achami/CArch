//
//  AutoResolvableMacro+Parser.swift
//

import SwiftSyntax
import SwiftSyntaxMacros

// MARK: - AutoResolvableMacro + Parser
extension AutoResolvableMacro {
    
    /// <#Description#>
    enum Parser {
        
        /// Возвращает аргументы макроса
        /// - Parameters:
        ///   - attributes: `AttributeSyntax`
        ///   - protocolDecl: `ProtocolDeclSyntax`
        ///   - context: `MacroExpansionContext`
        static func arguments(from attributes: SwiftSyntax.AttributeSyntax,
                              decl: DeclSyntaxProtocol,
                              context: some SwiftSyntaxMacros.MacroExpansionContext,
                              defaultOptions: Options = []) throws -> Arguments {
            guard
                let labeledList = attributes.arguments?.as(LabeledExprListSyntax.self)
            else { return .default(options: defaultOptions) }
            return .init(
                options: try options(from: labeledList, with: context).union(defaultOptions),
                shouldUseResolver: try shouldUseResolver(from: labeledList, with: context),
                implementations: try implementations(from: labeledList, with: context)
            )
        }
        
        /// Возвращает публичный ли init метод
        /// - Parameters:
        ///   - labeledList: `LabeledExprListSyntax`
        ///   - context: `MacroExpansionContext`
        /// - Returns: description
        static func options(from labeledList: SwiftSyntax.LabeledExprListSyntax?,
                            with context: some SwiftSyntaxMacros.MacroExpansionContext) throws -> Options {
            guard
                let element = labeledList?.first(where: { $0.label?.text == ArgumentsType.options.rawValue })
            else { return Arguments.default.options }
            guard
                let expression = element.expression.as(ArrayExprSyntax.self)?.elements.map(\.expression)
            else { throw ArgumentsType.Error.unknown(String(describing: element.expression.self)) }
            return .parse(from: expression)
        }
        
        /// <#Description#>
        /// - Parameters:
        ///   - labeledList: <#labeledList description#>
        ///   - context: <#context description#>
        /// - Returns: <#description#>
        static func shouldUseResolver(from labeledList: SwiftSyntax.LabeledExprListSyntax?,
                                      with context: some SwiftSyntaxMacros.MacroExpansionContext) throws -> Bool {
            guard
                let element = labeledList?.first(where: { $0.label?.text == ArgumentsType.shouldUseResolver.rawValue })
            else { return Arguments.default.shouldUseResolver }
            guard
                let expression = element.expression.as(BooleanLiteralExprSyntax.self)
            else { throw ArgumentsType.Error.unknown(String(describing: element.expression.self)) }
            guard
                let shouldUseResolver = Bool(expression.literal.text)
            else { throw ArgumentsType.Error.unknown(expression.literal.text) }
            return shouldUseResolver
        }
        
        /// Возвращает доступные класс имплементация
        /// - Parameters:
        ///   - labeledList: `LabeledExprListSyntax`
        ///   - protocolDecl: `ProtocolDeclSyntax`
        ///   - context: `MacroExpansionContext`
        static func implementations(from labeledList: SwiftSyntax.LabeledExprListSyntax?,
                                    with context: some SwiftSyntaxMacros.MacroExpansionContext) throws -> [String: String] {
            guard
                let element = labeledList?.first(where: { $0.label?.text == ArgumentsType.implementations.rawValue })
            else { return [:] }
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
