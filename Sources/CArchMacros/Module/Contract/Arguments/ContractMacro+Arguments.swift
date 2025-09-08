//
//  ContractMacro+Arguments.swift
//

import SwiftSyntax
import SwiftSyntaxMacros

// MARK: - ContractMacro + Arguments
extension ContractMacro {
    
    /// Аргументы макроса
    struct Arguments {
        
        var defaultImplementation: String {
            get throws {
                guard
                    let `default` = implementations.values.first(where: { $0 == "default" })
                else { throw  Error.defaultImplementation }
                return `default`
            }
        }
        
        /// CArch component
        let component: CArchComponent
        /// Область видимости XResolver
        let visibility: Visibility?
        /// Опцы Assembly
        let options: AssemblyOptions
        /// Доступные объекты имплементация
        let implementations: [String: String]
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
    
    /// Типы аргументов макроса
    enum ArgumentsLabel: String, MacroArgumentLabel {
        
        case options
        case implementations
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
