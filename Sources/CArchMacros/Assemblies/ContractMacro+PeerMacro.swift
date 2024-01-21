//
//  ContractMacro+PeerMacro.swift
//

import SwiftDiagnostics
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

// MARK: - ContractMacro + PeerMacro
extension ContractMacro: PeerMacro {
    
    public static func expansion(of node: SwiftSyntax.AttributeSyntax,
                                 providingPeersOf declaration: some SwiftSyntax.DeclSyntaxProtocol,
                                 in context: some SwiftSyntaxMacros.MacroExpansionContext) throws -> [SwiftSyntax.DeclSyntax] {
        guard
            let protocolDecl = declaration.as(ProtocolDeclSyntax.self)
        else { throw ProtocolsMacros.Error.notProtocol(Self.self) }
        
        try protocolDecl.checkInheritanceSpecifier(from: "AutoResolve", in: context)
        let arguments = try Parser.arguments(from: node, decl: protocolDecl, context: context)
        
        return [.init(try implementationsEnum(protocolDecl, arguments)),
                .init(try assembleClass(protocolDecl, arguments)),
                .init(try resolverClass(protocolDecl, arguments))]
    }
}
