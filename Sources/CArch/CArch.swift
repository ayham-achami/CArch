//
//  CArch.h
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

/// Основной протокол новой архитектурой, все протоколы
/// компонентов архитектурой должны быть унаследованным
/// от этого протокола, основная задача протокола `CArchProtocol`
/// создать метку в коде для того, чтобы различить
/// протоколы архитектурные от других
public protocol CArchProtocol: AnyObject {}

/// Основной протокол, все протоколы компонентов модуля
public protocol CArchModuleComponent: CArchProtocol {}

/// Основной протокол любого объекта UI модели
public protocol UIModel {}
#if os(iOS)
import UIKit
public typealias ViewController = UIViewController
#else
public typealias ViewController = Any
#endif

/// CArch Модуль
public protocol CArchModule: CArchProtocol {

    /// View component
    var node: ViewController { get }

    /// Инициализатор модуля
    var initializer: AnyModuleInitializer? { get }

    /// Делегат модуля, объекта ожидаемый результат от текущего модуля
    var finalizer: AnyModuleFinalizer? { get }
}

#if canImport(UIKit)
import UIKit

// MARK: - UIViewController + CArchModule
extension UIViewController: CArchModule {
    
    public var node: ViewController {
        self
    }
    
    public var initializer: AnyModuleInitializer? {
        self as? AnyModuleInitializer
    }
    
    public var finalizer: AnyModuleFinalizer? {
        self as? AnyModuleFinalizer
    }
}
#endif

/// Конфигурация инъекции
public protocol InjectConfiguration: RawRepresentable where RawValue == String {}

/// Конфигурация двигателя
public struct EngineConfiguration: InjectConfiguration {
    
    public var rawValue: String
    
    public init?(rawValue: String) {
        self.rawValue = rawValue
    }
}

/// Базовый протокол любого двигателя слоя бизнес логики
/// нельзя создавать двигатель и не наследовать данный протокол
public protocol BusinessLogicEngine: CArchProtocol, Actor, CustomStringConvertible, CustomDebugStringConvertible {}

// MARK: - BusinessLogicEngine + StringConvertible
public extension BusinessLogicEngine {
    
    nonisolated var description: String {
        "🧰 \(String(describing: Self.self))"
    }
    
    nonisolated var debugDescription: String {
        description
    }
}

/// Базовый протокол любого агента слоя бизнес логики
/// нельзя создавать агент и не наследовать данный протокол
public protocol BusinessLogicAgent: CArchProtocol, Actor, CustomStringConvertible, CustomDebugStringConvertible {}

// MARK: - BusinessLogicAgent + StringConvertible
public extension BusinessLogicAgent {
    
    nonisolated var description: String {
        "🛠️ \(String(describing: Self.self))"
    }
    
    nonisolated var debugDescription: String {
        description
    }
}

/// Базовый протокол любого сервиса слоя бизнес логики
/// нельзя создавать сервис и не наследовать данный протокол
public protocol BusinessLogicService: CArchProtocol, Actor, CustomStringConvertible, CustomDebugStringConvertible {}

// MARK: - BusinessLogicService + StringConvertible
public extension BusinessLogicService {

    nonisolated var description: String {
        "⚙️ \(String(describing: Self.self))"
    }

    nonisolated var debugDescription: String {
        description
    }
}

/// Протокол множества сервисов
public protocol BusinessLogicServicePool: BusinessLogicService {}

// MARK: - BusinessLogicServicePool + StringConvertible
public extension BusinessLogicServicePool {

    nonisolated var description: String {
        "🏭 \(String(describing: Self.self))"
    }

    nonisolated var debugDescription: String {
        description
    }
}

/// Протокол метки объекта типа ``Singleton``
public protocol BusinessLogicSingleton: CArchProtocol, Actor {}

// MARK: - BusinessLogicSingleton + StringConvertible
public extension BusinessLogicSingleton {

    nonisolated var description: String {
        "🎯 \(String(describing: Self.self))"
    }

    nonisolated var debugDescription: String {
        description
    }
}

/// Макрос, который добавить alias не асинхронной функции всех асинхронных функций
///
///     @SyncAlias
///     protocol TestProtocol: TestProtocolInc, ErrorAsyncHandler {
///
///         func syncFunction(_ object: Any)
///     }
///
///     extension TestProtocol {
///
///         func asyncFunction(_ object: Any) {
///             Task { [weak self] in
///                 await self?.asyncFunction(object)
///             }
///         }
///     }
@attached(extension, names: arbitrary)
public macro SyncAlias() = #externalMacro(module: "CArchMacros", type: "SyncAliasMacro")

/// Макрос, который добавить nonisolated alias всех не асинхронных функций
///
///     @UIContactor
///     @MainActor protocol TestUIProtocol: AnyObject {
///
///         func function(_ object: Any)
///     }
///
///     extension TestUIProtocol {
///
///         nonisolated func nonisolatedFunction(_ object: Any) {
///             Task { [weak self] in
///                 await self?.function(object)
///             }
///         }
///     }
@attached(extension, names: arbitrary)
public macro UIContactor() = #externalMacro(module: "CArchMacros", type: "UIContactorMacro")
