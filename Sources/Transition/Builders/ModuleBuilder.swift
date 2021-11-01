//
//  ModuleBuilder.swift
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

/// Билдер любого модуля
public protocol AnyModuleBuilder {

    /// Создает и возвращает новый модуль передавая ему данные инициализации
    ///
    /// - Parameter initialState: Данные инициализации
    /// - Returns: СArch Модуль
    func build(with initialState: ModuleInitialState) -> CArchModule
}

/// Билдер конкретного модуля для определенного типа данных инициализации
public protocol ModuleBuilder: AnyModuleBuilder {

    /// Типа данных инициализации
    associatedtype InitialStateType: ModuleInitialState

    /// Создает и возвращает новый модуль передавая ему данные инициализации
    ///
    /// - Parameter initialState: Данные инициализации
    /// - Returns: CArch Модуль
    func build(with initialState: InitialStateType) -> CArchModule

    /// Создает и возвращает новый модуль
    ///
    /// - Returns: CArch Модуль
    func build() -> CArchModule
}

// MARK: - ModuleBuilder + Реализация по умолчанию
public extension ModuleBuilder {

    func build(with initialState: ModuleInitialState) -> CArchModule {
        guard let initialState = initialState as? InitialStateType else {
            preconditionFailure("Could't cast to \(String(describing: InitialStateType.self))")
        }
        return build(with: initialState)
    }
}
