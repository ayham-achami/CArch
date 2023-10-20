//
//  Rendering.swift
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
#if canImport(UIKit)
import UIKit

/// Основной протокол содержащий логику показа данных на вью (экране)
/// все протоколы `RenderingLogic` должны быть унаследованными от `RootRenderingLogic`
@MainActor public protocol RootRenderingLogic: CArchModuleComponent, AlertAbility {}

/// Рендер с делегаций
@MainActor public protocol UIRenderer: CArchModuleComponent, ModuleLifeCycle {
    
    /// Тип моделей, которые будут показаны в области действия рендера
    associatedtype ModelType: UIModel

    /// Обновить/Изменить контент рендера
    /// - Parameter content: Новый контент
    func set(content: ModelType)
}

/// Любое действие пользователя
@MainActor public protocol AnyUserInteraction: AnyObject {}

/// Превью модуля
public protocol UIRendererPreview {
    
    /// Возвращает модуль для превью
    /// - Returns: Модуль
    static func preview() -> Self
}

/// Протокол манипуляции жизненный цикл модуля
@MainActor public protocol ModuleLifeCycle: CArchModuleComponent {

    /// Вызывается когда модуль будет загружен
    /// эквивалентно `viewDidLoad` у `UIViewController`
    func moduleDidLoad()
    
    /// Вызывается когда меняется разметка subViews
    /// эквивалентно `viewDidLayoutSubviews` у `UIViewController`
    func moduleLayoutSubviews()
    
    /// Вызывается когда модуль становится активным
    /// эквивалентно `viewDidAppear` у `UIViewController`
    func moduleDidBecomeActive()

    /// Вызывается когда модуль становится неактивным
    /// эквивалентно `viewDidDisappear` у `UIViewController`
    func moduleDidResignActive()
    
    /// Уведомляет о том, что размер основного View и его вида собирается измениться.
    /// эквивалентно `viewWillTransition` у `UIViewController`
    /// - Parameters:
    ///   - size: Новый размер
    ///   - coordinator: Объект координатора перехода, управляющий изменением размера
    func moduleWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator)
}

// MARK: - ModuleLifeCycle + Default
public extension ModuleLifeCycle {
    
    func moduleDidLoad() {}
    func moduleLayoutSubviews() {}
    func moduleDidBecomeActive() {}
    func moduleDidResignActive() {}
    func moduleWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {}
}

/// Протокол контроля жизненный цикл модуля
@MainActor public protocol ModuleLifeCycleOwner: CArchModuleComponent, ModuleLifeCycle {

    /// массив подписчиков на изменение жизненного цикла модуля
    var lifeCycle: [ModuleLifeCycle] { get }
}

// MARK: - ModuleLifeCycleOwner + Default
public extension ModuleLifeCycleOwner {
    
    @MainActor func moduleDidLoad() {
        lifeCycle.forEach { $0.moduleDidLoad() }
    }
    
    @MainActor func moduleLayoutSubviews() {
        lifeCycle.forEach { $0.moduleLayoutSubviews() }
    }
    
    @MainActor func moduleDidBecomeActive() {
        lifeCycle.forEach { $0.moduleDidBecomeActive() }
    }
    
    @MainActor func moduleDidResignActive() {
        lifeCycle.forEach { $0.moduleDidResignActive() }
    }
    
    @MainActor func moduleWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        lifeCycle.forEach { $0.moduleWillTransition(to: size, with: coordinator) }
    }
}

// MARK: - UIRenderer + UIViewController
public extension UIRenderer where Self: UIViewController {
    
    /// Показать рендер на UIViewController
    /// - Parameters:
    ///   - parent: `UIViewController`
    ///   - container: `UIView`
    func embed(into parent: UIViewController, container: UIView? = nil) {
        parent.addChild(self)
        view.frame = parent.view.frame
        (container ?? parent.view).addSubview(view)
        didMove(toParent: parent)
    }
}
#endif
