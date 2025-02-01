//
//  MemberSyntax+Variable.swift
//

import SwiftSyntax

// MARK: - MemberBlockItemListSyntax + Variable
extension MemberBlockItemListSyntax {
    
    func variable(exclude modifiers: [DeclModifierSyntax]) -> [VariableDeclSyntax] {
        compactMap { $0.decl.as(VariableDeclSyntax.self) }.filter { !$0.modifiers.contains(modifiers) }
    }
}

// MARK: - DeclModifierListSyntax + Contains
extension DeclModifierListSyntax {
    
    func contains(_ modifiers: [DeclModifierSyntax]) -> Bool {
        contains { modifier in modifiers.contains { $0.name.text == modifier.name.text } }
    }
}

// MARK: - DeclModifierSyntax + Static
extension DeclModifierSyntax {
    
    static var `static`: Self { .init(name: .keyword(.static)) }
}

// MARK: - PatternSyntax + Raw
extension PatternSyntax {
    
    var raw: String? {
        self.as(IdentifierPatternSyntax.self)?.identifier.text
    }
}

// MARK: - TypeSyntax + Raw
extension TypeSyntax {
    
    var raw: String? {
        self.as(IdentifierTypeSyntax.self)?.name.text
    }
}
