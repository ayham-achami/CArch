//
//  Syntax+Record.swift
//

import SwiftSyntax

// MARK: - ContractMacro + CodeBlockItemSyntax.Item + Record
extension CodeBlockItemSyntax.Item {
    
    static func recordExp(from component: CArchComponent, name: String) -> CodeBlockItemSyntax.Item {
        switch component {
        case .some:
            recordSomeExp(name)
        case .pool:
            recordPoolExp(name)
        case .agent:
            recordAgentExp(name)
        case .service:
            recordServiceExp(name)
        case .singleton:
            recordSingletonExp(name)
        case .controller:
            recordControllerExp(name)
        }
    }
    
    private static func recordSomeExp(_ name: String) -> Self {
        .expr("""
        container.record(some: \(raw: name).self) { resolver in
            \(raw: name)(resolver)
        }
        """)
    }
    
    private static func recordPoolExp(_ name: String) -> Self {
        .expr("""
        container.recordPool(\(raw: name).self) { resolver in
            \(raw: name)(resolver)
        }
        """)
    }
    
    private static func recordAgentExp(_ name: String) -> Self {
        .expr("""
        container.recordAgent(\(raw: name).self) { resolver in
            \(raw: name)(resolver)
        }
        """)
    }
    
    private static func recordServiceExp(_ name: String) -> Self {
        .expr("""
        container.recordService(\(raw: name).self) { resolver in
            \(raw: name)(resolver)
        }
        """)
    }
    
    private static func recordSingletonExp(_ name: String) -> Self {
        .expr("""
        container.recordSingleton(\(raw: name).self) { resolver in
            \(raw: name)(resolver)
        }
        """)
    }
    
    private static func recordControllerExp(_ name: String) -> Self {
        .expr("""
        container.recordController(\(raw: name).self) { resolver in
            \(raw: name)(resolver)
        }
        """)
    }
}
