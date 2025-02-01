//
//  CArchComponent.swift
//

import SwiftSyntax

/// CArch component
enum CArchComponent {
    
    case some
    case pool
    case agent
    case service
    case singleton
    case controller
}

// MARK: - CArchComponent + Parsing
extension CArchComponent {
    
    /// Получить CArch component из Syntax
    /// - Parameter list: Syntax
    /// - Returns: `CArchComponent`
    static func from(_ list: InheritedTypeListSyntax) -> Self? {
        if list.contains("BusinessLogicAgent") { .agent } else
        if list.contains("BusinessLogicService") { .service } else
        if list.contains("BusinessLogicController") { .controller } else
        if list.contains("BusinessLogicSingleton") { .singleton } else
        if list.contains("BusinessLogicServicePool") { .pool } else { nil }
    }
    
    /// Получить CArch component из строки
    /// - Parameter type: Страка
    /// - Returns: `CArchComponent`
    static func from(_ type: String) -> Self? {
        if type.hasSuffix("Agent") || type.hasSuffix("AgentImplementation") { .agent } else
        if type.hasSuffix("Service") || type.hasSuffix("ServiceImplementation") { .service } else
        if type.hasSuffix("Controller") || type.hasSuffix("ControllerImplementation") { .controller } else
        if type.hasSuffix("Singleton") || type.hasSuffix("SingletonImplementation") { .singleton } else
        if type.hasSuffix("Pool") || type.hasSuffix("PoolImplementation") { .pool } else { nil }
    }
}
