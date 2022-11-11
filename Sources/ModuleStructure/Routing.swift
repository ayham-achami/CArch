//
//  Routing.swift
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

#if canImport(UIKit)
import UIKit

/// Ошибка подготовки транзакции между модулями
struct TransitionPrepareError: Error {

    /// Возможные ошибки
    ///
    /// - invalidConfigurator: Инвалидный конфигуратор не удалось преобразовать sendr в TransitionConfigurator
    /// - invalidConvertible: Инвалидный конвертатор не удалось преобразовать destination в AnyModuleInitializer
    enum Case {
        case invalidConfigurator
        case invalidInitializer
    }

    let `case`: Case
}

/// Основной протокол содержащий логику навигации между модулями
/// все протоколы `RoutingLogic` должны быть унаследованными от `RootRoutingLogic`
public protocol RootRoutingLogic: CArchProtocol {

    /// Подготовить транзакцию между модулями
    ///
    /// - Parameters:
    ///   - segue: Объект segue, содержащий информацию о модулях, участвующих в segue
    ///   - sender: Объект создающий транзакцию
    /// - Throws: `TransitionPrepareError`
    func prepare(for segue: UIStoryboardSegue, sender: Any?) throws

    /// Показать диалог ошибки
    /// ```
    /// +----------------------+
    /// |        Error         |
    /// |   Some error has     |
    /// |   happened check     |
    /// |   your settings      |
    /// +----------------------+
    /// |          OK          |
    /// +----------------------+
    /// ```
    /// - Parameter message: Описание ошибки на текущем языка локализации
    func showErrorAlert( _ message: String)
}

// MARK: - RootRoutingLogic + Default
public extension RootRoutingLogic {

    func prepare(for segue: UIStoryboardSegue, sender: Any?) throws {
        guard let sender = sender else { return }
        guard let configurator = sender as? TransitionConfigurator else {
            throw TransitionPrepareError(case: .invalidConfigurator)
        }
        if let initializer = segue.destination as? AnyModuleInitializer {
            configurator.configurator(initializer)
        } else if let navigationController = segue.destination as? UINavigationController,
            let initializer = navigationController.viewControllers.first as? AnyModuleInitializer {
            configurator.configurator(initializer)
        } else {
            throw TransitionPrepareError(case: .invalidInitializer)
        }
    }
}
#endif
