//
//  TransitionBuilder.swift
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

/// Билдер транзакции
public class TransitionBuilder {

    /// Типы транзакции
    ///
    /// - auto: Показать модуль если у source есть `UINavigationController` то, выполняется push если нет то, выполняется present
    /// - push: Запушать модуль через `UINavigationController`
    /// - detail: Запушать модуль как DetailViewController
    /// - present: Презентовать модуль
    /// - embed: Добавить childe `UIViewController`
    /// - customPresent:
    public enum Transition {

        case auto
        case push
        case detail
        case present
        case embed(UIView)
        case customPresent(UIModalPresentationStyle, UIModalTransitionStyle)
    }

    /// Фабричный метод создания билдера
    ///
    /// - Parameter transitionController: Контролер перехода между моделями
    /// - Returns: Билдер транзакции
    static public func with(_ transitionController: TransitionController) -> TransitionBuilder {
        return TransitionBuilder.init(transitionController)
    }

    /// Данные инициализации модуля
    private var state: ModuleInitialState?
    /// Иерархии модуля
    private var hierarchy: Hierarchy = .clear
    /// Тип транзакции
    private var transition: Transition = .auto
    /// Анимационная ли транзакция
    private var animated: Bool = true
    /// Иерархии модуля
    private var builder: AnyHierarchyModuleBuilder?
    /// Если анимационно, замыкание, которое будет выполнено после завершения анимации транзакции
    private var completion: TransitionCompletion?

    /// Контролер перехода между моделями
    private unowned var transitionController: TransitionController

    /// Инициализации
    ///
    /// - Parameter transitionController: Контролер перехода между моделями
    private init(_ transitionController: TransitionController) {
        self.transitionController = transitionController
    }

    /// Добавить данные инициализации модуля к билдеру
    ///
    /// - Parameter initialState: Данные инициализации модуля
    /// - Returns: текущий билдер Транзакции
    public func with(state: ModuleInitialState) -> TransitionBuilder {
        self.state = state
        return self
    }

    /// Добавить иерархии модуля к билдеру
    ///
    /// - Parameter hierarchy: Иерархии модуля
    /// - Returns: Текущий билдер транзакции
    public func with(hierarchy: Hierarchy) -> TransitionBuilder {
        self.hierarchy = hierarchy
        return self
    }

    /// Добваить тип транзакции к билдеру
    ///
    /// - Parameter transition: Тип транзакции
    /// - Returns: Текущий билдер транзакции
    public func with(transition: Transition) -> TransitionBuilder {
        self.transition = transition
        return self
    }

    /// Добавить анимацую
    /// - Parameter animated: Анимационная ли транзакция
    public func with(animated: Bool) -> TransitionBuilder {
        self.animated = animated
        return self
    }

    /// Добавить билдер иерархии модуля к билдеру
    ///
    /// - Parameter hierarchyBuilder: Билдер иерархии модуля
    /// - Returns: Текущий билдер транзакции
    public func with(builder: AnyHierarchyModuleBuilder) -> TransitionBuilder {
        self.builder = builder
        return self
    }

    /// Добавить замыкание завершения анимации транзакции модуля к билдеру
    /// оно выполняется только если тип `Transition` был `Transition.present`
    ///
    /// - Parameter completion: Замыкание завершения анимации транзакции модуля
    /// - Returns: Текущий билдер транзакции
    public func with(completion: @escaping TransitionCompletion) -> TransitionBuilder {
        self.completion = completion
        return self
    }

    /// Выполняет транзакцию
    public func commit() {
        guard
            let module = builder?.build(with: state, into: hierarchy)
        else { assertionFailure("The Hierarchy Builder is nil checkout your settings"); return }
        switch transition {
        case .auto:
            transitionController.show(module)
        case .push:
            transitionController.push(module, animated: animated)
        case .detail:
            transitionController.showSplitDetailModule(module)
        case .present:
            transitionController.present(module, animated: animated, completion: completion)
        case .embed(let container):
            transitionController.embed(submodule: module.view, container: container)
        case .customPresent(let presentationStyle, let transitionStyle):
            module.view.modalPresentationStyle = presentationStyle
            module.view.modalTransitionStyle = transitionStyle
            transitionController.present(module, animated: animated, completion: completion)
        }
    }
}
