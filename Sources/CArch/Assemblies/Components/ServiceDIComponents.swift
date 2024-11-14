//
//  ServiceDIComponents.swift
//

import Foundation

/// <#Description#>
public protocol ServiceDIComponents: AnyObject, Sendable {
    
    /// <#Description#>
    static var collection: any DIAssemblyCollection { get }
    
    /// <#Description#>
    var resolver: DIResolver { get }
    
    /// <#Description#>
    init()
}
