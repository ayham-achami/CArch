//
//  Routing.swift
//

#if canImport(UIKit)
import UIKit

/// Ошибка подготовки транзакции между модулями
@available(*, deprecated, message: "This feature has be deprecated and will be removed in future release")
struct TransitionPrepareError: Error {

    /// Возможные ошибки
    ///
    /// - invalidConfigurator: Инвалидный конфигуратор не удалось преобразовать sendr в TransitionConfigurator
    /// - invalidConvertible: Инвалидный конвертатор не удалось преобразовать destination в AnyModuleInitializer
    enum Case {
        case invalidConfigurator
        case invalidInitializer
    }

    let `case`: Case
}

/// Основной протокол содержащий логику навигации между модулями
/// все протоколы `RoutingLogic` должны быть унаследованными от `RootRoutingLogic`
@available(*, deprecated, message: "This feature has be deprecated and will be removed in future release, Use RootRoutingLogic")
public protocol LegacyRootRoutingLogic: CArchProtocol {

    /// Подготовить транзакцию между модулями
    ///
    /// - Parameters:
    ///   - segue: Объект segue, содержащий информацию о модулях, участвующих в segue
    ///   - sender: Объект создающий транзакцию
    /// - Throws: `TransitionPrepareError`
    func prepare(for segue: UIStoryboardSegue, sender: Any?) throws

    /// Показать диалог ошибки
    /// ```
    /// +----------------------+
    /// |        Error         |
    /// |   Some error has     |
    /// |   happened check     |
    /// |   your settings      |
    /// +----------------------+
    /// |          OK          |
    /// +----------------------+
    /// ```
    /// - Parameter message: Описание ошибки на текущем языка локализации
    func showErrorAlert( _ message: String)
}

// MARK: - RootRoutingLogic + Default
@available(*, deprecated, message: "This feature has be deprecated and will be removed in future release")
public extension LegacyRootRoutingLogic {

    func prepare(for segue: UIStoryboardSegue, sender: Any?) throws {
        guard let sender = sender else { return }
        guard let configurator = sender as? TransitionConfigurator else {
            throw TransitionPrepareError(case: .invalidConfigurator)
        }
        if let initializer = segue.destination as? AnyModuleInitializer {
            configurator.configurator(initializer)
        } else if let navigationController = segue.destination as? UINavigationController,
            let initializer = navigationController.viewControllers.first as? AnyModuleInitializer {
            configurator.configurator(initializer)
        } else {
            throw TransitionPrepareError(case: .invalidInitializer)
        }
    }
}
#endif
