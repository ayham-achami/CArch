//
//  Provision.swift
//

import Foundation

/// Протокол обработки ошибок
public protocol ErrorAsyncHandler: CArchModuleComponent {
    
    /// Обрабатывает ошибку
    /// - Parameter error: Ошибка
    func encountered(_ error: Error)
}

/// Основной протокол содержащий логику взаимодействия с BusinessLogic слоя
/// все протоколы `ProvisionLogic` должны быть унаследованными от `RootProvisionLogic`
@ProvisionActor public protocol RootProvisionLogic: CArchModuleComponent {}
