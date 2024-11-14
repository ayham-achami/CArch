//
//  DIResolver.swift
//

import Foundation

/// Протокол получения объектов бизнес логики в контейнер зависимости
public protocol BusinessLogicResolver: Sendable {
    
    /// Получение агента из контейнера зависимости
    /// - Parameters:
    ///   - serviceType: Тип агента
    /// - Returns: `Agent`
    func unravelAgent<Agent>(_: Agent.Type) -> Agent where Agent: BusinessLogicAgent
    
    /// Получение сервиса из контейнера зависимости
    /// - Parameters:
    ///   - serviceType: Тип сервиса
    /// - Returns: `Service`
    func unravelService<Service>(_: Service.Type) -> Service where Service: BusinessLogicService
    
    /// Получение контроллер из контейнера зависимости
    /// - Parameter _: Тип контроллера
    /// - Returns: `Controller`
    func unravelController<Controller>(_: Controller.Type) -> Controller where Controller: BusinessLogicController
    
    /// Получение сервиса из контейнера зависимости
    /// - Parameters:
    ///   - serviceType: Тип сервиса
    /// - Returns: `Engine`
    func unravelEngine<Engine>(_: Engine.Type) -> Engine where Engine: BusinessLogicEngine
    
    /// Получение сервиса из контейнера зависимости
    /// - Parameters:
    ///   - serviceType: Тип сервиса
    ///   - configuration: Конфигурация двигателя
    /// - Returns: `Engine`
    func unravelEngine<Engine>(_: Engine.Type, configuration: EngineConfiguration) -> Engine where Engine: BusinessLogicEngine
    
    /// Получение пул сервисов из контейнера зависимости
    /// - Parameter poolType: Тип пул сервисов
    /// - Returns: `Pool`
    func unravelPool<Pool>(_: Pool.Type) -> Pool where Pool: BusinessLogicServicePool
    
    /// Получение Singleton из контейнера зависимости
    /// - Parameter singletonType: Тип Singleton
    /// - Returns: `Singleton`
    func unravelSingleton<Singleton>(_: Singleton.Type) -> Singleton where Singleton: BusinessLogicSingleton
}

/// Протокол получения объектов компонентов модуля в контейнер зависимости
public protocol ModuleComponentResolver: Sendable {
    
    /// Получение модуля из контейнера зависимости
    /// - Parameter moduleType: Тип модуля
    /// - Returns: модуля `CArchModule`
    func unravelModule<Module>(_: Module.Type) -> Module where Module: CArchModule
    
    /// Получение компонента модуля из контейнера зависимости
    /// - Parameters:
    ///   - serviceType: Тип объекта
    ///   - argument: Аргумент чтобы передавать в замыкание фабрики
    /// - Returns: Объекта из контейнера зависимости
    func unravelComponent<Component>(_: Component.Type) -> Component where Component: CArchModuleComponent
    
    /// Получение объекта из контейнера зависимости
    /// - Parameters:
    ///   - serviceType: Тип объекта
    ///   - argument: Аргумент чтобы передавать в замыкание фабрики
    /// - Returns: Объекта из контейнера зависимости
    func unravelComponent<Component, Argument>(_: Component.Type,
                                               argument: Argument) -> Component where Component: CArchModuleComponent
    
    /// Получение компонента модуля из контейнера зависимости
    /// - Parameters:
    ///   - serviceType: Тип объекта
    ///   - argument1: Аргумент1 чтобы передавать в замыкание фабрики
    ///   - argument2: Аргумент2 чтобы передавать в замыкание фабрики
    /// - Returns: Объекта из контейнера зависимости
    func unravelComponent<Component, Argument1, Argument2>(_: Component.Type,
                                                           argument1: Argument1,
                                                           argument2: Argument2) -> Component where Component: CArchModuleComponent
    
    /// Получение компонента модуля из контейнера зависимости
    /// - Parameters:
    ///   - serviceType: Тип объекта
    ///   - argument1: Аргумент1 чтобы передавать в замыкание фабрики
    ///   - argument2: Аргумент2 чтобы передавать в замыкание фабрики
    ///   - argument3: Аргумент3 чтобы передавать в замыкание фабрики
    /// - Returns: Объекта из контейнера зависимости
    func unravelComponent<Component, Argument1, Argument2, Argument3>(_: Component.Type,
                                                                      argument1: Argument1,
                                                                      argument2: Argument2,
                                                                      argument3: Argument3) -> Component where Component: CArchModuleComponent
}

/// Протокол получения объекта из контейнера зависимости
public protocol DIResolver: BusinessLogicResolver, ModuleComponentResolver {
    
    /// Получение объекта из контейнера зависимости
    /// - Parameter serviceType: Тип объекта
    /// - Returns: Объекта из контейнера зависимости
    func unravel<Service>(some _: Service.Type) -> Service
    
    /// Получение объекта из контейнера зависимости
    /// - Parameters:
    ///   - serviceType: Тип объекта
    ///   - configuration: Конфигурация инъекции
    /// - Returns: Объекта из контейнера зависимости
    func unravel<Service>(some _: Service.Type, configuration: any InjectConfiguration) -> Service
    
    /// Получение объекта из контейнера зависимости
    /// - Parameter serviceType: Тип объекта
    /// - Returns: Объекта из контейнера зависимости
    @available(*, deprecated, message: "This feature has be deprecated and will be removed in future release")
    func unravel<Service>(_ serviceType: Service.Type) -> Service?
    
    /// Получение объекта из контейнера зависимости
    /// - Parameters:
    ///   - serviceType: Тип объекта
    ///   - name: Название объекта (таг) добровольное значение при поиске объекта в контейнере
    /// - Returns: Объекта из контейнера зависимости
    @available(*, deprecated, message: "This feature has be deprecated and will be removed in future release")
    func unravel<Service>(_ serviceType: Service.Type, name: String?) -> Service?
    
    /// Получение объекта из контейнера зависимости
    /// - Parameters:
    ///   - serviceType: Тип объекта
    ///   - argument: Аргумент чтобы передавать в замыкание фабрики
    /// - Returns: Объекта из контейнера зависимости
    @available(*, deprecated, message: "This feature has be deprecated and will be removed in future release")
    func unravel<Service, Arg>(_ serviceType: Service.Type, argument: Arg) -> Service?
    
    /// Получение объекта из контейнера зависимости
    /// - Parameters:
    ///   - serviceType: Тип объекта
    ///   - arguments: Аргумент1 чтобы передавать в замыкание фабрики
    ///   - arg2: Аргумент2 чтобы передавать в замыкание фабрики
    /// - Returns: Объекта из контейнера зависимости
    @available(*, deprecated, message: "This feature has be deprecated and will be removed in future release")
    func unravel<Service, Arg1, Arg2>(_ serviceType: Service.Type, arguments: Arg1, _ arg2: Arg2) -> Service?
    
    /// Получение объекта из контейнера зависимости
    /// - Parameters:
    ///   - serviceType: Тип объекта
    ///   - arguments: Аргумент1 чтобы передавать в замыкание фабрики
    ///   - arg2: Аргумент2 чтобы передавать в замыкание фабрики
    ///   - arg3: Аргумент3 чтобы передавать в замыкание фабрики
    /// - Returns: Объекта из контейнера зависимости
    @available(*, deprecated, message: "This feature has be deprecated and will be removed in future release")
    func unravel<Service, Arg1, Arg2, Arg3>(_ serviceType: Service.Type, arguments: Arg1, _ arg2: Arg2, arg3: Arg3) -> Service?
}
