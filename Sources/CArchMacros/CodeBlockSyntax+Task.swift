//
//  CodeBlockSyntax+Task.swift
//

import SwiftSyntax

// MARK: - CodeBlockSyntax + Functions
extension CodeBlockSyntax {
    
    /// <#Description#>
    /// - Parameter function: <#function description#>
    /// - Returns: <#description#>
    static func awaitSyntax(_ function: FunctionDeclSyntax) -> Self {
        bodySyntax(.init(stringLiteral: "await self?.\(function.name)(\(arguments(of: function)))"))
    }
    
    /// <#Description#>
    /// - Parameter function: <#function description#>
    /// - Returns: <#description#>
    static func tryAwaitSyntax(_ function: FunctionDeclSyntax) -> Self {
        bodySyntax(.init(stringLiteral:
        """
        do {
                try await self?.\(function.name)(\(arguments(of: function)))
        } catch {
                self?.encountered(error)
        }
        """))
    }
    
    /// <#Description#>
    /// - Parameter function: <#function description#>
    /// - Returns: <#description#>
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
    
    /// <#Description#>
    /// - Parameter syntax: <#syntax description#>
    /// - Returns: <#description#>
    private static func bodySyntax(_ syntax: ExprSyntax) -> Self {
        let body = ExprSyntax(stringLiteral:
        """
        Task { [weak self] in
            \(syntax)
        }
        """)
        let statements = CodeBlockItemListSyntax([CodeBlockItemSyntax(item: .expr(body))])
        let bodySyntax = CodeBlockSyntax(statements: statements,
                                         rightBrace: .rightBraceToken(leadingTrivia: .newline))
        return bodySyntax
    }
}
