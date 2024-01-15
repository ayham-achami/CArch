//
//  CArchPlugin.swift
//

import SwiftCompilerPlugin
import SwiftSyntaxMacros

@main
struct CArchPlugin: CompilerPlugin {
    
    let providingMacros: [Macro.Type] = [SyncAliasMacro.self,
                                         UIContactorMacro.self]
}
