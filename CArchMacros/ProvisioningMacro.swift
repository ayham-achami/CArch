import SwiftSyntax
import SwiftDiagnostics
import SwiftSyntaxMacros
import SwiftSyntaxBuilder

public struct ProvisioningMacro {
    
    public enum Error: Swift.Error, CustomStringConvertible {
        
        case notProtocol
        
        public var description: String {
            switch self {
            case .notProtocol:
                return "Provisioning Macro can be applied to protocols only"
            }
        }
    }
    
    struct Message: DiagnosticMessage, FixItMessage, Swift.Error {
        
        let message: String
        let diagnosticID: MessageID
        let severity: DiagnosticSeverity
        
        var fixItID: MessageID { diagnosticID }
    }
}

extension ProvisioningMacro: ExtensionMacro {
    
    public static func expansion(of node: AttributeSyntax,
                                 attachedTo declaration: some DeclGroupSyntax,
                                 providingExtensionsOf type: some TypeSyntaxProtocol,
                                 conformingTo protocols: [TypeSyntax],
                                 in context: some MacroExpansionContext) throws -> [ExtensionDeclSyntax] {
        guard
            let protocolDecl = declaration.as(ProtocolDeclSyntax.self)
        else { throw Error.notProtocol }
        
        let asyncFunctions = protocolDecl
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
        
        let asyncThrowsFunctions = protocolDecl
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
}




