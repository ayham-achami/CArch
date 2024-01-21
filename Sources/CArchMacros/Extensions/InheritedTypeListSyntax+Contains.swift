//
//  InheritedTypeListSyntax+Contains.swift
//

import SwiftSyntax

// MARK: - InheritedTypeListSyntax + Contains
extension InheritedTypeListSyntax {
    
    func contains(_ type: String) -> Bool {
        compactMap {
            $0.type.as(IdentifierTypeSyntax.self)?.name.text
        }.contains(type)
    }
    
    func contains<Inherited>(_: Inherited.Type) -> Bool {
        contains(String(describing: Inherited.self))
    }
}
