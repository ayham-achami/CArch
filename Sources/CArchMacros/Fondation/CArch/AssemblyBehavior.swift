//
//  AssemblyBehavior.swift
//

import SwiftSyntax

/// Поведение (тип сборки) сборки
public enum AssemblyBehavior {
    
    /// Автоматический
    case auto
    /// Любой тип
    case some
}

// MARK: - AssemblyBehavior + Parsing 
extension AssemblyBehavior {
    
    static func parse(from expr: MemberAccessExprSyntax) throws(Parsing.Error) -> Self {
        switch expr.declName.baseName.text {
        case "auto": .auto
        case "some": .some
        default: throw Parsing.Error.invalidArgument("AssemblyBehavior")
        }
    }
}
