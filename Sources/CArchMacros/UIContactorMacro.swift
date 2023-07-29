import SwiftSyntax
import SwiftDiagnostics
import SwiftSyntaxMacros
import SwiftSyntaxBuilder

public struct UIContactorMacro: ExtensionMacro {
    
    public static func expansion(of node: AttributeSyntax,
                                 attachedTo declaration: some DeclGroupSyntax,
                                 providingExtensionsOf type: some TypeSyntaxProtocol,
                                 conformingTo protocols: [TypeSyntax],
                                 in context: some MacroExpansionContext) throws -> [ExtensionDeclSyntax] {
        guard
            let protocolDecl = declaration.as(ProtocolDeclSyntax.self)
        else { throw ProtocolsMacros.Error.notProtocol }
            
        let functions = functions(from: protocolDecl)
        
        let protocolName = protocolDecl.identifier.text
        let extensionDecl = try ExtensionDeclSyntax("extension \(raw: protocolName)") {
            for function in functions {
                function
            }
        }
        return [extensionDecl]
    }
    
    /// <#Description#>
    /// - Parameter protocolDecl: <#protocolDecl description#>
    /// - Returns: <#description#>
    private static func functions(from protocolDecl: ProtocolDeclSyntax) -> [FunctionDeclSyntax] {
        protocolDecl
            .memberBlock
            .members
            .compactMap { $0.decl.as(FunctionDeclSyntax.self) }
            .filter {
                $0.signature.effectSpecifiers?.asyncSpecifier == nil &&
                $0.signature.effectSpecifiers?.throwsSpecifier == nil &&
                $0.signature.output == nil
            }
            .compactMap {
                $0.with(\.identifier, .identifier("async\($0.identifier.text.capitalized)"))
                    .with(\.signature, $0.signature)
                    .with(\.body, .awaitSyntax($0))
            }
    }
}

