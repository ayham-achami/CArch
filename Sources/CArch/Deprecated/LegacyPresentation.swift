//
//  Presentation.swift
//

import Foundation

/// Основной протокол содержащий логику преобразование данных
/// в UIModel все протолколы `PresentationLogic` должны быть
/// унаследованными от `RootPresentationLogic`
@available(*, deprecated, message: "This feature has be deprecated and will be removed in future release, Use RootPresentationLogic")
public protocol LegacyRootPresentationLogic: CArchProtocol {

    /// обработка ошибки от BusinessLogic слоя
    ///
    /// - Parameter error: ошибка от BusinessLogic слоя
    func encountered(_ error: Error)
}
