//
//  State.swift
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

/// Преобразование между типами, в случае ошибки сбрасывается фатальная ошибка
/// - Parameter converted: объект для преобразования
/// - Parameter type: тип, в котором необходимо преобразовать
func convert<T>(some: Any, to type: T.Type) -> T where T: Any {
    guard let converted = some as? T else {
        preconditionFailure("Could not convert \(String(describing: some.self)) to \(String(describing: T.self))")
    }
    return converted
}

/// Набор данных с помощью которых модуль будет инициализирован
/// на пример передать id элемента из модуль в детальный модуль
public protocol ModuleInitialState {}

// MARK: - ModuleInitialState + Conversion
public extension ModuleInitialState {

    /// Преобразование статус инициализации в заданный тип
    ///
    /// - Parameter type: Тип для преобразования
    /// - Returns: Преобразованный объект с заданном типе или сбрасывается фатальная ошибка
    func `is`<StateType>(_ type: StateType.Type) -> StateType where StateType: ModuleInitialState {
        return convert(some: self, to: StateType.self)
    }
}

/// Набор данных, которые необходимо передать родительскому модулю
/// например передать изображение после обработки
public protocol ModuleFinalState {}

// MARK: - ModuleFinalState + Conversion
public extension ModuleFinalState {

    /// Преобразование финальный статус в заданный тип
    ///
    /// - Parameter type: Тип для преобразования
    /// - Returns: Преобразованный объект с заданном типе или сбрасывается фатальная ошибка
    func `is`<StateType>(_ type: StateType.Type) -> StateType where StateType: ModuleFinalState {
        convert(some: self, to: StateType.self)
    }
}

/// Протокол любого состояния только для чтения
public protocol AnyReadOnlyState {}

// MARK: - AnyReadOnlyState + Conversion
public extension AnyReadOnlyState {

    /// Преобразование состояние модуля в состояние только для чтения или сбрасывается фатальная ошибка
    /// - Parameter type: Тип для преобразования
    func `is`<StateType>(_ type: StateType.Type) -> StateType where StateType: AnyReadOnlyState {
        convert(some: self, to: StateType.self)
    }
}

/// Текущее состояние модуля 
/// содержит `ModuleInitialState` и `ModuleFinalState`
/// и набор данных необходимых для работы модуля
public protocol ModuleState {

    /// Тип начального состояния модуля
    associatedtype InitialStateType: ModuleInitialState

    /// Тип финального состояния модуля
    associatedtype FinalStateType: ModuleFinalState

    /// Начальное состояние модуля
    var initialState: InitialStateType? { get set }

    /// Финальное состояние модуля
    var finalState: FinalStateType? { get set }

    /// Инициализация без параметров
    init()

    /// Преобразование состояние модуля в состояние только для чтения или сбрасывается фатальная ошибка
    func readOnly<ReadOnlyState>() -> ReadOnlyState where ReadOnlyState: AnyReadOnlyState
}

// MARK: - ModuleState + Default
public extension ModuleState {

    func readOnly<ReadOnlyState>() -> ReadOnlyState where ReadOnlyState: AnyReadOnlyState {
        convert(some: self, to: ReadOnlyState.self)
    }
}

/// Объект передающий доступ к (только для чтения) состоянии модуля
public protocol AnyModuleStateRepresentable: CArchModuleComponent {}

/// Основной протокол инициализации любого модуля
public protocol AnyModuleInitializer: CArchModuleComponent {

    /// Настроить состояние инициализация модуль
    ///
    /// - Parameter initialState: Данные для инициализации
    func set<StateType>(initialState: StateType) where StateType: ModuleInitialState
}

/// Основной протокол финализирование работы любого модуля
public protocol AnyModuleFinalizer: CArchModuleComponent {

    /// Вызывается при завершении работы модуля
    ///
    /// - Parameter finalState: Данные (результаты работы)
    func didFinalization<StateType>(with finalState: StateType) where StateType: ModuleFinalState
}

// MARK: - ModuleState + Optional
public extension ModuleState {

    /// Возвращает не опциональный статус инициализации, если
    /// статус инициализации nil сбрасывается фатальная ошибка
    var initial: InitialStateType {
        initialState.initial
    }

    /// Возвращает не опциональный финальный статус, если
    /// финальный статус nil сбрасывается фатальная ошибка
    var final: FinalStateType {
        finalState.final
    }
}

// MARK: - Optional + ModuleInitialState
public extension Optional where Wrapped: ModuleInitialState {

    /// Возвращает не опциональный статус инициализации, если
    /// статус инициализации nil сбрасывается фатальная ошибка
    var initial: Wrapped {
        switch self {
        case .none:
            preconditionFailure("initialState is nil, You must set an initial before call state.initialState")
        case .some(let state):
            return state
        }
    }
}

// MARK: - Optional + ModuleFinalState
public extension Optional where Wrapped: ModuleFinalState {

    /// Возвращает не опциональный финальный статус ,
    /// если финальный статус nil сбрасывается фатальная ошибка
    var final: Wrapped {
        switch self {
        case .none:
            preconditionFailure("FinalState is nil, You must set an final before call state.finalState")
        case .some(let state):
            return state
        }
    }
}
