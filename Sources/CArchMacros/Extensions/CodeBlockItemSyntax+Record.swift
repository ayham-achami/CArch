//
//  CodeBlockItemSyntax+Record.swift
//

import SwiftSyntax

// MARK: - ContractMacro + CodeBlockItemSyntax.Item + Record
extension CodeBlockItemSyntax.Item {
    
    static func recordExp(from component: ContractMacro.Arguments.Component, name: String) -> CodeBlockItemSyntax.Item {
        switch component {
        case .pool:
            return recordPoolExp(name)
        case .agent:
            return recordAgentExp(name)
        case .service:
            return recordServiceExp(name)
        case .singleton:
            return recordSingletonExp(name)
        }
    }
    
    private static func recordPoolExp(_ name: String) -> Self {
        .expr("""
        container.recordPool(\(raw: name).self) { resolver in
            .init(resolver)
        }
        """)
    }
    
    private static func recordAgentExp(_ name: String) -> Self {
        .expr("""
        container.recordAgent(\(raw: name).self) { resolver in
            .init(resolver)
        }
        """)
    }
    
    private static func recordServiceExp(_ name: String) -> Self {
        .expr("""
        container.recordService(\(raw: name).self) { resolver in
            .init(resolver)
        }
        """)
    }
    
    private static func recordSingletonExp(_ name: String) -> Self {
        .expr("""
        container.recordSingleton(\(raw: name).self) { resolver in
            .init(resolver)
        }
        """)
    }
}
