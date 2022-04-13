//
//  TransitionController.swift
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

/// Замыкание завершения транзакции
/// - source: Уходящий модуль
/// - destination: появляющийся модуль
public typealias TransitionCompletion = ((CArchModule, CArchModule) -> Void)

public typealias AggregateAbility = AlertAbility & ShareAbility & MailAbility & DocumentInteractionAbility

/// Протокол получение модуля из UIStoryboard
public protocol ModuleStoryboardConvertor: CArchProtocol {

    /// Название UIStoryboard где есть UIViewController модуля
    static var storyboardName: UIStoryboard.Name { get }

    /// Название UIViewController модуля на UIStoryboard
    static var viewControllerName: UIViewController.Name { get }

    /// ViewController модуля, можно использовать для MVC
    ///
    /// - Returns: viewController модуля
    static func viewController() -> UIViewController
}

// MARK: - ModuleStoryboardConvertor + Default
public extension ModuleStoryboardConvertor {

    static func viewController() -> UIViewController {
        let storyboard = UIStoryboard(name: storyboardName)
        return storyboard.instantiateViewController(with: viewControllerName)
    }

    static func viewController<T>(type: T.Type, bundle: Bundle? = nil) -> T? where T: UIViewController {
        let storyboard = UIStoryboard(name: storyboardName, bundle: bundle)
        return storyboard.instantiateViewController(with: viewControllerName) as? T
    }
}

/// Опции сменть RootViweController у KeyWindow
public enum WindowTransitionOptions {

    /// - none: Без анимации
    case none
    /// - presenting(Bool): Выполнить транзакцию через призент и потом замена на root
    case presenting(Bool)
    /// - animation(UIView.AnimationOptions): Выполнить транзакцию с анимации с `UIView.AnimationOptions`
    case animation(UIView.AnimationOptions)
}

/// Изменение (выполнять переход) через окно приложения
public protocol WindowTransition {

    /// Изменить текущий корневой `UIViewController` окна на новый
    /// - Parameter destination: Новый `UIViewController`
    /// - Parameter window: Окно приложения
    /// - Parameter option: Опции анимации
    func transition(to destination: UIViewController, with window: UIWindow, option: WindowTransitionOptions)
}

// MARK: - WindowTransition + Default
fileprivate extension WindowTransition {

    /// Сделать скриншот предыдущего модуля и выполнить транзакцию под ним
    /// - Parameter destination: Новый `UIViewController`
    /// - Parameter window: окно Приложения
    @available(*, deprecated, message: "Use animationTransition(to destination:, with window:, animation:)")
    func snapshotViewTransition(to destination: UIViewController,
                                with window: UIWindow) {
        if let snapshot = window.snapshotView(afterScreenUpdates: true) {
            destination.view.addSubview(snapshot)
            UIView.transition(with: window, duration: 0.3, animations: {
                window.rootViewController = destination
            }, completion: { _ in
                UIView.animate(withDuration: 0.2, delay: 0, animations: {
                    snapshot.alpha = 0
                }, completion: { _ in
                    snapshot.removeFromSuperview()
                })
            })
        } else {
            window.rootViewController = destination
        }
    }

    /// Выполнить транзакцию с анимацей с `UIView.AnimationOptions`
    /// - Parameter destination: Новый `UIViewController`
    /// - Parameter window: Окно приложения
    /// - Parameter animation: Анимация`UIView.AnimationOptions`
    func animationTransition(to destination: UIViewController,
                             with window: UIWindow,
                             animation: UIView.AnimationOptions) {
        let setWindow: () -> Void = { window.rootViewController = destination }
        UIView.transition(with: window,
                          duration: 0.5,
                          options: animation,
                          animations: setWindow,
                          completion: nil)
    }

    /// Презентует модуль на `rootViewController` затем заминить `rootViewController` на `destination`
    /// - Parameter destination: Новый `UIViewController`
    /// - Parameter window: Окно приложения
    /// - Parameter animated: true, чтобы показать модуль анимационно
    func present(destination: UIViewController, with window: UIWindow, animated: Bool) {
        destination.modalPresentationStyle = .fullScreen
        destination.modalTransitionStyle = .crossDissolve
        window.rootViewController?.present(destination, animated: animated) {
            DispatchQueue.main.async { window.rootViewController = destination }
        }
    }
}

