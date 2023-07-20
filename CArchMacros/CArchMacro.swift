import SwiftSyntaxMacros
import SwiftCompilerPlugin

@main
struct CArchPlugin: CompilerPlugin {
    
    let providingMacros: [Macro.Type] = [ProvisioningMacro.self]
}
