//
//  AssemblyOptions.swift
//

import SwiftSyntax

/// Опцы типа сборщика
struct AssemblyOptions: OptionSet {
    
    /// Публичный
    static let `public` = Self(rawValue: 1 << 0)
    /// Свободный класс а не вложенный
    static let freestanding = Self(rawValue: 1 << 1)
    
    public let rawValue: Int
    
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
}

// MARK: - AssemblyOptions + Parsing
extension AssemblyOptions {
    
    /// Получить опцы типа сборщика из syntax
    /// - Parameter expr: Syntax
    /// - Returns: `AssemblyOptions`
    static func parse(from expr: [ExprSyntax]) -> Self {
        expr.compactMap { $0.as(MemberAccessExprSyntax.self)?.declName.baseName.text }
            .reduce(into: Self.init()) { result, raw in
                switch raw {
                case "public": result.insert(.public)
                case "freestanding": result.insert(.freestanding)
                default: break
                }
            }
    }
}
