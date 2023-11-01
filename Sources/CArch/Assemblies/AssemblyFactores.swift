//
//  AssemblyFactory.swift
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

/// Протокол регулировки уровня логирования
public protocol DIAssemblyFactoryDebugger {
    
    /// Регулировки уровня логирования
    /// - Parameter isDebugEnabled: Вкл/Выкл
    static func set(isDebugEnabled: Bool)
}

/// Протокол получения доступа к контейнеру зависимости
public protocol AnyDIAssemblyFactory: DIAssemblyFactoryDebugger {
    
    /// Объект отвечающий за регистрацию сервиса в контейнер зависимости
    var registrar: DIRegistrar { get }

    /// Объект отвечающий за получение сервиса из контейнера зависимости
    var resolver: DIResolver { get }
    
    /// Инициализации без параметров
    init()

    /// Выполнять регистрации всех сервисов бизнес логики в контейнер зависимости
    /// - Parameter recorder: Класс отвечающий за создание всех серверов
    @available(*, deprecated, message: "This feature has be deprecated and will be removed in future release")
    func record<Recorder>(_ recorder: Recorder.Type) where Recorder: ServicesRecorder
    
    /// Выполнять регистрации всех сервисов бизнес логики в контейнер зависимости
    /// - Parameter recorder: Класс отвечающий за создание всех серверов
    func record<Recorder>(_ recorder: Recorder) where Recorder: DIAssemblyCollection
}

#if canImport(UIKit)
/// Протокол получения доступа к контейнеру зависимости с Storyboard
@available(*, deprecated, message: "This feature has be deprecated and will be removed in future release")
public protocol StoryboardDIAssemblyFactory: AnyDIAssemblyFactory {
    
    /// Контейнер зависимости
    var storyboardContainer: DIStoryboardContainer { get }
    
    /// Внедрение зависимости для Storyboard
    var storyboard: DIStoryboard { get }
    
    /// Регистрирует компонент модуля в контейнер зависимости
    /// - Parameter module: Модуль
    /// - Returns: Модуль после регистрации
    func assembly<Module>(_ module: Module) -> Module where Module: StoryboardModuleAssembly
}
#endif

/// Протокол получения доступа к контейнеру зависимости
public protocol LayoutDIAssemblyFactory: AnyDIAssemblyFactory {

    /// Контейнер зависимости
    var layoutContainer: DIContainer { get }
    
    /// Регистрирует компонент модуля в контейнер зависимости
    /// - Parameter module: Модуль
    /// - Returns: Модуль после регистрации
    func assembly<Module>(_ module: Module) -> Module where Module: LayoutModuleAssembly
}
