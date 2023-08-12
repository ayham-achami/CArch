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
        let nonisolatedFunctions = appdendNonisolated(to: functions)
        let extensionDecl = try ExtensionDeclSyntax("extension \(raw: protocolDecl.name.text)") {
            for function in nonisolatedFunctions {
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
                $0.signature.returnClause == nil
            }
    }
    
    /// <#Description#>
    /// - Parameter functions: <#functions description#>
    /// - Returns: <#description#>
    private static func appdendNonisolated(to functions: [FunctionDeclSyntax]) -> [FunctionDeclSyntax] {
        functions.compactMap {
            $0.with(\.name, .identifier("nonisolated\($0.name.text.capitalized)"))
                .with(\.modifiers, appdendNonisolated(to: $0.modifiers))
                .with(\.body, .awaitSyntax($0))
                .with(\.leadingTrivia, .newline)
                .with(\.funcKeyword, .keyword(.func))
                .with(\.leadingTrivia, .newline)
        }
    }
    
    /// <#Description#>
    /// - Parameter modifiers: <#modifiers description#>
    /// - Returns: <#description#>
    private static func appdendNonisolated(to modifiers: DeclModifierListSyntax?) -> DeclModifierListSyntax {
        let newModifiers: DeclModifierListSyntax
        if let modifiers {
            var modifiers = modifiers
            modifiers.append(.init(name: .keyword(.nonisolated)))
            newModifiers = modifiers
        } else {
            newModifiers = .init(itemsBuilder: {
                DeclModifierSyntax(name: .keyword(.nonisolated))
            })
        }
        return newModifiers
    }
}
