//
//  CodeBlockItemSyntax+Unravel.swift
//

import SwiftSyntax

// MARK: - ContractMacro + CodeBlockItemSyntax.Item + Unravel
extension CodeBlockItemSyntax.Item {

    static func unravelExp(from component: ContractMacro.Arguments.Component, name: String) -> CodeBlockItemSyntax.Item {
        switch component {
        case .pool:
            return unravelPoolExp(name)
        case .agent:
            return unravelAgentExp(name)
        case .service:
            return unravelServiceExp(name)
        case .singleton:
            return unravelSingletonExp(name)
        }
    }
    
    private static func unravelPoolExp(_ name: String) -> Self {
        .expr("""
        resolver.unravelPool(\(raw: name).self)
        """)
    }
    
    private static func unravelAgentExp(_ name: String) -> Self {
        .expr("""
        resolver.unravelAgent(\(raw: name).self)
        """)
    }
    
    private static func unravelServiceExp(_ name: String) -> Self {
        .expr("""
        resolver.unravelService(\(raw: name).self)
        """)
    }
    
    private static func unravelSingletonExp(_ name: String) -> Self {
        .expr("""
        resolver.unravelSingleton(\(raw: name).self)
        """)
    }
}
