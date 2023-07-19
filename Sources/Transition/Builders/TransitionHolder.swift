//
//  TransitionHolder.swift
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

/// Носитель информации о переходе
public final class TransitionHolder {
    
    /// Данные инициализации модуля
    var state: ModuleInitialState?
    /// Иерархии модуля
    var hierarchy: Hierarchy = .clear
    /// Тип транзакции
    var transition: TransitionBuilder.Transition = .auto
    /// Анимационная ли транзакция
    var animated: Bool = true
    /// Иерархии модуля
    var builder: AnyHierarchyModuleBuilder?
    /// Если анимационно, замыкание, которое будет выполнено после завершения анимации транзакции
    var completion: TransitionCompletion?
    
    /// Создает и возвращает новый экземпляр `TransitionHolder`
    public static var make: Self {
        .init()
    }
    
    /// Добавить данные инициализации модуля к билдеру
    /// - Parameter state: Данные инициализации модуля
    /// - Returns: текущий билдер Транзакции
    public func with(state: ModuleInitialState) -> Self {
        self.state = state
        return self
    }

    /// Добавить иерархии модуля к билдеру
    /// - Parameter hierarchy: Иерархии модуля
    /// - Returns: Текущий билдер транзакции
    public func with(hierarchy: Hierarchy) -> Self {
        self.hierarchy = hierarchy
        return self
    }

    /// Добавить тип транзакции к билдеру
    /// - Parameter transition: Тип транзакции
    /// - Returns: Текущий билдер транзакции
    public func with(transition: TransitionBuilder.Transition) -> Self {
        self.transition = transition
        return self
    }

    /// Добавить анимацию
    /// - Parameter animated: Анимационная ли транзакция
    public func with(animated: Bool) -> Self {
        self.animated = animated
        return self
    }

    /// Добавить билдер иерархии модуля к билдеру
    /// - Parameter builder: Билдер иерархии модуля
    /// - Returns: Текущий билдер транзакции
    public func with(builder: AnyHierarchyModuleBuilder) -> Self {
        self.builder = builder
        return self
    }
    
    /// Добавить замыкание завершения анимации транзакции модуля к билдеру
    /// оно выполняется только если тип `Transition` был `Transition.present`
    /// - Parameter completion: Замыкание завершения анимации транзакции модуля
    /// - Returns: Текущий билдер транзакции
    public func with(completion: @escaping TransitionCompletion) -> Self {
        self.completion = completion
        return self
    }
}
#endif
