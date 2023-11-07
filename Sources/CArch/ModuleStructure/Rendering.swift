//
//  Rendering.swift
//

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