// MARK: - UIWindow + WindowTransition
extension UIWindow: WindowTransition {

    public func transition(to destination: UIViewController,
                           with window: UIWindow,
                           option: WindowTransitionOptions) {
        switch option {
        case .none:
            window.rootViewController = destination
        case .presenting(let animated):
            present(destination: destination, with: window, animated: animated)
        case .animation(let animation):
            animationTransition(to: destination, with: window, animation: animation)
        }
    }

    /// Изменить текущий корневой `UIViewController` окна на новый
    /// - Parameter destination: Новый `UIViewController`
    /// - Parameter option: Опции анимации
    public func transition(to destination: UIViewController, option: WindowTransitionOptions = .none) {
        transition(to: destination, with: self, option: option)
    }
}

/// Конфигуратор транзакции между модулями
public struct TransitionConfigurator {

    /// Замыкание конфигурации
    public typealias Configurator = (AnyModuleInitializer) -> Void

    /// Замыкание конфигурации
    public let configurator: Configurator

    /// Инициализация
    ///
    /// - Parameter configurator: замыкание конфигурации
    public init(_ configurator: @escaping Configurator) {
        self.configurator = configurator
    }
}

/// Активатор таб в таббар
public protocol TabActivator {

    /// Тип `UIViewController`
    static var key: UIViewController.Type { get }
}

// MARK: - UIViewController + TabActivator
extension UIViewController: TabActivator {
    
    public static var key: UIViewController.Type {
        Self.self
    }
}

/// Протокол контроля перехода между моделями
public protocol TransitionController: AggregateAbility {

    /// Показывает модуль в основном контексте.
    ///
    /// - Parameter module: Модуль назначения
    func show(_ module: CArchModule)

    /// Показывает модуль во вторичном (или подробном) контексте.
    ///
    /// - Parameter module: Модуль назначения
    func showDetail(_ module: CArchModule)

    /// Пуш модуль через `UINavigationController`
    ///
    /// - Parameters:
    ///   - module: Модуль назначения
    ///   - flag: true, чтобы показать модуль анимационно
    func push(_ module: CArchModule, animated flag: Bool)

    /// Презентует модуль
    ///
    /// - Parameters:
    ///   - module: Модуль назначения
    ///   - flag: true, чтобы показать модуль анимационно
    ///   - completion: Если анимационно, замыкание, которое будет выполнено после завершения анимации транзакции
    func present(_ module: CArchModule,
                 animated flag: Bool,
                 completion: TransitionCompletion?)
    
    /// Показать модуль поверх всех контроллеров
    /// - Parameters:
    ///   - module: модуль
    ///   - flag: true, чтобы показать модуль анимационно
    ///   - completion: Если анимационно, замыкание, которое будет выполнено после завершения анимации транзакции
    func presentOver(_ module: CArchModule,
                     animated flag: Bool,
                     completion: TransitionCompletion?)

    /// Показать модуль выполняя перехода с указанным идентификатором
    ///
    /// - Parameters:
    ///   - id: id перехода
    ///   - configurator: Блок конфигурации
    func showModule(performingSegueWithIdentifier id: UIStoryboardSegue.Identifier,
                    configurator: TransitionConfigurator?)

    /// Показать модуль деталей используя UISplitViewController
    /// - Parameters:
    ///   - module: Модуль назначения
    ///   - configurator: Блок конфигурации
    func showSplitDetailModule(_ module: CArchModule, configurator: TransitionConfigurator?)

    /// Соберет модули в `UITabBarController`
    /// - Parameter modules: Модули для собра
    func assemblyIntoTabBar(_ modules: [CArchModule])

    /// Активирует модуль Таббара
    /// - Parameter activator: Активатор
    func activate(with activator: TabActivator.Type)
    
    /// Активирует модуль Таббара
    /// - Parameter activator: Модуль назначения
    func activate(_ module: CArchModule.Type)

    /// Добавить submodule к текущему модулю
    ///
    /// - Parameter submodule: Submodule
    /// - Parameter container: Контейнер на основном модуле
    func embed<Submodule, Container>(submodule: Submodule,
                                     container: Container) where Submodule: CArchModule, Container: UIView

    /// Убрать submodule от основного модуля
    ///
    /// - Parameter submodule: Submodule
    func removeEmbed<Submodule>(submodule: Submodule.Type) where Submodule: CArchModule

