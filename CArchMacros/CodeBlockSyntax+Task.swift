import SwiftSyntax

extension CodeBlockSyntax {
    
    static func awaitSyntax(_ function: FunctionDeclSyntax) -> Self {
        bodySyntax(.init(stringLiteral: "await \(function.identifier)(\(arguments(of: function)))"))
    }
    
    static func tryAwaitSyntax(_ function: FunctionDeclSyntax) -> Self {
        bodySyntax(.init(stringLiteral:
        """
        do {
        try await \(function.identifier)(\(arguments(of: function)))
        } catch {
        print(error)
        }
        """))
    }
    
    static func arguments(of function: FunctionDeclSyntax) -> String {
        function.signature.input.parameterList.map { param in
            let argName = param.secondName ?? param.firstName
            let paramName = param.firstName
            if paramName.text != "_" {
                return "\(paramName.text): \(argName.text)"
            }
            return "\(argName.text)"
        }.joined(separator: ", ")
    }
    
    private static func bodySyntax(_ syntax: ExprSyntax) -> Self {
        let body = ExprSyntax(stringLiteral:
        """
        Task {
            \(syntax)
        }
        """)
        let statements = CodeBlockItemListSyntax([CodeBlockItemSyntax(item: .expr(body))])
        let bodySyntax = CodeBlockSyntax(statements: statements,
                                         rightBrace: .rightBraceToken(leadingTrivia: .newline))
        return bodySyntax
    }
}
