//
//  AssemblyFactory.swift
//

import Foundation

/// Контейнер зависимости
public typealias DIContainer = DIRegistrar & DIResolver

/// Протокол внедрения зависимости
public protocol DIAssembly: Sendable {

    /// Предоставить хук для «Ассемблера» для загрузки сервисов в предоставленный контейнер
    /// - Parameter container: контейнер, предоставленный «Ассемблером»
    func assemble(container: DIContainer)
}

/// Коллекция объектов для добавления в контейнер зависимости
public protocol DIAssemblyCollection: Collection, Sendable {
    
    /// Коллекция объектов
    var services: [DIAssembly] { get }
}

// MARK: - ServicesDICollection + Default
public extension DIAssemblyCollection {
    
    var startIndex: Int {
        services.startIndex
    }
    
    var endIndex: Int {
        services.endIndex
    }
    
    subscript(position: Int) -> DIAssembly {
        services[position]
    }
    
    func index(after index: Int) -> Int {
        services.index(after: index)
    }
}

/// Протокол регулировки уровня логирования
public protocol DIAssemblyFactoryDebugger: Sendable {
    
    /// Регулировки уровня логирования
    /// - Parameter isDebugEnabled: Вкл/Выкл
    static func set(isDebugEnabled: Bool)
}

/// Протокол получения доступа к контейнеру зависимости
public protocol DIAssemblyFactory: DIAssemblyFactoryDebugger {
    
    /// Контейнер зависимости
    var container: DIContainer { get }
    
    /// Объект отвечающий за регистрацию сервиса в контейнер зависимости
    var registrar: DIRegistrar { get }

    /// Объект отвечающий за получение сервиса из контейнера зависимости
    var resolver: DIResolver { get }
    
    /// Инициализации без параметров
    init()
    
    /// Выполнять регистрации всех сервисов бизнес логики в контейнер зависимости
    /// - Parameter recorder: Класс отвечающий за создание всех серверов
    func record<Recorder>(_ recorder: Recorder) where Recorder: DIAssemblyCollection
    
    /// Регистрирует компонент модуля в контейнер зависимости
    /// - Parameter module: Модуль
    /// - Returns: Модуль после регистрации
    func assembly<Module>(_ module: Module) -> Module where Module: ModuleAssembly
}

/// Протокол получения доступа к контейнеру зависимости
@available(*, deprecated, renamed: "DIAssemblyFactory", message: "Use new object")
public typealias LayoutDIAssemblyFactory = DIAssemblyFactory
