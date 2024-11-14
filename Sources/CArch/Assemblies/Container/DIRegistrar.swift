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
    
    /// Регистрация объекта в контейнер зависимости
    /// - Parameters:
    ///   - serviceType: Тип объекта
    ///   - storage: Тип ссылки
    ///   - configuration: Конфигурация инъекции
    ///   - factory: Блок содержащий код реализующий логику инициализация объекта
    @available(*, deprecated, renamed: "record(some:inScope:configuration:factory:)")
    func record<Service>(_: Service.Type,
                         inScope storage: StorageType,
                         configuration: (any InjectConfiguration)?,
                         factory: @escaping (DIResolver) -> Service)
        
    /// Регистрация объекта в контейнер зависимости
    /// - Parameters:
    ///   - serviceType: Тип объекта
    ///   - storage: Тип ссылки
    ///   - factory: Блок содержащий код реализующий логику внедрения объекта
    @available(*, deprecated, message: "This feature has be deprecated and will be removed in future release")
    func record<Service>(_ serviceType: Service.Type,
                         inScope storage: StorageType,
                         factory: @escaping (DIResolver) -> Service)
    
    /// Регистрация объекта в контейнер зависимости по названию (Таг)
    /// - Parameters:
    ///   - serviceType: Тип объекта
    ///   - name: Название (Таг)
    ///   - storage: Тип ссылки
    ///   - factory: Блок содержащий код реализующий логику внедрения объекта
    @available(*, deprecated, message: "This feature has be deprecated and will be removed in future release")
    func record<Service>(_ serviceType: Service.Type,
                         name: String,
                         inScope storage: StorageType,
                         factory: @escaping (DIResolver) -> Service)
        
    /// Регистрация объекта в контейнер зависимости
    /// - Parameters:
    ///   - serviceType: Тип объекта
    ///   - storage: Тип ссылки
    ///   - factory: Блок содержащий код реализующий логику внедрения объекта
    @available(*, deprecated, message: "This feature has be deprecated and will be removed in future release")
    func record<Service, Arg>(_ serviceType: Service.Type,
                              inScope storage: StorageType,
                              factory: @escaping (DIResolver, Arg) -> Service)
    
    /// Регистрация объекта в контейнер зависимости
    /// - Parameters:
    ///   - serviceType: Тип объекта
    ///   - storage: Тип ссылки
    ///   - factory: Блок содержащий код реализующий логику внедрения объекта
    @available(*, deprecated, message: "This feature has be deprecated and will be removed in future release")
    func record<Service, Arg1, Arg2>(_ serviceType: Service.Type,
                                     inScope storage: StorageType,
                                     factory: @escaping (DIResolver, Arg1, Arg2) -> Service)
}

// MARK: - DIRegistrar + Default
public extension DIRegistrar {
    
    /// Регистрация объекта в контейнер зависимости
    /// - Parameters:
    ///   - serviceType: Тип объекта
    ///   - factory: Блок содержащий код реализующий логику инициализация объекта
    func record<Service>(some _: Service.Type,
                         factory: @escaping (DIResolver) -> Service) {
        record(some: Service.self, inScope: .autoRelease, configuration: nil, shouldCheckRegistration: true, factory: factory, completed: nil)
    }
    
    /// Регистрация объекта в контейнер зависимости
    /// - Parameters:
    ///   - serviceType: Тип объекта
    ///   - storage: Тип ссылки
    ///   - factory: Блок содержащий код реализующий логику инициализация объекта
    func record<Service>(some _: Service.Type,
                         inScope storage: StorageType,
                         factory: @escaping (DIResolver) -> Service) {
        record(some: Service.self, inScope: storage, configuration: nil, shouldCheckRegistration: true, factory: factory, completed: nil)
    }
    
    /// Регистрация объекта в контейнер зависимости
    /// - Parameters:
    ///   - serviceType: Тип объекта
    ///   - storage: Тип ссылки
    ///   - configuration: Конфигурация инъекции
    ///   - factory: Блок содержащий код реализующий логику инициализация объекта
    func record<Service>(some _: Service.Type,
                         inScope storage: StorageType,
                         configuration: any InjectConfiguration,
                         factory: @escaping (DIResolver) -> Service) {
        record(some: Service.self, inScope: storage, configuration: configuration, shouldCheckRegistration: true, factory: factory, completed: nil)
    }
    
//    func recordController(_ controller: (some BusinessLogicController).Type, isSingleton: Bool, factory: @escaping (any DIResolver) -> some BusinessLogicController) {
//        record(some: controller, inScope: isSingleton ? .singleton : .autoRelease, factory: factory as! (any DIResolver) -> (some BusinessLogicController))
//    }
}

// MARK: - Deprecated
public extension DIRegistrar {
    
    /// Регистрация объекта в контейнер зависимости
    /// - Parameters:
    ///   - serviceType: Тип объекта
    ///   - factory: Блок содержащий код реализующий логику внедрения объекта
    @available(*, deprecated, message: "This feature has be deprecated and will be removed in future release")
    func record<Service>(_ serviceType: Service.Type,
                         inScope storage: StorageType = .autoRelease,
                         factory: @escaping (DIResolver) -> Service) {
        record(serviceType, inScope: storage, factory: factory)
    }
    
    /// Регистрация объекта в контейнер зависимости по названию (Таг)
    /// - Parameters:
    ///   - serviceType: Тип объекта
    ///   - name: Название (Таг)
    ///   - factory: Блок содержащий код реализующий логику внедрения объекта
    @available(*, deprecated, message: "This feature has be deprecated and will be removed in future release")
    func record<Service>(_ serviceType: Service.Type,
                         name: String,
                         inScope storage: StorageType = .autoRelease,
                         factory: @escaping (DIResolver) -> Service) {
        record(serviceType, name: name, inScope: storage, factory: factory)
    }
    
    /// Регистрация объекта в контейнер зависимости
    /// - Parameters:
    ///   - serviceType: Тип объекта
    ///   - factory: Блок содержащий код реализующий логику внедрения объекта
    @available(*, deprecated, message: "This feature has be deprecated and will be removed in future release")
    func record<Service, Arg>(_ serviceType: Service.Type,
                              inScope storage: StorageType = .autoRelease,
                              factory: @escaping (DIResolver, Arg) -> Service) {
        record(serviceType, inScope: storage, factory: factory)
    }
    
    /// Регистрация объекта в контейнер зависимости
    /// - Parameters:
    ///   - serviceType: Тип объекта
    ///   - factory: Блок содержащий код реализующий логику внедрения объекта
    @available(*, deprecated, message: "This feature has be deprecated and will be removed in future release")
    func record<Service, Arg1, Arg2>(_ serviceType: Service.Type,
                                     inScope storage: StorageType = .autoRelease,
                                     factory: @escaping (DIResolver, Arg1, Arg2) -> Service) {
        record(serviceType, inScope: storage, factory: factory)
    }
}
