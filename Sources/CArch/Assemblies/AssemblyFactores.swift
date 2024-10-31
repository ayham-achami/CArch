//
//  AssemblyFactory.swift
//

import Foundation

/// Протокол регулировки уровня логирования
public protocol DIAssemblyFactoryDebugger: Sendable {
    
    /// Регулировки уровня логирования
    /// - Parameter isDebugEnabled: Вкл/Выкл
    static func set(isDebugEnabled: Bool)
}

/// Протокол получения доступа к контейнеру зависимости
public protocol AnyDIAssemblyFactory: DIAssemblyFactoryDebugger {
    
    /// Объект отвечающий за регистрацию сервиса в контейнер зависимости
    var registrar: DIRegistrar { get }

    /// Объект отвечающий за получение сервиса из контейнера зависимости
    var resolver: DIResolver { get }
    
    /// Инициализации без параметров
    init()
    
    /// Выполнять регистрации всех сервисов бизнес логики в контейнер зависимости
    /// - Parameter recorder: Класс отвечающий за создание всех серверов
    func record<Recorder>(_ recorder: Recorder) where Recorder: DIAssemblyCollection
}

/// Протокол получения доступа к контейнеру зависимости
public protocol LayoutDIAssemblyFactory: AnyDIAssemblyFactory {

    /// Контейнер зависимости
    var layoutContainer: DIContainer { get }
    
    /// Регистрирует компонент модуля в контейнер зависимости
    /// - Parameter module: Модуль
    /// - Returns: Модуль после регистрации
    func assembly<Module>(_ module: Module) -> Module where Module: LayoutModuleAssembly
}
