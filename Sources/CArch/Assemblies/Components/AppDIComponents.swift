//
//  AppDIComponents.swift
//

import Foundation

/// <#Description#>
public protocol AppDIComponents: AnyObject, Sendable, DIAssemblyFactoryDebugger {
    
    /// <#Description#>
    static var collection: any DIAssemblyCollection { get }
    
    /// <#Description#>
    /// - Parameter _: <#_ description#>
    /// - Returns: <#description#>
    static func registerAppComponents<Factory>(_: Factory.Type) where Factory: DIAssemblyFactory
}

// MARK: - AppDIComponents + Default
public extension AppDIComponents {
    
    static func registerAppComponents<Factory>(_: Factory.Type) where Factory: DIAssemblyFactory {
        Factory().record(collection)
    }
}
