//
//  Macro+Extension.swift
//  
//
//  Created by Ayham Hylam on 29.07.2023.
//

import Foundation
import SwiftDiagnostics

/// Namespace Macros для поротокол
enum ProtocolsMacros {
    
    /// Ошибка
    public enum Error: Swift.Error, CustomStringConvertible {
        
        /// Не является протоколом
        case notProtocol(Any.Type)
        
        public var description: String {
            switch self {
            case let .notProtocol(type):
                return "\(String(describing: type.self)) can be applied to protocols only"
            }
        }
    }
}

/// Namespace Диагностика
enum Diagnostics {
    
    /// Сообщения диагностики
    public struct Message: DiagnosticMessage, FixItMessage, Swift.Error {
        
        public let message: String
        public let diagnosticID: MessageID
        public let severity: DiagnosticSeverity
        
        public var fixItID: MessageID { diagnosticID }
    }
}
