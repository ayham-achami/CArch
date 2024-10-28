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
    @available(*, deprecated, message: "This feature has be deprecated and will be removed in future release")
    func record<Recorder>(_ recorder: Recorder.Type) where Recorder: ServicesRecorder
    
    /// Выполнять регистрации всех сервисов бизнес логики в контейнер зависимости
    /// - Parameter recorder: Класс отвечающий за создание всех серверов
    func record<Recorder>(_ recorder: Recorder) where Recorder: DIAssemblyCollection
}

#if canImport(UIKit)
/// Протокол получения доступа к контейнеру зависимости с Storyboard
@available(*, deprecated, message: "This feature has be deprecated and will be removed in future release")
public protocol StoryboardDIAssemblyFactory: AnyDIAssemblyFactory {
    
    /// Контейнер зависимости
    var storyboardContainer: DIStoryboardContainer { get }
    
    /// Внедрение зависимости для Storyboard
    var storyboard: DIStoryboard { get }
    
    /// Регистрирует компонент модуля в контейнер зависимости
    /// - Parameter module: Модуль
    /// - Returns: Модуль после регистрации
    func assembly<Module>(_ module: Module) -> Module where Module: StoryboardModuleAssembly
}
#endif

/// Протокол получения доступа к контейнеру зависимости
public protocol LayoutDIAssemblyFactory: AnyDIAssemblyFactory {

    /// Контейнер зависимости
    var layoutContainer: DIContainer { get }
    
    /// Регистрирует компонент модуля в контейнер зависимости
    /// - Parameter module: Модуль
    /// - Returns: Модуль после регистрации
    func assembly<Module>(_ module: Module) -> Module where Module: LayoutModuleAssembly
}
