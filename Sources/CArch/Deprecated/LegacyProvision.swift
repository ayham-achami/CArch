//
//  Provision.swift
//

import Foundation

/// Основной протокол содержащий логику взаимодействия с BusinessLogic слоя
/// все протоколы `ProvisionLogic` должны быть унаследованными от `RootProvisionLogic`
@available(*, deprecated, message: "This feature has be deprecated and will be removed in future release, Use RootProvisionLogic")
public protocol LegacyRootProvisionLogic: CArchProtocol {}
