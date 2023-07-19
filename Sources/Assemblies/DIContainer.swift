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
    case singleton
    /// - autoRelease: Автоматическое уничтожение, пока на объекта есть сильная
    ///                ссылка всегда он есть при цикле revolve, уничтожается когда
    ///                нет не каких сильных ссылка на объект и тогда при следующем цикле
    ///                возвращается новый экземпляр объекта
    case autoRelease
    /// - alwaysNewInstance: Всегда будет новый экземпляр объекта при цикле revolve
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

/// Протокол регистрации объекта в контейнер зависимости
public protocol DIRegistrar {
    
    /// Регистрация объекта в контейнер зависимости
    /// - Parameters:
    ///   - serviceType: Тип объекта
    ///   - storage: Тип ссылки
    ///   - factory: Блок содержащий код реализующий логику внедрения объекта
    func record<Service>(_ serviceType: Service.Type,
                         inScope storage: StorageType,
                         factory: @escaping (DIResolver) -> Service)
    
    /// Регистрация объекта в контейнер зависимости по названию (Таг)
    /// - Parameters:
    ///   - serviceType: Тип объекта
    ///   - name: Название (Таг)
    ///   - storage: Тип ссылки
    ///   - factory: Блок содержащий код реализующий логику внедрения объекта
    func record<Service>(_ serviceType: Service.Type,
                         name: String,
                         inScope storage: StorageType,
                         factory: @escaping (DIResolver) -> Service)
    
    /// Регистрация объекта в контейнер зависимости
    /// - Parameters:
    ///   - serviceType: Тип объекта
    ///   - storage: Тип ссылки
    ///   - factory: Блок содержащий код реализующий логику внедрения объекта
    func record<Service, Arg>(_ serviceType: Service.Type,
                              inScope storage: StorageType,
                              factory: @escaping (DIResolver, Arg) -> Service)
    
    /// Регистрация объекта в контейнер зависимости
    /// - Parameters:
    ///   - serviceType: Тип объекта
    ///   - storage: Тип ссылки
    ///   - factory: Блок содержащий код реализующий логику внедрения объекта
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
    func record<Service>(_ serviceType: Service.Type,
                         factory: @escaping (DIResolver) -> Service) {
        record(serviceType, inScope: .autoRelease, factory: factory)
    }
    
    /// Регистрация объекта в контейнер зависимости по названию (Таг)
    /// - Parameters:
    ///   - serviceType: Тип объекта
    ///   - name: Название (Таг)
    ///   - factory: Блок содержащий код реализующий логику внедрения объекта
    func record<Service>(_ serviceType: Service.Type,
                         name: String,
                         factory: @escaping (DIResolver) -> Service) {
        record(serviceType, name: name, inScope: .autoRelease, factory: factory)
    }
    
    /// Регистрация объекта в контейнер зависимости
    /// - Parameters:
    ///   - serviceType: Тип объекта
    ///   - factory: Блок содержащий код реализующий логику внедрения объекта
    func record<Service, Arg>(_ serviceType: Service.Type,
                              factory: @escaping (DIResolver, Arg) -> Service) {
        record(serviceType, inScope: .autoRelease, factory: factory)
    }
    
    /// Регистрация объекта в контейнер зависимости
    /// - Parameters:
    ///   - serviceType: Тип объекта
    ///   - factory: Блок содержащий код реализующий логику внедрения объекта
    func record<Service, Arg1, Arg2>(_ serviceType: Service.Type,
                                     factory: @escaping (DIResolver, Arg1, Arg2) -> Service) {
        record(serviceType, inScope: .autoRelease, factory: factory)
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
    ///   - name: Название объекта (таг) добровольное значение при поиске объекта в контейнере
    /// - Returns: Объекта из контейнера зависимости
    func unravel<Service>(_ serviceType: Service.Type, name: String?) -> Service?
    
    /// Получение объекта из контейнера зависимости
    /// - Parameters:
    ///   - serviceType: Тип объекта
    ///   - argument: Аргумент чтобы передавать в замыкание фабрики
    /// - Returns: Объекта из контейнера зависимости
    func unravel<Service, Arg>(_ serviceType: Service.Type, argument: Arg) -> Service?
    
    /// Получение объекта из контейнера зависимости
    /// - Parameters:
    ///   - serviceType: Тип объекта
    ///   - arguments: Аргумент1 чтобы передавать в замыкание фабрики
    ///   - arg2: Аргумент2 чтобы передавать в замыкание фабрики
    /// - Returns: Объекта из контейнера зависимости
    func unravel<Service, Arg1, Arg2>(_ serviceType: Service.Type, arguments: Arg1, _ arg2: Arg2) -> Service?
    
    /// Получение объекта из контейнера зависимости
    /// - Parameters:
    ///   - serviceType: Тип объекта
    ///   - arguments: Аргумент1 чтобы передавать в замыкание фабрики
    ///   - arg2: Аргумент2 чтобы передавать в замыкание фабрики
    ///   - arg3: Аргумент3 чтобы передавать в замыкание фабрики
    /// - Returns: Объекта из контейнера зависимости
    func unravel<Service, Arg1, Arg2, Arg3>(_ serviceType: Service.Type, arguments: Arg1, _ arg2: Arg2, arg3: Arg3) -> Service?
}
