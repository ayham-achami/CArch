//
//  Presentation.swift
//

import Foundation

/// Основной протокол содержащий логику преобразование данных
/// в UIModel все протолколы `PresentationLogic` должны быть
/// унаследованными от `RootPresentationLogic`
public protocol RootPresentationLogic: CArchModuleComponent {

    /// Обработка ошибки от BusinessLogic слоя
    /// - Parameter error: Ошибка от BusinessLogic слоя
    func encountered(_ error: Error)
}
