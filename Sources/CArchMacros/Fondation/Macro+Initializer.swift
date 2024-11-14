//
//  Macro+Initializer.swift
//

import SwiftDiagnostics
import SwiftSyntax
import SwiftSyntaxMacros

// MARK: - Macro + Initializer
extension Macro {
    
    /// <#Description#>
    /// - Parameters:
    ///   - declGroupSyntax: <#declGroupSyntax description#>
    ///   - context: <#context description#>
    static func checkInitializerDecl(_ declGroupSyntax: DeclGroupSyntax, in context: some MacroExpansionContext) throws {
        let initializers = declGroupSyntax.memberBlock.members.map(\.decl).compactMap { $0.as(InitializerDeclSyntax.self) }
        guard !initializers.isEmpty else { return }
        let newDeclGroupSyntax = declGroupSyntax.with(\.memberBlock.members, declGroupSyntax.memberBlock.members.filter { !$0.decl.is(InitializerDeclSyntax.self) })
        let domain = String(describing: Self.self)
        let messageID = MessageID(domain: domain, id: "")
        let fixItMessage = Diagnostics.Message(message: "Remove initializer", diagnosticID: messageID, severity: .error)
        let diagnosticMessage = Diagnostics.Message(message: "\(domain) can be applied to object don't have initializer only", diagnosticID: messageID, severity: .error)
        let changes = [FixIt.Change.replace(oldNode: .init(declGroupSyntax), newNode: .init(newDeclGroupSyntax))]
        let fixIt = FixIt(message: fixItMessage, changes: changes)
        let diagnostic = Diagnostic(node: declGroupSyntax, message: diagnosticMessage, fixIts: [fixIt])
        context.diagnose(diagnostic)
    }
}
