//
//  BusinessLogicService.swift
//

import Foundation

// Базовый протокол любого сервиса слоя бизнес логики
/// нельзя создавать сервис и не наследовать данный протокол
@available(*, deprecated, message: "This feature has be deprecated and will be removed in future release, Use BusinessLogicService")
public protocol LegacyBusinessLogicService: CArchProtocol, CustomStringConvertible, CustomDebugStringConvertible {}

// MARK: - BusinessLogicService + StringConvertible
@available(*, deprecated, message: "This feature has be deprecated and will be removed in future release")
public extension LegacyBusinessLogicService {

    var description: String {
        "⚙️ \(String(describing: Self.self))"
    }

    var debugDescription: String {
        description
    }
}
