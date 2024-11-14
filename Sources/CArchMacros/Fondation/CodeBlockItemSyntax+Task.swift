//
//  CodeBlockItemSyntax+Task.swift
//

import SwiftSyntax

// MARK: - SyncAliasMacro + CodeBlockItemSyntax.Item + Record
extension CodeBlockItemSyntax.Item {
    
    static func taskExpr(_ function: FunctionDeclSyntax) -> Self {
        .expr(
        """
        Task { [weak self] in
            await self?.\(function.name)(\(raw: arguments(of: function)))
        }
        """
        )
    }
    
    static func taskDoCatchExpr(_ function: FunctionDeclSyntax) -> Self {
        .expr(
        """
        Task { [weak self] in
            do {
                try await self?.\(function.name)(\(raw: arguments(of: function)))
            } catch {
                self?.encountered(error)
            }
        }
        """
        )
    }
    
    private static func arguments(of function: FunctionDeclSyntax) -> String {
        function.signature.parameterClause.parameters.map { parameter in
            let argumentName = parameter.secondName ?? parameter.firstName
            let parameterName = parameter.firstName
            if parameterName.text != "_" {
                return "\(parameterName.text): \(argumentName.text)"
            }
            return "\(argumentName.text)"
        }.joined(separator: ", ")
    }
}
