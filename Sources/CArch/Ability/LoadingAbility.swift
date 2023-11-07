//
//  LodingAbility.swift
//

#if canImport(UIKit)
import UIKit

/// Протокол получения доступа к заглушке прогресс загрузки
@MainActor public protocol LoadingPlaceholder {

    /// Заглушка прогресс загрузки
    var front: UIView { get }
}

/// Возможность показать индикатор загрузки
@MainActor public protocol LoadingAbility {

    /// Показать индикатор загрузки
    /// - Parameter message: Сообщение, будет отображаться под индикатором загрузки
    func displayLoading(with message: String)

    /// Скрыть индикатор загрузки
    /// - Parameter completion: Замыкание выполняться после того, как срывается индикатор загрузки
    func hideLoading(completion: (() -> Void))

    /// Показать индикатор загрузки
    /// - Parameter placeholder: Заглушка прогресс загрузки
    func displayLoading(_ placeholder: LoadingPlaceholder?)

    /// Скрыть заглушку прогресс загрузки
    /// - Parameter completion: Замыкание выполняться после того, как срывается заглушке прогресс
    func hideLoadingPlaceholder(completion: (() -> Void)?)

    /// Показать индикатор загрузки
    /// - Parameter view: Цель, где показать индикатор загрузки
    func displayLoading(on view: UIView)

    /// Скрыть индикатор загрузки
    /// - Parameter view: Цель, где скрыть индикатор загрузки
    func hideLoading(on view: UIView)
}

// MARK: - LodingAbility + Default
public extension LoadingAbility {

    func displayLoading() {
        displayLoading(with: "")
    }

    func hideLoading() {
        hideLoading {}
    }
}
#endif