    /// Вернуться к указанному модулю, если он есть в стеке `UINavigationController`
    /// вызвается у `UINavigationController` метод `popToViewController`
    ///
    /// - Parameters:
    ///   - module: Тип модуль
    ///   - animated: true чтобы закрыть модуль анимационно
    ///   - configuration: Блок конфигурации
    func pop<Module, State>(to module: Module.Type,
                            with state: State?,
                            animated: Bool) where Module: CArchModule, State: ModuleFinalState

    /// Вернуться к предыдущему модулю в стеке у `UINavigationController`
    ///
    /// - Parameter disposableStack: Если true вернуться к первому модулю в стеке у `UINavigationController`
    /// - Parameter animated: true чтобы закрыть модуль анимационно
    func pop(_ disposableStack: Bool, _ animated: Bool)

    /// Закрыть презентовый модуль
    ///
    /// - Parameter state: Финальное состояние модуля
    /// - Parameter animated: true чтобы закрыть модуль анимационно
    /// - Parameter completion: Если анимационно, замыкание, которое будет выполнено после завершения анимации транзакции
    func dismiss<State>(with state: State, animated: Bool, completion: TransitionCompletion?) where State: ModuleFinalState

    /// Закрыть презентовый модуль
    /// - Parameter animated: true чтобы закрыть модуль анимационно
    /// - Parameter completion: Если анимационно, замыкание, которое будет выполнено после завершения анимации
    func dismiss(animated: Bool, completion: TransitionCompletion?)
}

// MARK: - TransitionController + Default
public extension TransitionController {

    /// Пуш модуль через `UINavigationController`
    /// - Parameter module: Модуль назначения
    func push(_ module: CArchModule) {
        push(module, animated: true)
    }

    /// Презентует модуль
    ///
    /// - Parameter module: Модуль назначения
    /// - Parameter flag: true, чтобы показать модуль анимационно
    func present(_ module: CArchModule, animated flag: Bool) {
        present(module, animated: flag, completion: nil)
    }

    /// Презентует модуль
    ///
    /// - Parameter module: Модуль назначения
    func present(_ module: CArchModule) {
        present(module, animated: true, completion: nil)
    }
    /// Показать модуль поверх всех контроллеров
    /// - Parameters:
    ///   - module: модуль
    ///   - flag: true, чтобы показать модуль анимационно
    func presentOver(_ module: CArchModule, animated flag: Bool) {
        presentOver(module, animated: flag, completion: nil)
    }
    
    /// Показать модуль поверх всех контроллеров
    /// - Parameters:
    ///   - module: модуль
    func presentOver(_ module: CArchModule) {
        presentOver(module, animated: true, completion: nil)
    }

    /// Показать модуль выполняя перехода с указанным идентификатором
    ///
    /// - Parameter id: id перехода
    func showModule(performingSegueWithIdentifier id: UIStoryboardSegue.Identifier) {
        showModule(performingSegueWithIdentifier: id, configurator: nil)
    }

    /// Показать модуль деталей используя UISplitViewController
    /// - Parameter module: Модуль назначения
    func showSplitDetailModule(_ module: CArchModule) {
        showSplitDetailModule(module, configurator: nil)
    }

    func activate(_ module: CArchModule.Type) {
        guard let activator = module as? TabActivator.Type else {
            preconditionFailure("CArchModule must be an TabActivator")
        }
        activate(with: activator)
    }
    
    /// Вернуться к предыдущему модулю в стеке у `UINavigationController`
    /// - Parameter animated: true чтобы закрыть модуль анимационно
    func pop(animated: Bool = true) {
        pop(false, animated)
    }

    /// Вернуться к предыдущему модулю в стеке у `UINavigationController`
    func pop() {
        pop(false, true)
    }

    /// Закрыть приезнтовный модуль
    /// - Parameter animated: true чтобы закрыть модуль анимационно
    func dismiss(animated: Bool) {
        dismiss(animated: animated, completion: nil)
    }

