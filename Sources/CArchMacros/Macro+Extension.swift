//
//  Macro+Extension.swift
//  
//
//  Created by Ayham Hylam on 29.07.2023.
//

import Foundation
import SwiftDiagnostics

/// <#Description#>
enum ProtocolsMacros {
    
    /// <#Description#>
    public enum Error: Swift.Error, CustomStringConvertible {
        
        /// <#Description#>
        case notProtocol
        
        public var description: String {
            switch self {
            case .notProtocol:
                return "SyncAliasMacro can be applied to protocols only"
            }
        }
    }
}

/// <#Description#>
enum Diagnostics {
    
    /// <#Description#>
    public struct Message: DiagnosticMessage, FixItMessage, Swift.Error {
        
        public let message: String
        public let diagnosticID: MessageID
        public let severity: DiagnosticSeverity
        
        public var fixItID: MessageID { diagnosticID }
    }
}
