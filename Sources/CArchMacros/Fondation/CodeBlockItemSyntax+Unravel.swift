//
//  CodeBlockItemSyntax+Unravel.swift
//

import SwiftSyntax

// MARK: - ContractMacro + CodeBlockItemSyntax.Item + Unravel
extension CodeBlockItemSyntax.Item {
    
    static func unravelExp(from component: ContractMacro.Arguments.Component, name: String) -> CodeBlockItemSyntax.Item {
        switch component {
        case .pool:
            unravelPoolExp(name)
        case .agent:
            unravelAgentExp(name)
        case .service:
            unravelServiceExp(name)
        case .singleton:
            unravelSingletonExp(name)
        case .controller:
            unravelControllerExp(name)
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
    
    private static func unravelControllerExp(_ name: String) -> Self {
        .expr("""
        resolver.unravelController(\(raw: name).self)
        """)
    }
}
