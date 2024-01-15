//
//  CodeBlockSyntax+Task.swift
//

import SwiftSyntax

// MARK: - CodeBlockSyntax + Functions
extension CodeBlockSyntax {
    
    static func awaitSyntax(_ function: FunctionDeclSyntax) -> Self {
        .init(
            statements: .init(
                arrayLiteral: .init(
                    item: .expr("""
                                Task { [weak self] in
                                    await self?.\(function.name)(\(raw: arguments(of: function)))
                                }
                            """)
                )
            ).with(\.leadingTrivia, .tab)
        )
    }
    
    static func tryAwaitSyntax(_ function: FunctionDeclSyntax) -> Self {
        .init(
            statements: .init(
                arrayLiteral: .init(
                    item: .expr("""
                                Task { [weak self] in
                                    do {
                                        try await self?.\(function.name)(\(raw: arguments(of: function)))
                                    } catch {
                                        self?.encountered(error)
                                    }
                                }
                           """)
                ).with(\.leadingTrivia, .tab)
            )
        )
    }
    
    static func arguments(of function: FunctionDeclSyntax) -> String {
        function.signature.parameterClause.parameters.map { param in
            let argName = param.secondName ?? param.firstName
            let paramName = param.firstName
            if paramName.text != "_" {
                return "\(paramName.text): \(argName.text)"
            }
            return "\(argName.text)"
        }.joined(separator: ", ")
    }
}
