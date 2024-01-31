//
//  ProtocolDeclSyntax+Inheritance.swift
//

import SwiftDiagnostics
import SwiftSyntax
import SwiftSyntaxMacros

// MARK: - ProtocolDeclSyntax + Inheritance
extension ProtocolDeclSyntax {
    
    /// <#Description#>
    /// - Parameters:
    ///   - inheritance: <#inheritance description#>
    ///   - context: <#context description#>
    func checkInheritanceSpecifier(from inheritance: String, in context: some MacroExpansionContext) throws {
        let newProtocolDecl: ProtocolDeclSyntax
        if let inheritanceClause = inheritanceClause {
            let inheritedTypes = inheritanceClause
                .inheritedTypes
                .compactMap { $0.type.as(IdentifierTypeSyntax.self)?.name.text }
            guard
                !inheritedTypes.contains(inheritance)
            else { return }
            var newInheritedTypes = inheritedTypes
                .map { IdentifierTypeSyntax(name: .identifier($0)) }
                .map { InheritedTypeSyntax(leadingTrivia: .space, type: $0, trailingComma: .commaToken())}
            newInheritedTypes.append(InheritedTypeSyntax(leadingTrivia: .space,
                                                         type: IdentifierTypeSyntax(name: .identifier(inheritance)),
                                                         trailingTrivia: .space))
            newProtocolDecl = with(\.inheritanceClause, InheritanceClauseSyntax { .init(newInheritedTypes) })
        } else {
            let inheritanceType = IdentifierTypeSyntax(leadingTrivia: .space, name: .identifier(inheritance))
            let inheritedTypeSyntax = InheritedTypeSyntax(type: inheritanceType, trailingTrivia: .space)
            newProtocolDecl = with(\.inheritanceClause, InheritanceClauseSyntax { .init([inheritedTypeSyntax]) })
        }
        
        let messageID = MessageID(domain: String(describing: ContractMacro.self), id: inheritance)
        let fixItMessage = Diagnostics.Message(message: "add inheritance from \(inheritance)", diagnosticID: messageID, severity: .error)
        let diagnosticMessage = Diagnostics.Message(message: "Macro can be applied to protocols inherited from \(inheritance) only", diagnosticID: messageID, severity: .error)
        let changes = [FixIt.Change.replace(oldNode: .init(self), newNode: .init(newProtocolDecl))]
        let fixIt = FixIt(message: fixItMessage, changes: changes)
        let diagnostic = Diagnostic(node: Syntax(protocolKeyword), message: diagnosticMessage, fixIts: [fixIt])
        context.diagnose(diagnostic)
    }
}
