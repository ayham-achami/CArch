//
//  ModuleAssembler.swift
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

/// Протокол отвечающий за регистрацию компонентов архитектуры CArch в контейнер зависимости
public protocol StoryboardModuleAssembler: AnyObject {

    /// регистрирует компонент `ModuleAssembly` в контейнер зависимости
    /// - Parameter assembly: компонент, который надо зарегистрировать
    /// - Returns: ссылку на контейнер зависимостей
    static func assembly<Module>(_ type: Module.Type) -> StorageType.WeakReference<Module> where Module: StoryboardModuleAssembly
}

/// Протокол отвечающий за регистрацию компонентов архитектуры CArch в контейнер зависимости
public protocol LayoutModuleAssembler: AnyObject {

    /// регистрирует компонент `ModuleAssembly` в контейнер зависимости
    /// - Parameter assembly: компонент, который надо зарегистрировать
    /// - Returns: ссылку на контейнер зависимостей
    static func assembly<Module>(_ type: Module.Type) -> StorageType.WeakReference<Module> where Module: LayoutModuleAssembly
}

/// Протокол отвечающий за регистрацию компонентов модуля в контейнер зависимости
public protocol AnyModuleAssembly {
    
    /// Метод инициализации без параметров
    init()
}

/// Контейнер зависимости + Storyboard
public typealias DIStoryboardContainer = DIRegistrar & DIResolver & DIStoryboard

/// Протокол отвечающий за регистрацию компонентов модуля архитектуры CArch в контейнер зависимости
public protocol StoryboardModuleAssembly: AnyModuleAssembly {

    /// Зарегистрировать ссылку на вид
    /// - Parameter container: Контейнер внедрения зависимостей
    func registerView(in container: DIStoryboardContainer)

    /// Зарегистрировать ссылку на presenter
    /// - Parameter container: Контейнер внедрения зависимостей
    func registerPresenter(in container: DIStoryboardContainer)

    /// Зарегистрировать ссылку на Provider
    /// - Parameter container: Контейнер внедрения зависимостей
    func registerProvider(in container: DIStoryboardContainer)

    /// Зарегистрировать ссылку на роутер
    /// - Parameter container: Контейнер внедрения зависимостей
    func registerRouter(in container: DIStoryboardContainer)
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
