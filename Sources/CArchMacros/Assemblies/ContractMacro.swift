//
//  ContractMacro.swift
//

import Foundation
import SwiftSyntax
import SwiftSyntaxMacros

/// Макрос, который добавить код внедрение зависимости для протокол
public struct ContractMacro {}

// MARK: - ContractMacro + Arguments
extension ContractMacro {
    
    /// Аргументы макроса
    struct Arguments {
        
        var defaultImplementation: String {
            get throws {
                guard
                let `default` = implementations.keys.first(where: { $0 == "default" })
                else { throw  Error.defaultImplementation }
                return `default`
            }
        }
        
        /// CArch component (agent, service, singleton, pool)
        let component: Component
        /// Область видимости XResolver
        let visibility: Visibility?
        /// Публичный ли класс Assembly
        let isPublicAssembly: Bool
        /// Доступные класс имплементация
        let implementations: [String: String]
    }
}

// MARK: - ContractMacro.Arguments + Component
extension ContractMacro.Arguments {
    
    /// CArch component
    enum Component {
    
        case pool
        case agent
        case service
        case singleton
    }
}

// MARK: - ContractMacro.Arguments + Visibility
extension ContractMacro.Arguments {
    
    /// Область видимости
    enum Visibility: String {
        
        case `public`
        case `private`
    }
}

// MARK: - ContractMacro.Arguments + Error
extension ContractMacro.Arguments {
    
    enum Error: Swift.Error, CustomStringConvertible {
        
        var description: String {
            switch self {
            case .defaultImplementation:
                return "Implementations dictionary must contents some implementation type with default key"
            }
        }
        
        case defaultImplementation
    }
}

// MARK: - ContractMacro + ArgumentsType
extension ContractMacro {
    
    /// <#Description#>
    enum ArgumentsType: String {
        
        /// <#Description#>
        enum Error: Swift.Error, CustomStringConvertible {
            
            var description: String {
                switch self {
                case .convert:
                    return "Could not to convert argument"
                case .inherited:
                    return "Contract protocol must inherited from some CArch component protocol"
                case .unknown(let string):
                    return "Unknown argument \(string) of macro"
                }
            }
            
            case convert
            case inherited
            case unknown(String)
        }
        
        case implementations
        case isPublicAssembly
    }
}

// MARK: - ContractMacro + Arguments + Visibility
extension ContractMacro.Arguments.Visibility {
    
    var syntax: TokenSyntax {
        switch self {
        case .public:
            return .keyword(.public)
        case .private:
            return .keyword(.private)
        }
    }
}
