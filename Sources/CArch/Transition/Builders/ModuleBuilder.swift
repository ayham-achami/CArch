//
//  ModuleBuilder.swift
//

import Foundation

/// Билдер любого модуля
public protocol AnyModuleBuilder: Sendable {
    
    /// Создает и возвращает новый модуль передавая ему данные инициализации
    /// - Parameter initialState: Данные инициализации
    /// - Returns: СArch Модуль
    func build(with initialState: ModuleInitialState) -> CArchModule
}

/// Билдер конкретного модуля для определенного типа данных инициализации
public protocol ModuleBuilder: AnyModuleBuilder {

    /// Типа данных инициализации
    associatedtype InitialStateType: ModuleInitialState

    /// Создает и возвращает новый модуль передавая ему данные инициализации
    /// - Parameter initialState: Данные инициализации
    /// - Returns: CArch Модуль
    func build(with initialState: InitialStateType) -> CArchModule

    /// Создает и возвращает новый модуль
    /// - Returns: CArch Модуль
    func build() -> CArchModule
}

// MARK: - ModuleBuilder + Реализация по умолчанию
public extension ModuleBuilder {

    func build(with initialState: ModuleInitialState) -> CArchModule {
        guard
            let initialState = initialState as? InitialStateType
        else { preconditionFailure("Could't cast to \(String(describing: InitialStateType.self))") }
        return build(with: initialState)
    }
}
