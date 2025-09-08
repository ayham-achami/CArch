//
//  AutoResolvableMacro.swift
//

import SwiftDiagnostics
import SwiftSyntax
import SwiftSyntaxMacros

/// Макрос автоматического получения объекта из контерна зависимости
public struct AutoResolvableMacro: MemberMacro {
    
    public  static func expansion(of node: AttributeSyntax,
                                  providingMembersOf declaration: some DeclGroupSyntax,
                                  in context: some MacroExpansionContext) throws -> [DeclSyntax] {
        try checkInitializerDecl(declaration, in: context)
        
        let initializersDecl = if let declaration = declaration.as(StructDeclSyntax.self) {
            try structDeclSyntax(declaration, node, context)
        } else if let declaration = declaration.as(ClassDeclSyntax.self) {
            try classDeclSyntax(declaration, node, context)
        } else if let declaration = declaration.as(ActorDeclSyntax.self) {
            try actorDeclSyntax(declaration, node, context)
        } else {
            throw ObjectMacros.Error.notSupported(Self.self)
        }
        return initializersDecl.map(DeclSyntax.init)
    }
    
    public static func expansion(of node: AttributeSyntax,
                                 providingMembersOf declaration: some DeclGroupSyntax,
                                 conformingTo protocols: [TypeSyntax],
                                 in context: some MacroExpansionContext) throws -> [DeclSyntax] {
        try expansion(of: node, providingMembersOf: declaration, in: context)
    }
}
