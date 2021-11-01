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

import UIKit

/// Oсновной протокол новой архитектурой, все протоколы
/// компонентов архитектурой должны быть наследовными
/// от этого протокола, основная задача протокола `CArchProtocol`
/// создать метку в коде для того, чтобы различить
/// протоколы архитектурные от других
public protocol CArchProtocol: AnyObject {}

/// CArch Модуль
public protocol CArchModule: CArchProtocol {

    /// View component
    var view: UIViewController { get }

    /// Инициализатор модуля
    var initializer: AnyModuleInitializer? { get }

    /// Дилегать модуля, объекта ожидаемый результат от текущего модуля
    var finalizer: AnyModuleFinalizer? { get }
}

// MARK: - CArchModule + UIViewController
public extension CArchModule where Self: UIViewController {

    var view: UIViewController {
        return self
    }

    var initializer: AnyModuleInitializer? {
        return self as? AnyModuleInitializer
    }

    var finalizer: AnyModuleFinalizer? {
        return self as? AnyModuleFinalizer
    }
}

/// Oсновой протокол любого объекта UI модели
public protocol UIModel {}

/// Oбъект реализующий переиспользуемую логику BusinessLogic слоя
public protocol Worker: CustomStringConvertible, CustomDebugStringConvertible {
    
    /// инициализация с необходимыми зависимостям
    /// если у сервера нет зависимости от других объектов, то передайте пустой список аргументов
    /// если нужный объект зависимости не было найден в списке аргументов, прерывается
    /// процесс инициализации с фатальной ошибки
    ///
    /// - Parameter args: список аргументов (объектов) с которыми есть зависимость у сервера
    init(_ args: BusinessLogicService?...)
}

// MARK: - BusinessLogicService + StringConvertible
public extension Worker {

    var description: String { "🛠 \(String(describing: Self.self))" }

    var debugDescription: String { description }
}

/// Базовый протокол любого сервиса слоя бизнес логики
/// нельзя создавать сервис и не наследовать данный протокол
public protocol BusinessLogicService: CArchProtocol, CustomStringConvertible, CustomDebugStringConvertible {

    /// инициализация с необходимыми зависимостям
    /// если у сервера нет зависимости от других объектов, то передайте пустой список аргументов
    /// если нужный объект зависимости не было найден в списке аргументов, прерывается
    /// процесс инициализации с фатальной ошибки
    ///
    /// - Parameter args: список аргументов (объектов) с которыми есть зависимость у сервера
    init(_ args: Any?...)
}

// MARK: - BusinessLogicService + StringConvertible
public extension BusinessLogicService {

    var description: String { "⚙️ \(String(describing: Self.self))" }

    var debugDescription: String { description }
}
