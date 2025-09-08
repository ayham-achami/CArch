//
//  DIRegistrar.swift
//

import Foundation

/// Протокол внедрения объектов бизнес логики в контейнер зависимости
public protocol BusinessLogicRegistrar: Sendable {
    
    /// Регистрация агента в контейнер зависимости
    /// - Parameters:
    ///   - agentType: Тип агента
    ///   - factory: Блок содержащий код реализующий логику инициализация объекта
    ///   - completed: Замыкание завершения инициализации
    func recordAgent<Agent>(_: Agent.Type,
                            factory: @escaping (DIResolver) -> Agent,
                            completed: ((DIResolver, Agent) -> Void)?) where Agent: BusinessLogicAgent
    
    /// Регистрация сервиса в контейнер зависимости
    /// - Parameters:
    ///   - serviceType: Тип сервиса
    ///   - factory: Блок содержащий код реализующий логику инициализация объекта
    ///   - completed: Замыкание завершения инициализации
    func recordService<Service>(_: Service.Type,
                                factory: @escaping (DIResolver) -> Service,
                                completed: ((DIResolver, Service) -> Void)?) where Service: BusinessLogicService

    /// Регистрация контролера в контейнер зависимости
    /// - Parameters:
    ///   - controller: Тип контролера
    ///   - isSingleton: Надо ли зарегистрировать как
    ///   - factory: Блок содержащий код реализующий логику инициализация объекта
    func recordController(_ controller: (some BusinessLogicController).Type,
                          isSingleton: Bool,
                          factory: @escaping (DIResolver) -> some BusinessLogicController)
    
    /// Регистрация двигателя в контейнер зависимости
    /// - Parameters:
    ///   - engineType: Тип двигателя
    ///   - configuration: Конфигурация двигателя
    ///   - factory: Блок содержащий код реализующий логику инициализация объекта
    ///   - completed: Замыкание завершения инициализации
    func recordEngine<Engine>(_: Engine.Type,
                              configuration: EngineConfiguration,
                              factory: @escaping (DIResolver) -> Engine,
                              completed: ((DIResolver, Engine) -> Void)?) where Engine: BusinessLogicEngine
    
    /// Регистрация множество сервисов в контейнер зависимости
    /// - Parameters:
    ///   - poolType: Тип множества
    ///   - factory: Блок содержащий код реализующий логику инициализация объекта
    ///   - completed: Замыкание завершения инициализации
    func recordPool<Pool>(_: Pool.Type,
                          factory: @escaping (DIResolver) -> Pool,
                          completed: ((DIResolver, Pool) -> Void)?) where Pool: BusinessLogicServicePool
    
    /// Регистрация singleton в контейнер зависимости
    /// - Parameters:
    ///   - singletonType: Тип singleton
    ///   - factory: Блок содержащий код реализующий логику инициализация объекта
    ///   - completed: Замыкание завершения инициализации
    func recordSingleton<Singleton>(_: Singleton.Type,
                                    factory: @escaping (DIResolver) -> Singleton,
                                    completed: ((DIResolver, Singleton) -> Void)?) where Singleton: BusinessLogicSingleton
    
    /// Регистрация менеджера в контейнер зависимости
    /// - Parameters:
    ///   - _: Тип менеджера
    ///   - factory: Блок содержащий код реализующий логику инициализация объекта
    ///   - completed: Замыкание завершения инициализации
    func recordManager<Manager>(_: Manager.Type,
                                factory: @escaping (DIResolver) -> Manager,
                                completed: ((DIResolver, Manager) -> Void)?) where Manager: PresentationLogicManager
}

// MARK: - BusinessLogicRegistrar + Default
public extension BusinessLogicRegistrar {
    
    /// Регистрация агента в контейнер зависимости
    /// - Parameters:
    ///   - agentType: Тип агента
    ///   - factory: Блок содержащий код реализующий логику инициализация объекта
    func recordAgent<Agent>(_: Agent.Type,
                            factory: @escaping (DIResolver) -> Agent) where Agent: BusinessLogicAgent {
        recordAgent(Agent.self, factory: factory, completed: nil)
    }
    
    /// Регистрация сервиса в контейнер зависимости
    /// - Parameters:
    ///   - serviceType: Тип сервиса
    ///   - factory: Блок содержащий код реализующий логику инициализация объекта
    func recordService<Service>(_: Service.Type,
                                factory: @escaping (DIResolver) -> Service) where Service: BusinessLogicService {
        recordService(Service.self, factory: factory, completed: nil)
    }
    
    /// Регистрация контролера в контейнер зависимости
    /// - Parameters:
    ///   - controller: Тип контролера
    ///   - factory: Блок содержащий код реализующий логику инициализация объекта
    func recordController(_ controller: (some BusinessLogicController).Type, factory: @escaping (DIResolver) -> some BusinessLogicController) {
        recordController(controller, isSingleton: false, factory: factory)
    }
    
    /// Регистрация двигателя в контейнер зависимости
    /// - Parameters:
    ///   - engineType: Тип двигателя
    ///   - configuration: Конфигурация двигателя
    ///   - factory: Блок содержащий код реализующий логику инициализация объекта
    func recordEngine<Engine>(_: Engine.Type,
                              configuration: EngineConfiguration,
                              factory: @escaping (DIResolver) -> Engine) where Engine: BusinessLogicEngine {
        recordEngine(Engine.self, configuration: configuration, factory: factory, completed: nil)
    }
    
