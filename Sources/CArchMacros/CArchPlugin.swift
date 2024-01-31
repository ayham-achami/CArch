//
//  CArchPlugin.swift
//

import SwiftCompilerPlugin
import SwiftSyntaxMacros

@main
struct CArchPlugin: CompilerPlugin {
    
    let providingMacros: [Macro.Type] = [ContractMacro.self,
                                         SyncAliasMacro.self,
                                         UIContactorMacro.self]
}
