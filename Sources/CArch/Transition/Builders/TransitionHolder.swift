//
//  TransitionHolder.swift
//

#if canImport(UIKit)
import UIKit

/// Носитель информации о переходе
public final class TransitionHolder {
    
    /// Данные инициализации модуля
    var state: ModuleInitialState?
    /// Иерархии модуля
    var hierarchy: Hierarchy = .clear
    /// Тип транзакции
    var transition: TransitionBuilder.Transition = .auto
    /// Анимационная ли транзакция
    var animated: Bool = true
    /// Иерархии модуля
    var builder: AnyHierarchyModuleBuilder?
    /// Если анимационно, замыкание, которое будет выполнено после завершения анимации транзакции
    var completion: TransitionCompletion?
    /// Модуль
    private var module: CArchModule?
    
    /// Создает и возвращает новый экземпляр `TransitionHolder`
    public static var make: Self {
        .init()
    }
    
    /// Добавить данные инициализации модуля к билдеру
    /// - Parameter state: Данные инициализации модуля
    /// - Returns: текущий билдер Транзакции
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
    public func with(transition: TransitionBuilder.Transition) -> Self {
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
    
    /// Добавить замыкание завершения анимации транзакции модуля к билдеру
    /// оно выполняется только если тип `Transition` был `Transition.present`
    /// - Parameter completion: Замыкание завершения анимации транзакции модуля
    /// - Returns: Текущий билдер транзакции
    public func with(completion: @escaping TransitionCompletion) -> Self {
        self.completion = completion
        return self
    }
    
    /// Добавить модуль к билдеру
    /// - Parameter module: Модуль
    /// - Returns: Текущий билдер транзакции
    public func with(module: CArchModule) -> Self {
        self.module = module
        return self
    }
}
#endif
