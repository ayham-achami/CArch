//
//  RoutingAdvantage.swift
//

#if canImport(UIKit)
import UIKit

/// Тип перехода с преимуществом
@available(*, deprecated, message: "This feature has been deprecated and will be removed in future release")
public protocol RoutingAdvantageType {}

/// Перехода с преимуществом
@available(*, deprecated, message: "This feature has been deprecated and will be removed in future release")
@MainActor public protocol RoutingAdvantage: AnyObject {
    
    /// Требуется переход с преимуществом
    /// - Parameter type: Тип
    /// - Returns: Носитель информации о переходе
    func didRequestTransition<T>(with type: T) -> TransitionHolder where T: RoutingAdvantageType
}

/// Представление о контроле перехода
@available(*, deprecated, message: "This feature has been deprecated and will be removed in future release")
@MainActor public protocol TransitionControllerRepresentable {
    
    /// Протокол контроля перехода между моделями
    var transition: TransitionController { get }
}

// MARK: - TransitionControllerRepresentable + Default
@available(*, deprecated, message: "This feature has been deprecated and will be removed in future release")
public extension TransitionControllerRepresentable {
    
    var transition: TransitionController {
        guard
            let transition = Mirror(reflecting: self)
                .children
                .compactMap({ $0.value as? TransitionController })
                .first
        else { preconditionFailure("Couldn't to found TransitionController in \(String(describing: type(of: self)))") }
        return transition
    }
}

// MARK: RootRoutingLogic + TransitionControllerRepresentable
@available(*, deprecated, message: "This feature has been deprecated and will be removed in future release")
public extension RootRoutingLogic where Self: TransitionControllerRepresentable {
    
    /// Выполнение перехода с преимуществом
    /// - Parameters:
    ///   - type: Тип
    ///   - advantage: Перехода с преимуществом
    @MainActor func advantageRoute<T>(with type: T, from advantage: RoutingAdvantage) where T: RoutingAdvantageType {
        let holder = advantage.didRequestTransition(with: type)
        TransitionBuilder
            .with(transition, holder)
            .commit()
    }
}
#endif
