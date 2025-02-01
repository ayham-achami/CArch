//
//  AssemblyBehaviorParser.swift
//

import SwiftSyntax
import SwiftSyntaxMacros

/// Парсер поведения сборщика
protocol AssemblyBehaviorParser: ArgumentsParser {
    
    /// Получить поведение из syntax
    /// - Parameters:
    ///   - labeledList: Массив названий
    ///   - label: Название, что искать надо
    ///   - context: Конекст
    static func behavior(from labeledList: LabeledExprListSyntax?, label: Label, context: some MacroExpansionContext) throws(Parsing.Error) -> AssemblyBehavior
}

// MARK: - AssemblyBehaviorParser + Default
extension AssemblyBehaviorParser {
    
    static func behavior(from labeledList: LabeledExprListSyntax?, label: Label, context: some MacroExpansionContext) throws(Parsing.Error) -> AssemblyBehavior {
        guard
            let element = labeledList?.argumentExpr(by: label)
        else { throw Parsing.Error.missingArgument("AssemblyBehavior") }
        guard
            let member = element.expression.as(MemberAccessExprSyntax.self)
        else { throw Parsing.Error.invalidArgument("AssemblyBehavior") }
        return try .parse(from: member)
    }
}
