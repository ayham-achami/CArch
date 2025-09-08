//
//  AssemblyOptionsParser.swift
//

import SwiftSyntax
import SwiftSyntaxMacros

/// Парсер опцы сборщика
protocol AssemblyOptionsParser: ArgumentsParser {
    
    /// Получить опцы из syntax
    /// - Parameters:
    ///   - labeledList: Массив названий
    ///   - label: Название, что искать надо
    ///   - context: Конекст
    static func options(from labeledList: LabeledExprListSyntax?, label: Label, context: some MacroExpansionContext) throws(Parsing.Error) -> AssemblyOptions
    
    /// Получить опцы из syntax
    /// - Parameters:
    ///   - expression: Массив выражений
    ///   - context: Контекст
    static func options(from expression: ArrayExprSyntax, context: some MacroExpansionContext) throws(Parsing.Error) -> AssemblyOptions
}

// MARK: - AssemblyOptionsParser + Default
extension AssemblyOptionsParser {
    
    static func options(from labeledList: LabeledExprListSyntax?, label: Label, context: some MacroExpansionContext) throws(Parsing.Error) -> AssemblyOptions {
        guard
            let element = labeledList?.argumentExpr(by: label)
        else { throw Parsing.Error.missingArgument("AssemblyOptions") }
        return if let expression = element.expression.as(ArrayExprSyntax.self) {
            try options(from: expression, context: context)
        } else if let expression = element.expression.as(MemberAccessExprSyntax.self) {
            try options(from: .init(expressions: [.init(expression)]), context: context)
        } else {
            throw Parsing.Error.invalidArgument("AssemblyOptions")
        }
    }
    
    static func options(from expression: ArrayExprSyntax, context: some MacroExpansionContext) throws(Parsing.Error) -> AssemblyOptions {
        .parse(from: expression.elements.map(\.expression))
    }
}
