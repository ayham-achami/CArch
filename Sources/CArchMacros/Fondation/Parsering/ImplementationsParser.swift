//
//  ImplementationsParser.swift
//

import SwiftSyntax
import SwiftSyntaxMacros

/// Парсер имплементации сборщика
protocol ImplementationsParser: ArgumentsParser {
    
    /// Получить имплементации из syntax
    /// - Parameters:
    ///   - labeledList: Массив названий
    ///   - label: Название, что искать надо
    ///   - context: Конекст
    static func implementations(from labeledList: LabeledExprListSyntax?, label: Label, with context: some MacroExpansionContext) throws(Parsing.Error) -> [String: String]
    
    /// Получить имплементации из syntax
    /// - Parameters:
    ///   - expression: Массив выражений
    ///   - context: Контекст
    static func implementations(from expression: ArrayExprSyntax, with context: some MacroExpansionContext) throws(Parsing.Error) -> [String: String]
}

// MARK: - ImplementationsParser + Default
extension ImplementationsParser {
    
    static func implementations(from labeledList: LabeledExprListSyntax?, label: Label, with context: some MacroExpansionContext) throws(Parsing.Error) -> [String: String] {
        guard
            let element = labeledList?.argumentExpr(by: label)
        else { throw Parsing.Error.missingArgument("Implementations") }
        guard
            let expression = element.expression.as(ArrayExprSyntax.self)
        else { throw Parsing.Error.invalidArgument("Implementations") }
        return try implementations(from: expression, with: context)
    }
    
    static func implementations(from expression: ArrayExprSyntax, with context: some MacroExpansionContext) throws(Parsing.Error) -> [String: String] {
        expression
            .elements
            .compactMap { $0.expression.as(FunctionCallExprSyntax.self)?.arguments.map(\.expression) }
            .reduce([], +)
            .compactMap { $0.as(MemberAccessExprSyntax.self) }
            .map { $0.base?.as(DeclReferenceExprSyntax.self)?.baseName.text ?? $0.declName.baseName.text }
            .chunked(into: 2)
            .reduce(into: [:]) { $0[$1[0]] = $1[1] }
    }
}
