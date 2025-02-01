//
//  AutoResolvableMacro+Parser.swift
//

import SwiftSyntax
import SwiftSyntaxMacros

// MARK: - AutoResolvableMacro + Parser
extension AutoResolvableMacro {
    
    /// Парсер аргументов макроса
    enum Parser: ImplementationsParser {
        
        typealias Label = ArgumentLabel
        
        static func arguments(from attributes: AttributeSyntax, declSyntax: DeclSyntaxProtocol, context: some MacroExpansionContext) throws(Parsing.Error) -> Arguments {
            guard
                let labeledList = attributes.arguments?.as(LabeledExprListSyntax.self)
            else { return .default(for: declSyntax) }
            return .init(
                options: try options(from: labeledList, declSyntax: declSyntax, with: context),
                shouldUseResolver: try shouldUseResolver(from: labeledList, declSyntax: declSyntax, with: context),
                implementations: try implementations(from: labeledList, declSyntax: declSyntax, with: context)
            )
        }
        
        private static func options(from labeledList: LabeledExprListSyntax,
                                    declSyntax: DeclSyntaxProtocol,
                                    with context: some MacroExpansionContext) throws(Parsing.Error) -> Options {
            guard
                let element = labeledList.argumentExpr(by: ArgumentLabel.options)
            else { return .default(for: declSyntax) }
            guard
                let expression = element.expression.as(ArrayExprSyntax.self)
            else { throw Parsing.Error.invalidArgument("Options") }
            return .default(for: declSyntax).union(.parse(from: expression.elements.map(\.expression)))
        }
        
        private static func shouldUseResolver(from labeledList: LabeledExprListSyntax,
                                              declSyntax: DeclSyntaxProtocol,
                                              with context: some MacroExpansionContext) throws(Parsing.Error) -> Bool {
            guard
                let element = labeledList.argumentExpr(by: ArgumentLabel.shouldUseResolver)
            else { return Arguments.default(for: declSyntax).shouldUseResolver }
            guard
                let expression = element.expression.as(BooleanLiteralExprSyntax.self),
                let shouldUseResolver = Bool(expression.literal.text)
            else { throw Parsing.Error.invalidArgument("ShouldUseResolver") }
            return shouldUseResolver
        }

        private static func implementations(from labeledList: LabeledExprListSyntax,
                                            declSyntax: DeclSyntaxProtocol,
                                            with context: some MacroExpansionContext) throws(Parsing.Error) -> [String: String] {
            do {
                return try implementations(from: labeledList, label: ArgumentLabel.implementations, with: context)
            } catch .missingArgument {
                return Arguments.default(for: declSyntax).implementations
            } catch {
                throw error
            }
        }
    }
}
