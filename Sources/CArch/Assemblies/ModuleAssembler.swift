//
//  ModuleAssembler.swift
//

import Foundation

/// Протокол отвечающий за регистрацию компонентов архитектуры CArch в контейнер зависимости
public protocol ModuleAssembler: AnyObject, Sendable {

    /// регистрирует компонент `ModuleAssembly` в контейнер зависимости
    /// - Parameter assembly: компонент, который надо зарегистрировать
    /// - Returns: ссылку на контейнер зависимостей
    static func assembly<Module>(_ type: Module.Type) -> StorageType.WeakReference<Module> where Module: ModuleAssembly
}

/// Протокол отвечающий за регистрацию компонентов модуля архитектуры CArch в контейнер зависимости
public protocol ModuleAssembly: Sendable {

    /// Инициализации без параметров
    init()
    
    /// Зарегистрировать рендера
    /// - Parameter container: Контейнер внедрения зависимостей
    func registerRenderers(in container: DIContainer)
    
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
