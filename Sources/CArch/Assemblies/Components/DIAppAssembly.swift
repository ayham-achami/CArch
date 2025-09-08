//
//  AppDIComponents.swift
//

import Foundation

/// Регистрации компоненты приложения в контейнер зависимости
public protocol DIAppAssembly: AnyObject, Sendable, DIAssemblyFactoryDebugger {
    
    /// Компоненты приложения
    static var components: [any DIServicesAssembly.Type] { get }
    
    /// Регистрации компоненты приложения в контейнер зависимости
    /// - Parameter _: Тип фабрики 
    static func registerAppComponents<Factory>(_: Factory.Type) where Factory: DIAssemblyFactory
}

// MARK: - AppDIComponents + Default
public extension DIAppAssembly {
    
    static func registerAppComponents<Factory>(_: Factory.Type) where Factory: DIAssemblyFactory {
        let factory = Factory()
        components.forEach { factory.record($0.init()) }
    }
}
