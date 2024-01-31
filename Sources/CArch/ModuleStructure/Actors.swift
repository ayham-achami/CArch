//
//  Actors.swift
//

import Foundation

/// Глобальный актор для выполнения асинхронных задач бизнес логики
@globalActor public actor ProvisionActor {
    
    /// `ProvisionActor`
    public static var shared = ProvisionActor()
    
    /// Инициализация
    private init() {}
}

/// Глобальный актор для выполнения асинхронных задач бизнес логики уровня провайдера
@globalActor public actor MaintenanceActor {
    
    /// `MaintenanceActor`
    public static var shared = MaintenanceActor()
    
    /// Инициализация
    private init() {}
}
