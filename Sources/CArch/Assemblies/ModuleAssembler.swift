//
//  ModuleAssembler.swift
//

import Foundation

/// Протокол отвечающий за регистрацию компонентов архитектуры CArch в контейнер зависимости
public protocol LayoutModuleAssembler: AnyObject, Sendable {

    /// регистрирует компонент `ModuleAssembly` в контейнер зависимости
    /// - Parameter assembly: компонент, который надо зарегистрировать
    /// - Returns: ссылку на контейнер зависимостей
    static func assembly<Module>(_ type: Module.Type) -> StorageType.WeakReference<Module> where Module: LayoutModuleAssembly
}

/// Протокол отвечающий за регистрацию компонентов модуля в контейнер зависимости
public protocol AnyModuleAssembly: Sendable {
    
    /// Метод инициализации без параметров
    init()
}

/// Контейнер зависимости
public typealias DIContainer = DIRegistrar & DIResolver

/// Протокол отвечающий за регистрацию компонентов модуля архитектуры CArch в контейнер зависимости
public protocol LayoutModuleAssembly: AnyModuleAssembly {
    
    /// Зарегистрировать рендера
    /// - Parameter container: Контейнер внедрения зависимостей
    func registerRenderers(in container: CArch.DIContainer)
    
    /// Зарегистрировать ссылку на вид
    /// - Parameter container: Контейнер внедрения зависимостей
    func registerView(in container: DIContainer)

    /// Зарегистрировать ссылку на presenter
    /// - Parameter container: Контейнер внедрения зависимостей
    func registerPresenter(in container: DIContainer)

    /// Зарегистрировать ссылку на Provider
    /// - Parameter container: Контейнер внедрения зависимостей
    func registerProvider(in container: DIContainer)

    /// Зарегистрировать ссылку на роутер
    /// - Parameter container: Контейнер внедрения зависимостей
    func registerRouter(in container: DIContainer)
}
