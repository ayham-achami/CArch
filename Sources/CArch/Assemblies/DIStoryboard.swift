//
//  DIStoryboard.swift
//

#if canImport(UIKit)
import UIKit

/// Протокол получения UIViewController из Storyboard с помощью DI
@available(*, deprecated, message: "This feature has be deprecated and will be removed in future release")
public protocol DIStoryboard {
    
    /// Настроить замыкание, которое необходимо
    /// выполнять при заверении инициализации UIViewController из Storyboard
    /// - Parameters:
    ///   - controllerType: Тип UIViewController
    ///   - name: Названине UIViewController
    ///   - initCompleted: Замыкание инициализации
    func setInitCompleted<Controller>(for controllerType: Controller.Type,
                                      name: String?,
                                      initCompleted: @escaping (DIResolver, Controller) -> Void) where Controller: UIViewController
}

// MARK: - DIStoryboard + Additions
@available(*, deprecated, message: "This feature has be deprecated and will be removed in future release")
public extension DIStoryboard {
    
    /// Настроить замыкание, которое необходимо
    /// выполнять при заверении инициализации UIViewController из Storyboard
    /// - Parameters:
    ///   - controllerType: Тип UIViewController
    ///   - initCompleted: Замыкание инициализации
    @available(*, deprecated, message: "This feature has be deprecated and will be removed in future release")
    func setInitCompleted<Controller>(for controllerType: Controller.Type,
                                      initCompleted: @escaping (DIResolver, Controller) -> Void) where Controller: UIViewController {
        setInitCompleted(for: controllerType, name: nil, initCompleted: initCompleted)
    }
}
#endif
