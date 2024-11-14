//
//  MemberBlockItemListSyntax+Variable.swift
//

import SwiftSyntax

extension MemberBlockItemListSyntax {
    
    func variable(exclude modifiers: [DeclModifierSyntax]) -> [VariableDeclSyntax] {
        compactMap { $0.decl.as(VariableDeclSyntax.self) }.filter { !$0.modifiers.contains(modifiers) }
    }
}

extension DeclModifierListSyntax {
    
    func contains(_ modifiers: [DeclModifierSyntax]) -> Bool {
        contains { modifier in modifiers.contains { $0.name.text == modifier.name.text } }
    }
}

extension DeclModifierSyntax {
    
    static var `static`: Self { .init(name: .keyword(.static)) }
}

extension PatternSyntax {
    
    var raw: String? {
        self.as(IdentifierPatternSyntax.self)?.identifier.text
    }
}

extension TypeSyntax {
    
    var raw: String? {
        self.as(IdentifierTypeSyntax.self)?.name.text
    }
}
