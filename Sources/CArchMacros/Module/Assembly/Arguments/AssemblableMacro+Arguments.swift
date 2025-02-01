//
//  AssemblableMacro+Arguments.swift
//

import Foundation

// MARK: - AssemblableMacro + MacroArgumentLabel
extension AssemblableMacro {
    
    /// Типы аргументов макроса
    enum ArgumentLabel: String, MacroArgumentLabel {
        
        case options
        case behavior
    }
}

// MARK: - AssemblableMacro + Arguments
extension AssemblableMacro {
    
    struct Arguments {
                
        let type: String
        let options: AssemblyOptions
        let behavior: AssemblyBehavior
    }
}
