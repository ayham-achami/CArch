//
//  SendableLazy.swift
//

import Foundation

/// Создает в изолированным контексте Ленивый объект
public actor SendableLazy<T>: AutoResolve where T: Sendable, T: AutoResolve {
    
    /// Ленивый объект
    public lazy var value: T = factory()
    
    private let factory: @Sendable () -> T
    
    /// Инициализация
    /// - Parameter resolver: Фабрика создания объектов
    public init(_ resolver: DIResolver) {
        self.factory = {
            .init(resolver)
        }
    }
}
