import SwiftSyntax
import SwiftDiagnostics
import SwiftSyntaxMacros
import SwiftSyntaxBuilder

/// <#Description#>
public struct SyncAliasMacro: ExtensionMacro {
    
    public static func expansion(of node: AttributeSyntax,
                                 attachedTo declaration: some DeclGroupSyntax,
                                 providingExtensionsOf type: some TypeSyntaxProtocol,
                                 conformingTo protocols: [TypeSyntax],
                                 in context: some MacroExpansionContext) throws -> [ExtensionDeclSyntax] {
        guard
            let protocolDecl = declaration.as(ProtocolDeclSyntax.self)
        else { throw ProtocolsMacros.Error.notProtocol }
        
        try checkInheritanceSpecifier(to: protocolDecl, in: context)
        
        let asyncFunctions = asyncFunctions(from: protocolDecl)
        let asyncThrowsFunctions = asyncThrowsFunctions(from: protocolDecl)
        
        let protocolName = protocolDecl.identifier.text
        let extensionDecl = try ExtensionDeclSyntax("extension \(raw: protocolName)") {
            for asyncFunction in asyncFunctions {
                asyncFunction
            }
            for asyncThrowsFunction in asyncThrowsFunctions {
                asyncThrowsFunction
            }
        }
        
        return [extensionDecl]
    }
    
    /// <#Description#>
    /// - Parameters:
    ///   - protocolDecl: <#protocolDecl description#>
    ///   - context: <#context description#>
    private static func checkInheritanceSpecifier(to protocolDecl: ProtocolDeclSyntax, in context: some MacroExpansionContext) throws {
        let errorAsyncHandler = "ErrorAsyncHandler"
        let newProtocolDecl: ProtocolDeclSyntax
        if let inheritanceClause = protocolDecl.inheritanceClause {
            let inheritedTypes = inheritanceClause
                .inheritedTypeCollection
                .map(\.typeName)
                .compactMap({ $0.as(SimpleTypeIdentifierSyntax.self) })
                .map(\.name)
                .map(\.text)
            guard
                !inheritedTypes.contains(errorAsyncHandler)
            else { return }
            var newInheritedTypes = inheritedTypes
                .map { SimpleTypeIdentifierSyntax(name: .identifier($0)) }
                .map { InheritedTypeSyntax(leadingTrivia: .space, typeName: $0, trailingComma: .commaToken())}
            newInheritedTypes.append(InheritedTypeSyntax(leadingTrivia: .space,
                                                         typeName: SimpleTypeIdentifierSyntax(name: .identifier(errorAsyncHandler)),
                                                         trailingTrivia: .space))
            newProtocolDecl = protocolDecl.with(\.inheritanceClause, TypeInheritanceClauseSyntax { .init(newInheritedTypes) })
        } else {
            let inheritanceType = SimpleTypeIdentifierSyntax(leadingTrivia: .space, name: .identifier(errorAsyncHandler))
            let inheritedTypeSyntax = InheritedTypeSyntax(typeName: inheritanceType, trailingTrivia: .space)
            newProtocolDecl = protocolDecl.with(\.inheritanceClause, TypeInheritanceClauseSyntax { .init([inheritedTypeSyntax]) })
        }
        
        let messageID = MessageID(domain: String(describing: SyncAliasMacro.self), id: errorAsyncHandler)
        let fixItMessage = Diagnostics.Message(message: "add inheritance from \(errorAsyncHandler)", diagnosticID: messageID, severity: .error)
        let diagnosticMessage = Diagnostics.Message(message: "SyncAliasMacro can be applied to protocols inherited from \(errorAsyncHandler) only", diagnosticID: messageID, severity: .error)
        let changes = [FixIt.Change.replace(oldNode: .init(protocolDecl), newNode: .init(newProtocolDecl))]
        let fixIt = FixIt(message: fixItMessage, changes: changes)
        let diagnostic = Diagnostic(node: Syntax(protocolDecl.protocolKeyword), message: diagnosticMessage, fixIts: [fixIt])
        context.diagnose(diagnostic)
    }
    
    /// <#Description#>
    /// - Parameter protocolDecl: <#protocolDecl description#>
    /// - Returns: <#description#>
    private static func asyncFunctions(from protocolDecl: ProtocolDeclSyntax) -> [FunctionDeclSyntax] {
        protocolDecl
            .memberBlock
            .members
            .compactMap { $0.decl.as(FunctionDeclSyntax.self) }
            .filter { $0.signature.effectSpecifiers?.asyncSpecifier != nil && $0.signature.effectSpecifiers?.throwsSpecifier == nil }
            .compactMap {
                $0.with(\.signature, $0.signature.with(\.effectSpecifiers, $0.signature.effectSpecifiers?
                    .with(\.asyncSpecifier, nil))
                    .with(\.output, nil)
                    .with(\.input, $0.signature.input))
                .with(\.body, .awaitSyntax($0))
            }
    }
    
    /// <#Description#>
    /// - Parameter protocolDecl: <#protocolDecl description#>
    /// - Returns: <#description#>
    private static func asyncThrowsFunctions(from protocolDecl: ProtocolDeclSyntax) -> [FunctionDeclSyntax] {
        protocolDecl
            .memberBlock
            .members
            .compactMap { $0.decl.as(FunctionDeclSyntax.self) }
            .filter { $0.signature.effectSpecifiers?.asyncSpecifier != nil && $0.signature.effectSpecifiers?.throwsSpecifier != nil }
            .compactMap {
                $0.with(\.signature, $0.signature.with(\.effectSpecifiers, $0.signature.effectSpecifiers?
                    .with(\.asyncSpecifier, nil)
                    .with(\.throwsSpecifier, nil))
                    .with(\.output, nil)
                    .with(\.input, $0.signature.input))
                .with(\.body, .tryAwaitSyntax($0))
            }
    }
}
