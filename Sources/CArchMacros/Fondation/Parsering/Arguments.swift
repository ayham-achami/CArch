//
//  Arguments.swift
//

import SwiftSyntax

/// Название аргумента любого макроса
protocol MacroArgumentLabel: RawRepresentable where RawValue == String {}

/// Проверка на равенство
/// - Parameters:
///   - lhs: Опциональная строка с типом
///   - rhs: Название аргумента макроса
/// - Returns: true если раовны
func == (lhs: String?, rhs: any MacroArgumentLabel) -> Bool {
    guard case let .some(label) = lhs else { return false }
    return label == rhs
}

/// Проверка на равенство
/// - Parameters:
///   - lhs: Строка с типом
///   - rhs: Название аргумента макроса
/// - Returns: true если раовны
func == (lhs: String, rhs: any MacroArgumentLabel) -> Bool {
    lhs == rhs.rawValue
}

/// Парсер аргументов макроса
protocol ArgumentsParser<Label> {
    
    associatedtype Label: MacroArgumentLabel
}

// MARK: - SyntaxCollection + LabeledExprListSyntax.Element
extension SyntaxCollection where Element == LabeledExprListSyntax.Element {
    
    func argumentExpr(by label: any MacroArgumentLabel) -> LabeledExprSyntax? {
        first { $0.label?.text == label }
    }
}
