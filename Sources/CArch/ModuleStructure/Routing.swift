//
//  Routing.swift
//

import Foundation

/// Основной протокол содержащий логику навигации между модулями
/// все протоколы `RoutingLogic` должны быть унаследованными от `RootRoutingLogic`
@MainActor public protocol RootRoutingLogic: CArchModuleComponent {}
