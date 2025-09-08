//
//  AutoResolvableMacro+DeclSyntax.swift
//

import SwiftSyntax
import SwiftSyntaxMacros

// MARK: - AutoResolvableMacro + DeclSyntax
extension AutoResolvableMacro {
    
    static func structDeclSyntax(_ decl: StructDeclSyntax,
                                 _ attributes: SwiftSyntax.AttributeSyntax,
                                 _ context: some MacroExpansionContext) throws -> [InitializerDeclSyntax] {
        let arguments = try Parser.arguments(from: attributes, declSyntax: decl, context: context)
        if arguments.options.contains(.convenience) {
            throw Diagnostics.Error.unsupported("Initializers in structs are not marked with 'convenience'")
        }
        if arguments.options.contains(.required) {
            throw Diagnostics.Error.unsupported("'required' initializer in non-class type")
        }
        return try initializerDeclSyntax(arguments, decl.memberBlock.members, context)
    }
    
    static func classDeclSyntax(_ decl: ClassDeclSyntax,
                                _ attributes: SwiftSyntax.AttributeSyntax,
                                _ context: some MacroExpansionContext) throws -> [InitializerDeclSyntax] {
        let arguments = try Parser.arguments(from: attributes, declSyntax: decl, context: context)
        return try initializerDeclSyntax(arguments, decl.memberBlock.members, context)
    }
    
    static func actorDeclSyntax(_ decl: ActorDeclSyntax,
                                _ attributes: SwiftSyntax.AttributeSyntax,
                                _ context: some MacroExpansionContext) throws -> [InitializerDeclSyntax] {
        let arguments = try Parser.arguments(from: attributes, declSyntax: decl, context: context)
        if arguments.options.contains(.convenience) {
            throw Diagnostics.Error.unsupported("Initializers in actor are not marked with 'convenience'")
        }
        if arguments.options.contains(.required) {
            throw Diagnostics.Error.unsupported("'required' initializer in non-class type")
        }
        return try initializerDeclSyntax(arguments, decl.memberBlock.members, context)
    }
}