    /// Регистрация множество сервисов в контейнер зависимости
    /// - Parameters:
    ///   - poolType: Тип множества
    ///   - factory: Блок содержащий код реализующий логику инициализация объекта
    func recordPool<Pool>(_: Pool.Type,
                          factory: @escaping (DIResolver) -> Pool) where Pool: BusinessLogicServicePool {
        recordPool(Pool.self, factory: factory, completed: nil)
    }
    
    /// Регистрация singleton в контейнер зависимости
    /// - Parameters:
    ///   - singletonType: Тип singleton
    ///   - factory: Блок содержащий код реализующий логику инициализация объекта
    func recordSingleton<Singleton>(_: Singleton.Type,
                                    factory: @escaping (DIResolver) -> Singleton) where Singleton: BusinessLogicSingleton {
        recordSingleton(Singleton.self, factory: factory, completed: nil)
    }
    
    /// Регистрация менеджера в контейнер зависимости
    /// - Parameters:
    ///   - _: Тип менеджера
    ///   - factory: Блок содержащий код реализующий логику инициализация объекта
    ///   - completed: Замыкание завершения инициализации
    func recordManager<Manager>(_: Manager.Type,
                                factory: @escaping (DIResolver) -> Manager) where Manager: PresentationLogicManager {
        recordManager(Manager.self, factory: factory, completed: nil)
    }
}

/// Протокол внедрения объектов компонентов модуля в контейнер зависимости
public protocol ModuleComponentRegistrar: Sendable {
    
    /// Регистрация компонента модуля в контейнер зависимости
    /// - Parameters:
    ///   - serviceType: Тип компонента
    ///   - factory: Блок содержащий код реализующий логику инициализация объекта
    func recordComponent<Component>(_: Component.Type, factory: @escaping (DIResolver) -> Component) where Component: CArchModuleComponent
    
    /// Регистрация компонента модуля в контейнер зависимости
    /// - Parameters:
    ///   - serviceType: Тип компонента
    ///   - factory: Блок содержащий код реализующий логику инициализация объекта
    func recordComponent<Component, Argument>(_: Component.Type,
                                              factory: @escaping (DIResolver, Argument) -> Component) where Component: CArchModuleComponent
    
    /// Регистрация компонента модуля в контейнер зависимости
    /// - Parameters:
    ///   - serviceType: Тип компонента
    ///   - factory: Блок содержащий код реализующий логику инициализация объекта
    func recordComponent<Component, Argument1, Argument2>(_: Component.Type,
                                                          factory: @escaping (DIResolver, Argument1, Argument2) -> Component) where Component: CArchModuleComponent
    
    /// Регистрация компонента модуля в контейнер зависимости
    /// - Parameters:
    ///   - serviceType: Тип компонента
    ///   - factory: Блок содержащий код реализующий логику инициализация объекта
    func recordComponent<Component, Argument1, Argument2, Argument3>(_: Component.Type,
                                                                     factory: @escaping (DIResolver, Argument1, Argument2, Argument3) -> Component) where Component: CArchModuleComponent
}

/// Протокол регистрации объекта в контейнер зависимости
public protocol DIRegistrar: BusinessLogicRegistrar, ModuleComponentRegistrar {
    
    /// Регистрация объекта в контейнер зависимости
    /// - Parameters:
    ///   - serviceType: Тип объекта
    ///   - storage: Тип ссылки
    ///   - configuration: Конфигурация инъекции
    ///   - shouldCheckRegistration: Надо ли проверить объект на регистрацию в контейнер зависимости
    ///                              если передать true то если до этот было зарегистрирован с таким же
    ///                              типом и конфигурацией то операция регистрации отменяется
    ///   - factory: Блок содержащий код реализующий логику инициализация объекта
    ///   - completed: Замыкание завершения инициализации
    func record<Service>(some _: Service.Type,
                         inScope storage: StorageType,
                         configuration: (any InjectConfiguration)?,
                         shouldCheckRegistration: Bool,
                         factory: @escaping (DIResolver) -> Service,
                         completed: ((DIResolver, Service) -> Void)?)
}

// MARK: - DIRegistrar + Default
public extension DIRegistrar {

    /// Регистрация объекта в контейнер зависимости
    /// - Parameters:
    ///   - serviceType: Тип объекта
    ///   - storage: Тип ссылки
    ///   - configuration: Конфигурация инъекции
    ///   - shouldCheckRegistration: Надо ли проверить объект на регистрацию в контейнер зависимости
    ///                              если передать true то если до этот было зарегистрирован с таким же
    ///                              типом и конфигурацией то операция регистрации отменяется
    ///   - factory: Блок содержащий код реализующий логику инициализация объекта
    func record<Service>(some _: Service.Type,
                         inScope storage: StorageType = .autoRelease,
                         configuration: (any InjectConfiguration)? = nil,
                         shouldCheckRegistration: Bool = true,
                         factory: @escaping (DIResolver) -> Service) {
        record(some: Service.self, inScope: storage, configuration: configuration, shouldCheckRegistration: shouldCheckRegistration, factory: factory, completed: nil)
    }
}
