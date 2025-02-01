//
//  Macro+Diagnostics.swift
//

import Foundation
import SwiftDiagnostics

/// Namespace Macros для поротокол
enum ProtocolsMacros {
    
    /// Ошибка
    enum Error: Swift.Error, CustomStringConvertible {
        
        /// Не является протоколом
        case notSupported(Any.Type)
        
        var description: String {
            switch self {
            case let .notSupported(type):
                "\(String(describing: type.self)) can be applied to protocols only"
            }
        }
    }
}

/// Namespace типа объекта
enum ObjectMacros {
    
    /// гументОшибки
    enum Error: Swift.Error, CustomStringConvertible {
    
        /// Не поддерживается
        case notSupported(Any.Type)
        
        var description: String {
            switch self {
            case let .notSupported(type):
                "\(String(describing: type.self)) can be applied to Structure, Class or Actors only"
            }
        }
    }
}

/// Namespace парсинга
enum Parsing {
    
    /// Ошибки
    enum Error: Swift.Error, CustomStringConvertible {
    
        /// Неверный аргумент
        case invalidArgument(String)
        /// Отсутствует обязательный аргумент
        case missingArgument(String)
        
        var description: String {
            switch self {
            case .invalidArgument(let message):
                "Invalid argument \(message)"
            case .missingArgument(let name):
                "\(name) is required argument"
            }
        }
    }
}

/// Namespace Диагностика
enum Diagnostics {
    
    /// Сообщения диагностики
    struct Message: DiagnosticMessage, FixItMessage, Swift.Error {
        
        public let message: String
        public let diagnosticID: MessageID
        public let severity: DiagnosticSeverity
        
        public var fixItID: MessageID { diagnosticID }
    }
}

// MARK: - Diagnostics + Error
extension Diagnostics {
    
    enum Error: Swift.Error, CustomStringConvertible {
        
        case unsupported(String)
        
        var description: String {
            switch self {
            case .unsupported(let message):
                message
            }
        }
    }
}
