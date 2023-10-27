//
//  DIContainer.swift
//
//  The MIT License (MIT)
//
//  Copyright (c) 2019 Community Arch
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

import Foundation

/// Типы ссылок на объекты в контейнер зависимостей
public enum StorageType {
    
    /// - fleeting: Всегда будет новый экземпляр объекта при цикле revolve
    case fleeting
    /// - singleton: Cинглтон, объект всегда есть, и будет всегда при цикле resolve
    ///              возвращен один и тоже объект
    case singleton
    /// - autoRelease: Автоматическое уничтожение, пока на объекта есть сильная
    ///                ссылка всегда он есть при цикле revolve, уничтожается когда
    ///                нет не каких сильных ссылка на объект и тогда при следующем цикле
    ///                возвращается новый экземпляр объекта
    case autoRelease
    /// - alwaysNewInstance: Всегда будет новый экземпляр объекта при цикле revolve
    @available(*, deprecated, message: "This feature has be deprecated and will be removed in future release")
    case alwaysNewInstance
    
    /// Слабая ссылка на объект
    public class WeakReference<Wrapped: AnyObject> {
        
        /// Объект назначения
        public private(set) weak var wrapped: Wrapped?
        
        /// Инициализация с объектом
        /// - Parameter wrapped:  Объект, на которого ссылка будет создано
        public init(_ wrapped: Wrapped) {
            self.wrapped = wrapped
        }
    }
    
    /// Сильная ссылка на объект
    public class StrongReference<Wrapped: AnyObject> {
        
        /// Объект назначения
        public private(set) var wrapped: Wrapped?
        
        /// Инициализация с объектом
        /// - Parameter wrapped: Объект, на которого ссылка будет создано
        public init(_ wrapped: Wrapped) {
            self.wrapped = wrapped
        }
    }
}

/// Протокол внедрения объектов бизнес логики в контейнер зависимости
public protocol BusinessLogicRegistrar {
    
    /// Регистрация агента в контейнер зависимости
    /// - Parameters:
    ///   - agentType: Тип агента
    ///   - factory: Блок содержащий код реализующий логику инициализация объекта
    func recordAgent<Agent>(_: Agent.Type, factory: @escaping (DIResolver) -> Agent) where Agent: BusinessLogicAgent
    
    /// Регистрация сервиса в контейнер зависимости
    /// - Parameters:
    ///   - serviceType: Тип сервиса
    ///   - factory: Блок содержащий код реализующий логику инициализация объекта
    func recordService<Service>(_: Service.Type, factory: @escaping (DIResolver) -> Service) where Service: BusinessLogicService

    /// Регистрация двигателя в контейнер зависимости
    /// - Parameters:
    ///   - engineType: Тип двигателя
    ///   - factory: Блок содержащий код реализующий логику инициализация объекта
    func recordEngine<Engine>(_: Engine.Type, factory: @escaping (DIResolver) -> Engine) where Engine: BusinessLogicEngine
    
    /// Регистрация двигателя в контейнер зависимости
    /// - Parameters:
    ///   - engineType: Тип двигателя
    ///   - configuration: Конфигурация двигателя
    ///   - factory: Блок содержащий код реализующий логику инициализация объекта
    func recordEngine<Engine>(_: Engine.Type, configuration: EngineConfiguration, factory: @escaping (DIResolver) -> Engine) where Engine: BusinessLogicEngine
    
    /// Регистрация множество сервисов в контейнер зависимости
    /// - Parameters:
    ///   - poolType: Тип множества
    ///   - factory: Блок содержащий код реализующий логику инициализация объекта
    func recordPool<Pool>(_: Pool.Type, factory: @escaping (DIResolver) -> Pool) where Pool: BusinessLogicServicePool
    
    /// Регистрация singleton в контейнер зависимости
    /// - Parameters:
    ///   - singletonType: Тип singleton
    ///   - factory: Блок содержащий код реализующий логику инициализация объекта
    func recordSingleton<Singleton>(_: Singleton.Type, factory: @escaping (DIResolver) -> Singleton) where Singleton: BusinessLogicSingleton
}

/// Протокол внедрения объектов компонентов модуля в контейнер зависимости
public protocol ModuleComponentRegistrar {
    
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
    ///   - factory: Блок содержащий код реализующий логику инициализация объекта
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

/// Протокол получения объекта из контейнера зависимости
public protocol DIResolver {
    
    /// Получение агента в контейнер зависимости
    /// - Parameters:
    ///   - serviceType: Тип агента
    ///   - factory: Блок содержащий код реализующий логику инициализация объекта
    func unravelAgent<Agent>(_: Agent.Type) -> Agent where Agent: BusinessLogicAgent
    
    /// Получение сервиса в контейнер зависимости
    /// - Parameters:
    ///   - serviceType: Тип сервиса
    ///   - factory: Блок содержащий код реализующий логику инициализация объекта
    func unravelService<Service>(_: Service.Type) -> Service where Service: BusinessLogicService

    /// Получение сервиса в контейнер зависимости
    /// - Parameters:
    ///   - serviceType: Тип сервиса
    ///   - factory: Блок содержащий код реализующий логику инициализация объекта
    func unravelEngine<Engine>(_: Engine.Type) -> Engine where Engine: BusinessLogicEngine
    
    /// Получение сервиса в контейнер зависимости
    /// - Parameters:
    ///   - serviceType: Тип сервиса
    ///   - configuration: Конфигурация двигателя
    ///   - factory: Блок содержащий код реализующий логику инициализация объекта
    func unravelEngine<Engine>(_: Engine.Type, configuration: EngineConfiguration) -> Engine where Engine: BusinessLogicEngine
    
    /// Получение компонента модуля в контейнер зависимости
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
    
    /// Получение компонента модуля в контейнер зависимости
    /// - Parameters:
    ///   - serviceType: Тип объекта
    ///   - argument1: Аргумент1 чтобы передавать в замыкание фабрики
    ///   - argument2: Аргумент2 чтобы передавать в замыкание фабрики
    /// - Returns: Объекта из контейнера зависимости
    func unravelComponent<Component, Argument1, Argument2>(_: Component.Type, 
                                                           argument1: Argument1,
                                                           argument2: Argument2) -> Component where Component: CArchModuleComponent
    
    /// Получение компонента модуля в контейнер зависимости
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
