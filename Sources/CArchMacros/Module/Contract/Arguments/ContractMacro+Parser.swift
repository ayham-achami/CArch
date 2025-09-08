//
//  ContractMacro+Parser.swift
//

import SwiftSyntax
import SwiftSyntaxMacros

// MARK: - ContractMacro + Parser
extension ContractMacro {
    
    /// Парсер аргументов макроса
    enum Parser: ImplementationsParser, AssemblyOptionsParser {
        
        typealias Label = ArgumentsLabel
        
        /// Возвращает аргументы макроса
        /// - Parameters:
        ///   - attributes: `AttributeSyntax`
        ///   - protocolDecl: `ProtocolDeclSyntax`
        ///   - context: `MacroExpansionContext`
        static func arguments(from attributes: AttributeSyntax,
                              decl protocolDecl: ProtocolDeclSyntax,
                              context: some MacroExpansionContext) throws(Parsing.Error) -> Arguments {
            let labeledList = attributes.arguments?.as(LabeledExprListSyntax.self)
            return .init(
                component: try component(from: protocolDecl, with: context),
                visibility: try visibility(from: protocolDecl, with: context),
                options: try options(from: labeledList, with: context),
                implementations: try implementations(from: labeledList, protocolDecl: protocolDecl, with: context)
            )
        }
        
        /// Возвращает CArch component
        /// - Parameters:
        ///   - protocolDecl: `ProtocolDeclSyntax`
        ///   - context: `MacroExpansionContext`
        private static func component(from protocolDecl: ProtocolDeclSyntax,
                                      with context: some MacroExpansionContext) throws(Parsing.Error) -> CArchComponent {
            guard
                let inheritedTypes = protocolDecl.inheritanceClause?.inheritedTypes,
                !inheritedTypes.isEmpty,
                let component = CArchComponent.from(inheritedTypes)
            else { throw Parsing.Error.invalidArgument("'InheritedTypes' Contract protocol must inherited from some CArch component protocol") }
            return component
        }
        
        /// Возвращает область видимости
        /// - Parameters:
        ///   - protocolDecl: `ProtocolDeclSyntax`
        ///   - context: `ProtocolDeclSyntax`
        private static func visibility(from protocolDecl: ProtocolDeclSyntax,
                                       with context: some MacroExpansionContext) throws(Parsing.Error) -> ContractMacro.Arguments.Visibility? {
            if protocolDecl.modifiers.contains([.init(name: .keyword(.public))]) {
                .public
            } else if protocolDecl.modifiers.contains([.init(name: .keyword(.private))]) {
                .private
            } else {
                nil
            }
        }
        
        static func options(from labeledList: LabeledExprListSyntax?,
                            with context: some MacroExpansionContext) throws(Parsing.Error) -> AssemblyOptions {
            do {
                return try options(from: labeledList, label: ArgumentsLabel.options, context: context)
            } catch .missingArgument {
                return []
            } catch {
                throw error
            }
        }
        
        /// Возвращает доступные класс имплементация
        /// - Parameters:
        ///   - labeledList: `LabeledExprListSyntax`
        ///   - protocolDecl: `ProtocolDeclSyntax`
        ///   - context: `MacroExpansionContext`
        private static func implementations(from labeledList: LabeledExprListSyntax?,
                                            protocolDecl: ProtocolDeclSyntax,
                                            with context: some MacroExpansionContext) throws(Parsing.Error) -> [String: String] {
            do {
                return try implementations(from: labeledList, label: ArgumentsLabel.implementations, with: context)
            } catch .missingArgument {
                return ["\(protocolDecl.name.text)Implementation": "default"]
            } catch {
                throw error
            }
        }
    }
}