    /// Закрыть приезнтовный модуль
    func dismiss() {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - TransitionController + UIViewController
public extension TransitionController where Self: UIViewController {

    func show(_ module: CArchModule) {
        show(module.view, sender: nil)
    }

    func showDetail(_ module: CArchModule) {
        showDetailViewController(module.view, sender: nil)
    }

    func push(_ module: CArchModule, animated flag: Bool = true) {
        navigationController?.pushViewController(module.view, animated: flag)
    }

    func present(_ module: CArchModule,
                 animated flag: Bool = true,
                 completion: TransitionCompletion? = nil) {
        present(module.view, animated: flag) { [weak self, weak module] in
            guard let module = module, let self = self else { return }
            completion?(self, module)
        }
    }
    
    func presentOver(_ module: CArchModule, animated flag: Bool = true, completion: TransitionCompletion? = nil) {
        var topViewController: UIViewController = self
        while let next = topViewController.presentedViewController {
            topViewController = next
        }
        
        topViewController.present(module.view, animated: flag) { [weak self, weak module] in
            guard let module = module, let self = self else { return }
            completion?(self, module)
        }
    }

    func showModule(performingSegueWithIdentifier id: UIStoryboardSegue.Identifier,
                    configurator: TransitionConfigurator? = nil) {
        performSegue(withIdentifier: id.rawValue, sender: configurator)
    }

    func showSplitDetailModule(_ module: CArchModule,
                               configurator: TransitionConfigurator? = nil) {
        if let splitViewController = self.splitViewController {
            splitViewController.showDetailViewController(module.view, sender: configurator)
        } else {
            preconditionFailure("No SplitViewController to embed into")
        }
    }

    func assemblyIntoTabBar(_ modules: [CArchModule]) {
        if let tabBarController = self as? UITabBarController {
            tabBarController.viewControllers = modules.map { $0.view }
        } else if let tabBarController = tabBarController {
            tabBarController.viewControllers = modules.map { $0.view }
        } else {
            preconditionFailure("No tab bar to assrmbly moduls into")
        }
    }

    func activate(with activator: TabActivator.Type) {
        guard let index = tabBarController?.viewControllers?.firstIndex(for: activator) else {
            preconditionFailure("Colud not to filde index of \(String(describing: activator.key))")
        }
        tabBarController?.selectedIndex = index
    }

    func embed<Submodule, Container>(submodule: Submodule,
                                     container: Container) where Submodule: CArchModule, Container: UIView {
        addChild(submodule.view)
        submodule.view.view.frame = container.bounds
        container.addSubview(submodule.view.view)
        submodule.view.didMove(toParent: self)
    }

    func removeEmbed<Submodule>(submodule: Submodule.Type) where Submodule: CArchModule {
        for child in children {
            guard child is Submodule else { continue }
            child.willMove(toParent: nil)
            child.view.removeFromSuperview()
            child.removeFromParent()
            break
        }
    }

    func pop<Module, State>(to module: Module.Type,
                            with state: State? = nil,
                            animated: Bool = true) where Module: CArchModule, State: ModuleFinalState {
        guard let navigationController = navigationController else { return }
        for viewController in navigationController.viewControllers {
            guard viewController is Module else { continue }
            if let state = state {
                viewController.finalizer?.didFinalization(with: state)
            }
            navigationController.popToViewController(viewController, animated: animated)
            break
        }
    }

    func pop(_ disposableStack: Bool = false, _ animated: Bool = true) {
        if disposableStack {
            navigationController?.popToRootViewController(animated: animated)
        } else {
            navigationController?.popViewController(animated: animated)
        }
    }

    func dismiss<State>(with state: State, animated: Bool, completion: TransitionCompletion?) where State: ModuleFinalState {
        if let presentingViewController = presentationController?.presentingViewController {
            presentingViewController.finalizer?.didFinalization(with: state)
            dismiss(animated: animated) { [weak self, weak presentingViewController] in
                guard let self = self, let presentingViewController = presentingViewController else { return }
                completion?(self, presentingViewController)
            }
        }
    }

    func dismiss(animated: Bool, completion: TransitionCompletion?) {
        dismiss(animated: animated) { [weak self, weak presentingViewController] in
            guard let self = self, let presentingViewController = presentingViewController else { return }
            completion?(self, presentingViewController)
        }
    }
}

// MARK: - Array + UIViewController
private extension Array where Element == UIViewController {
    
    func firstIndex(for activator: TabActivator.Type) -> Int? {
        firstIndex(where: {
            if let navigationController = $0 as? UINavigationController {
                if let first = navigationController.viewControllers.first {
                    return type(of: first) == activator.key
                } else {
                    return false
                }
            } else {
                return type(of: $0) == activator.key
            }
        })
    }
}
