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
    
    /// - singleton: Cинглтон, объект всегда есть, и будет всегда при цикле resolve
    ///              возвращен один и тоже объект
    @available(*, deprecated, message: "This feature has be deprecated and will be removed in future release")
    case singleton
    /// - autoRelease: Автоматическое уничтожение, пока на объекта есть сильная
    ///                ссылка всегда он есть при цикле revolve, уничтожается когда
    ///                нет не каких сильных ссылка на объект и тогда при следующем цикле
    ///                возвращается новый экземпляр объекта
    @available(*, deprecated, message: "This feature has be deprecated and will be removed in future release")
    case autoRelease
    /// - alwaysNewInstance: Всегда будет новый экземпляр объекта при цикле revolve
    @available(*, deprecated, message: "This feature has be deprecated and will be removed in future release")
    case alwaysNewInstance
    
    /// - businessLogic: Скоп business logic объект будет жить пока на него есть сильная ссылка
    ///                  и он общий на уровне контейнера зависимости и его Parents и Childs
    ///                  всегда будет один и тоже экземпляр объекта при цикле revolve
    case businessLogic
    /// - moduleComponent: Скоп двигателей объект будет жить пока на него есть сильная ссылка
    ///                    и он НЕ общий на уровне контейнера зависимости и его Parents и Childs
    ///                    всегда будет новый экземпляр объекта при цикле revolve
    case moduleComponent
    
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
    ///   - _: Тип агента
    ///   - factory: Блок содержащий код реализующий логику инициализация объекта
    func recordAgent<Agent>(_: Agent.Type, factory: @escaping (DIResolver) -> Agent) where Agent: BusinessLogicAgent
    
    /// Регистрация сервиса в контейнер зависимости
    /// - Parameters:
    ///   - _: Тип сервиса
    ///   - factory: Блок содержащий код реализующий логику инициализация объекта
    func recordService<Service>(_: Service.Type, factory: @escaping (DIResolver) -> Service) where Service: BusinessLogicService
    
    /// Регистрация сервиса в контейнер зависимости
    /// - Parameters:
    ///   - _: Тип сервиса
    ///   - configuration: Конфигурация двигателя
    ///   - factory: Блок содержащий код реализующий логику инициализация объекта
    func recordEngine<Engine>(_: Engine.Type, configuration: EngineConfiguration, factory: @escaping (DIResolver) -> Engine) where Engine: BusinessLogicEngine
}

/// Протокол внедрения объектов компонентов модуля в контейнер зависимости
public protocol ModuleComponentRegistrar {
    
    /// Регистрация компонента модуля в контейнер зависимости
    /// - Parameters:
    ///   - _: Тип компонента
    ///   - factory: Блок содержащий код реализующий логику инициализация объекта
    func recordComponent<Component>(_: Component.Type, factory: @escaping (DIResolver) -> Component) where Component: CArchModuleComponent
    
    /// Регистрация компонента модуля в контейнер зависимости
    /// - Parameters:
    ///   - _: Тип компонента
    ///   - factory: Блок содержащий код реализующий логику инициализация объекта
    func recordComponent<Component, each Argument>(_: Component.Type, factory: @escaping (DIResolver, repeat each Argument) -> Component) where Component: CArchModuleComponent
}

/// Протокол регистрации объекта в контейнер зависимости
public protocol DIRegistrar: BusinessLogicRegistrar, ModuleComponentRegistrar {
    
    /// Регистрация объекта в контейнер зависимости
    /// - Parameters:
    ///   - _: Тип объекта
    ///   - storage: Тип ссылки
    ///   - configuration: Конфигурация инъекции
    ///   - factory: Блок содержащий код реализующий логику инициализация объекта
    func record<Service>(_: Service.Type,
                         inScope storage: StorageType,
                         configuration: (any InjectConfiguration)?,
                         factory: @escaping (DIResolver) -> Service)
    
    /// Регистрация объекта в контейнер зависимости
    /// - Parameters:
    ///   - _: Тип объекта
    ///   - storage: Тип ссылки
    ///   - configuration: Конфигурация инъекции
    ///   - factory: Блок содержащий код реализующий логику инициализация объекта
    func record<Service, each Argument>(_: Service.Type,
                                        inScope storage: StorageType,
                                        configuration: (any InjectConfiguration)?,
                                        factory: @escaping (DIResolver, repeat each Argument) -> Service)
    
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
    func record<Service, each Argument>(_ serviceType: Service.Type,
                                        inScope storage: StorageType,
                                        factory: @escaping (DIResolver, repeat each Argument) -> Service)
    
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
    
    func recordAgent<Agent>(_: Agent.Type, factory: @escaping (DIResolver) -> Agent) where Agent: BusinessLogicAgent {
        record(Agent.self, inScope: .businessLogic, configuration: nil, factory: factory)
    }
    
    func recordService<Service>(_: Service.Type, factory: @escaping (DIResolver) -> Service) where Service: BusinessLogicService {
        record(Service.self, inScope: .businessLogic, configuration: nil, factory: factory)
    }
    
    func recordEngine<Engine>(_: Engine.Type, configuration: EngineConfiguration, factory: @escaping (DIResolver) -> Engine) where Engine: BusinessLogicEngine {
        record(Engine.self, inScope: .businessLogic, configuration: configuration, factory: factory)
    }
    
    func recordComponent<Component>(_: Component.Type, factory: @escaping (DIResolver) -> Component) where Component: CArchModuleComponent {
        record(Component.self, inScope: .moduleComponent, configuration: nil, factory: factory)
    }
    
    func recordComponent<Component, each Argument>(_: Component.Type, factory: @escaping (DIResolver, repeat each Argument) -> Component) where Component: CArchModuleComponent {
        record(Component.self, inScope: .moduleComponent, configuration: nil, factory: factory)
    }
    
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
    
    /// Получение объекта из контейнера зависимости
    /// - Parameter serviceType: Тип объекта
    /// - Returns: Объекта из контейнера зависимости
    func unravel<Service>(_ serviceType: Service.Type) -> Service?
    
    /// Получение объекта из контейнера зависимости
    /// - Parameters:
    ///   - serviceType: Тип объекта
    ///   - arguments: Аргумент чтобы передавать в замыкание фабрики
    /// - Returns: Объекта из контейнера зависимости
    func unravel<Service, each Argument>(_ serviceType: Service.Type, arguments: repeat each Argument) -> Service?
    
    /// Получение объекта из контейнера зависимости
    /// - Parameters:
    ///   - serviceType: Тип объекта
    ///   - configuration: Конфигурация инъекции
    /// - Returns: Объекта из контейнера зависимости
    func unravel<Service>(_ serviceType: Service.Type, configuration: any InjectConfiguration) -> Service?
    
    /// Получение объекта из контейнера зависимости
    /// - Parameters:
    ///   - serviceType: Тип объекта
    ///   - configuration: Конфигурация инъекции
    ///   - arguments: Аргумент чтобы передавать в замыкание фабрики
    /// - Returns: Объекта из контейнера зависимости
    func unravel<Service, each Argument>(_ serviceType: Service.Type, configuration: any InjectConfiguration, arguments: repeat each Argument) -> Service?
    
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