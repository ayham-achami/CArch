//
//  TransitionBuilder.swift
//

#if canImport(UIKit)
import UIKit

/// Билдер транзакции
@MainActor public final class TransitionBuilder: Sendable {

    /// Типы транзакции
    public enum Transition: Sendable {

        // Показать модуль если у source есть `UINavigationController` то, выполняется push если нет то, выполняется present
        case auto
        // Запушать модуль через `UINavigationController`
        case push
        // Запушать модуль как DetailViewController
        case detail
        // Презентовать модуль
        case present
        // Добавить childe `UIViewController`
        case embed(UIView)
        // Кастомный Презентовать модуль
        case customPresent(UIModalPresentationStyle, UIModalTransitionStyle)
    }
    
    /// Фабричный метод создания билдера
    /// - Parameter transitionController: Контролер перехода между моделями
    /// - Returns: Билдер транзакции
    static public func with(_ transitionController: TransitionController) -> Self {
        .init(transitionController)
    }
    
    /// Фабричный метод создания билдера
    /// - Parameters:
    ///   - transitionController: Контролер перехода между моделями
    ///   - holder: Носитель информации о переходе
    /// - Returns: Билдер транзакции
    @available(*, deprecated, message: "This feature has been deprecated and will be removed in future release")
    static public func with(_ transitionController: TransitionController, _ holder: TransitionHolder) -> Self {
        .init(transitionController, holder)
    }

    /// Данные инициализации модуля
    private var state: ModuleInitialState?
    /// Иерархии модуля
    private var hierarchy: Hierarchy = .clear
    /// Тип транзакции
    private var transition: Transition = .auto
    /// Анимационная ли транзакция
    private var animated: Bool = true
    /// Билдер модуля
    private var builder: AnyHierarchyModuleBuilder?
    /// Если анимационно, замыкание, которое будет выполнено после завершения анимации транзакции
    private var completion: TransitionCompletion?
    /// Модуль
    private var module: CArchModule?

    /// Контролер перехода между моделями
    private unowned var transitionController: TransitionController

    /// Инициализации
    /// - Parameter transitionController: Контролер перехода между моделями
    private init(_ transitionController: TransitionController) {
        self.transitionController = transitionController
    }
    
    /// Инициализации
    /// - Parameters:
    ///   - transitionController: Контролер перехода между моделями
    ///   - holder: Носитель информации о переходе
    @available(*, deprecated, message: "This feature has been deprecated and will be removed in future release")
    private init(_ transitionController: TransitionController, _ holder: TransitionHolder) {
        self.state = holder.state
        self.hierarchy = holder.hierarchy
        self.transition = holder.transition
        self.animated = holder.animated
        self.builder = holder.builder
        self.completion = holder.completion
        self.transitionController = transitionController
    }
    
    /// Добавить данные инициализации модуля к билдеру
    /// - Parameter state: Данные инициализации модуля
    /// - Returns: Tекущий билдер Транзакции
    public func with(state: ModuleInitialState) -> Self {
        self.state = state
        return self
    }

    /// Добавить иерархии модуля к билдеру
    /// - Parameter hierarchy: Иерархии модуля
    /// - Returns: Текущий билдер транзакции
    public func with(hierarchy: Hierarchy) -> Self {
        self.hierarchy = hierarchy
        return self
    }
    
    /// Добавить тип транзакции к билдеру
    /// - Parameter transition: Тип транзакции
    /// - Returns: Текущий билдер транзакции
    public func with(transition: Transition) -> Self {
        self.transition = transition
        return self
    }

    /// Добавить анимацию
    /// - Parameter animated: Анимационная ли транзакция
    public func with(animated: Bool) -> Self {
        self.animated = animated
        return self
    }
    
    /// Добавить билдер иерархии модуля к билдеру
    /// - Parameter builder: Билдер иерархии модуля
    /// - Returns: Текущий билдер транзакции
    public func with(builder: AnyHierarchyModuleBuilder) -> Self {
        self.builder = builder
        return self
    }
    
    /// Добавить модуль к билдеру
    /// - Parameter module: Модуль
    /// - Returns: Текущий билдер транзакции
    public func with(module: CArchModule) -> Self {
        self.module = module
        return self
    }
    
    /// Добавить замыкание завершения анимации транзакции модуля к билдеру
    /// оно выполняется только если тип `Transition` был `Transition.present`
    /// - Parameter completion: Замыкание завершения анимации транзакции модуля
    /// - Returns: Текущий билдер транзакции
    public func with(completion: @escaping TransitionCompletion) -> Self {
        self.completion = completion
        return self
    }

    /// Выполняет транзакцию
    public func commit() {
        if let module {
            perform(with: module)
        } else if let module = builder?.build(with: state, into: hierarchy) {
            perform(with: module)
        } else {
            preconditionFailure("The Hierarchy Builder is nil checkout your settings")
        }
    }
    
    /// Выполняет транзакцию с нужным модулям
    /// - Parameter module: Модуль
    private func perform(with module: CArchModule) {
        switch transition {
        case .auto:
            transitionController.show(module)
        case .push:
            transitionController.push(module, animated: animated)
        case .detail:
            transitionController.showSplitDetailModule(module)
        case .present:
            transitionController.present(module, animated: animated, completion: completion)
        case .embed(let container):
            transitionController.embed(submodule: module.node, container: container)
        case .customPresent(let presentationStyle, let transitionStyle):
            module.node.modalPresentationStyle = presentationStyle
            module.node.modalTransitionStyle = transitionStyle
            transitionController.present(module, animated: animated, completion: completion)
        }
    }
}
#endif
