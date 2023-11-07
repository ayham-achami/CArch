//
//  TransitionController.swift
//

#if canImport(UIKit)
import UIKit

/// Замыкание завершения транзакции
/// - source: Уходящий модуль
/// - destination: появляющийся модуль
public typealias TransitionCompletion = ((CArchModule, CArchModule) -> Void)

/// Поддержка все возможности
public typealias AggregateAbility = ShareAbility & MailAbility & DocumentInteractionAbility

/// Конфигуратор транзакции между модулями
public struct TransitionConfigurator {
    
    /// Замыкание конфигурации
    public typealias Configurator = (AnyModuleInitializer) -> Void
    
    /// Замыкание конфигурации
    public let configurator: Configurator
    
    /// Инициализация
    /// - Parameter configurator: замыкание конфигурации
    public init(_ configurator: @escaping Configurator) {
        self.configurator = configurator
    }
}

/// Активатор таб в таббар
@MainActor public protocol TabActivator {
    
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
@MainActor public protocol TransitionController: AggregateAbility {
    
    /// Показывает модуль в основном контексте.
    /// - Parameter module: Модуль назначения
    func show(_ module: CArchModule)
    
    /// Показывает модуль во вторичном (или подробном) контексте.
    /// - Parameter module: Модуль назначения
    func showDetail(_ module: CArchModule)
    
    /// Пуш модуль через `UINavigationController`
    /// - Parameters:
    ///   - module: Модуль назначения
    ///   - flag: true, чтобы показать модуль анимационно
    func push(_ module: CArchModule, animated flag: Bool)
    
    /// Презентует модуль
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
    /// - Parameter submodule: Submodule
    /// - Parameter container: Контейнер на основном модуле
    func embed<Submodule, Container>(submodule: Submodule,
                                     container: Container) where Submodule: CArchModule, Container: UIView
    
    /// Убрать submodule от основного модуля
    /// - Parameter submodule: Submodule
    func removeEmbed<Submodule>(submodule: Submodule.Type) where Submodule: CArchModule
    
    /// Вернуться к указанному модулю, если он есть в стеке `UINavigationController`
    /// вызвается у `UINavigationController` метод `popToViewController`
    /// - Parameters:
    ///   - module: Тип модуль
    ///   - animated: true чтобы закрыть модуль анимационно
    ///   - configuration: Блок конфигурации
    func pop<Module, State>(to module: Module.Type,
                            with state: State?,
                            animated: Bool) where Module: CArchModule, State: ModuleFinalState
    
    /// Вернуться к предыдущему модулю в стеке у `UINavigationController`
    /// - Parameter disposableStack: Если true вернуться к первому модулю в стеке у `UINavigationController`
    /// - Parameter animated: true чтобы закрыть модуль анимационно
    func pop(_ disposableStack: Bool, _ animated: Bool)
    
    /// Закрыть открытый модуль
    /// - Parameter state: Финальное состояние модуля
    /// - Parameter animated: true чтобы закрыть модуль анимационно
    /// - Parameter completion: Если анимационно, замыкание, которое будет выполнено после завершения анимации транзакции
    func dismiss<State>(with state: State, animated: Bool, completion: TransitionCompletion?) where State: ModuleFinalState
    
    /// Закрыть открытый модуль
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
    
    /// Показать модуль деталей используя UISplitViewController
    /// - Parameter module: Модуль назначения
    func showSplitDetailModule(_ module: CArchModule) {
        showSplitDetailModule(module, configurator: nil)
    }
    
    func activate(_ module: CArchModule.Type) {
        guard
            let activator = module as? TabActivator.Type
        else { preconditionFailure("CArchModule must be an TabActivator") }
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
    
    /// Закрыть открытый модуль
    /// - Parameter animated: true чтобы закрыть модуль анимационно
    func dismiss(animated: Bool) {
        dismiss(animated: animated, completion: nil)
    }
    
    /// Закрыть открытый модуль
    func dismiss() {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - TransitionController + UIViewController
public extension TransitionController where Self: UIViewController {
    
    func show(_ module: CArchModule) {
        show(module.node, sender: nil)
    }
    
    func showDetail(_ module: CArchModule) {
        showDetailViewController(module.node, sender: nil)
    }
    
    func push(_ module: CArchModule, animated flag: Bool = true) {
        navigationController?.pushViewController(module.node, animated: flag)
    }
    
    func present(_ module: CArchModule,
                 animated flag: Bool = true,
                 completion: TransitionCompletion? = nil) {
        present(module.node, animated: flag) { [weak self, weak module] in
            guard
                let module = module,
                let self = self
            else { return }
            completion?(self, module)
        }
    }
    
    func presentOver(_ module: CArchModule, animated flag: Bool = true, completion: TransitionCompletion? = nil) {
        var topViewController: UIViewController = self
        while let next = topViewController.presentedViewController {
            topViewController = next
        }
        topViewController.present(module.node, animated: flag) { [weak self, weak module] in
            guard
                let module = module,
                let self = self
            else { return }
            completion?(self, module)
        }
    }

    func showSplitDetailModule(_ module: CArchModule,
                               configurator: TransitionConfigurator? = nil) {
        guard
            let splitViewController = self.splitViewController
        else { preconditionFailure("No SplitViewController to embed into") }
        splitViewController.showDetailViewController(module.node, sender: configurator)
    }
    
    func assemblyIntoTabBar(_ modules: [CArchModule]) {
        if let tabBarController = self as? UITabBarController {
            tabBarController.viewControllers = modules.map { $0.node }
        } else if let tabBarController = tabBarController {
            tabBarController.viewControllers = modules.map { $0.node }
        } else {
            preconditionFailure("No tab bar to assembly models into")
        }
    }
    
    func activate(with activator: TabActivator.Type) {
        guard
            let index = tabBarController?.viewControllers?.firstIndex(for: activator)
        else { preconditionFailure("Could not to find index of \(String(describing: activator.key))") }
        tabBarController?.selectedIndex = index
    }
    
    func embed<Submodule, Container>(submodule: Submodule,
                                     container: Container) where Submodule: CArchModule, Container: UIView {
        addChild(submodule.node)
        submodule.node.view.frame = container.bounds
        container.addSubview(submodule.node.view)
        submodule.node.didMove(toParent: self)
    }
    
    func removeEmbed<Submodule>(submodule: Submodule.Type) where Submodule: CArchModule {
        for child in children {
            guard child is Submodule else { continue }
            child.willMove(toParent: nil)
            child.node.view.removeFromSuperview()
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
    
    @MainActor func firstIndex(for activator: TabActivator.Type) -> Int? {
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

// MARK: - UIViewController + TransitionController
extension UIViewController: TransitionController {}
#endif
