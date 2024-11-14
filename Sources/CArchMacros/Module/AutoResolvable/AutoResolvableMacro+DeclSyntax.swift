//
//  AutoResolvableMacro+DeclSyntax.swift
//

import SwiftSyntax
import SwiftSyntaxMacros

// MARK: - AutoResolvableMacro + DeclSyntax
extension AutoResolvableMacro {
    
    /// <#Description#>
    /// - Parameters:
    ///   - decl: <#decl description#>
    ///   - attributes: <#attributes description#>
    ///   - context: <#context description#>
    /// - Returns: <#description#>
    static func structDeclSyntax(_ decl: StructDeclSyntax,
                                 _ attributes: SwiftSyntax.AttributeSyntax,
                                 _ context: some MacroExpansionContext) throws -> [InitializerDeclSyntax] {
        let arguments = try Parser.arguments(from: attributes, decl: decl, context: context)
        if arguments.options.contains(.convenience) {
            throw ArgumentsType.Error.notSupported("Initializers in structs are not marked with 'convenience'")
        }
        if arguments.options.contains(.required) {
            throw ArgumentsType.Error.notSupported("'required' initializer in non-class type")
        }
        return try initializerDeclSyntax(arguments, decl.memberBlock.members, context)
    }
    
    /// <#Description#>
    /// - Parameters:
    ///   - decl: <#decl description#>
    ///   - attributes: <#attributes description#>
    ///   - context: <#context description#>
    /// - Returns: <#description#>
    static func classDeclSyntax(_ decl: ClassDeclSyntax,
                                _ attributes: SwiftSyntax.AttributeSyntax,
                                _ context: some MacroExpansionContext) throws -> [InitializerDeclSyntax] {
        let arguments = try Parser.arguments(from: attributes, decl: decl, context: context, defaultOptions: [.convenience])
        return try initializerDeclSyntax(arguments, decl.memberBlock.members, context)
    }
    
    /// <#Description#>
    /// - Parameters:
    ///   - decl: <#decl description#>
    ///   - attributes: <#attributes description#>
    ///   - context: <#context description#>
    /// - Returns: <#description#>
    static func actorDeclSyntax(_ decl: ActorDeclSyntax,
                                _ attributes: SwiftSyntax.AttributeSyntax,
                                _ context: some MacroExpansionContext) throws -> [InitializerDeclSyntax] {
        let arguments = try Parser.arguments(from: attributes, decl: decl, context: context)
        if arguments.options.contains(.convenience) {
            throw ArgumentsType.Error.notSupported("Initializers in actor are not marked with 'convenience'")
        }
        if arguments.options.contains(.required) {
            throw ArgumentsType.Error.notSupported("'required' initializer in non-class type")
        }
        return try initializerDeclSyntax(arguments, decl.memberBlock.members, context)
    }
}
