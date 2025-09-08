//
//  AssemblableMacro+Parser.swift
//
import SwiftSyntax
import SwiftSyntaxMacros

// MARK: - AutoResolvableMacro + Parser
extension AssemblableMacro {
    
    /// Парсер аргументов макроса
    enum Parser: AssemblyOptionsParser, AssemblyBehaviorParser {
        
        typealias Label = ArgumentLabel
        
        static func arguments(from node: AttributeSyntax,
                              declaration: some DeclSyntaxProtocol,
                              context: some MacroExpansionContext) throws(Parsing.Error) -> Arguments {
            .init(
                type: try type(from: declaration, context: context),
                options: try options(from: node.arguments?.as(LabeledExprListSyntax.self), context: context),
                behavior: try behavior(from: node.arguments?.as(LabeledExprListSyntax.self), context: context)
            )
        }
        
        private static func type(from declaration: some DeclSyntaxProtocol, context: some MacroExpansionContext) throws(Parsing.Error) -> String {
            if let classDecl = declaration.as(ClassDeclSyntax.self) {
                classDecl.name.text
            } else if let actorDecl = declaration.as(ActorDeclSyntax.self) {
                actorDecl.name.text
            } else if let structDecl = declaration.as(StructDeclSyntax.self) {
                structDecl.name.text
            } else {
                throw Parsing.Error.invalidArgument("Must be a class, actor or struct, object declaration")
            }
        }
        
        private static func options(from labeledList: LabeledExprListSyntax?, context: some MacroExpansionContext) throws(Parsing.Error) -> AssemblyOptions {
            do {
                return try options(from: labeledList, label: .options, context: context)
            } catch .missingArgument {
                return []
            } catch {
                throw error
            }
        }
        
        private static func behavior(from labeledList: LabeledExprListSyntax?, context: some MacroExpansionContext) throws(Parsing.Error) -> AssemblyBehavior {
            do {
                return try behavior(from: labeledList, label: .behavior, context: context)
            } catch .missingArgument {
                return .auto
            } catch {
                throw error
            }
        }
    }
}
