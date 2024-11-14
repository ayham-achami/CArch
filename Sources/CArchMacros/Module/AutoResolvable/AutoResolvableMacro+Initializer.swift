//
//  AutoResolvableMacro+Initializer.swift
//

import SwiftSyntax
import SwiftSyntaxMacros

// MARK: - AutoResolvableMacro + InitializerDeclSyntax
extension AutoResolvableMacro {
    
    /// <#Description#>
    /// - Parameters:
    ///   - arguments: <#arguments description#>
    ///   - members: <#members description#>
    ///   - context: <#context description#>
    /// - Returns: <#description#>
    static func initializerDeclSyntax(_ arguments: Arguments,
                                      _ members: MemberBlockItemListSyntax,
                                      _ context: some MacroExpansionContext) throws -> [InitializerDeclSyntax] {
        let properties = members.variable(exclude: [.static])
            .map(\.bindings)
            .map { ($0.compactMap(\.pattern.raw), $0.compactMap(\.typeAnnotation?.type.raw)) }
            .mapBoth { Property(name: $0, type: $1) }
        return [try initializer(properties, arguments),
                try resolverInitializer(properties, arguments)]
    }
    
    /// <#Description#>
    /// - Parameters:
    ///   - properties: <#properties description#>
    ///   - arguments: <#arguments description#>
    /// - Returns: <#description#>
    static func initializer(_ properties: [AutoResolvableMacro.Property],
                            _ arguments: AutoResolvableMacro.Arguments) throws -> InitializerDeclSyntax {
        .init(
            modifiers: .init(
                itemsBuilder: {
                    if arguments.options.contains(.public) {
                        .init(name: .keyword(.public))
                    }
                }
            ),
            signature: .init(
                parameterClause: .init(
                    parameters: .parameters(properties, arguments)
                )
            ),
            body: .init(
                statements: .init(
                    itemsBuilder: {
                        for property in properties {
                            .init(
                                item: .expr("self.\(raw: property.name) = \(raw: property.name)")
                            )
                        }
                    }
                )
            )
        )
    }
    
    /// <#Description#>
    /// - Parameters:
    ///   - properties: <#properties description#>
    ///   - arguments: <#arguments description#>
    /// - Returns: <#description#>
    static func resolverInitializer(_ properties: [AutoResolvableMacro.Property],
                                    _ arguments: AutoResolvableMacro.Arguments) throws -> InitializerDeclSyntax {
        .init(
            modifiers: arguments.options.modifiers,
            signature: .init(
                parameterClause: .init(
                    parameters: .init(
                        arrayLiteral: .init(
                            firstName: TokenSyntax(
                                stringLiteral: "_"
                            ),
                            secondName: TokenSyntax(
                                stringLiteral: "resolver"
                            ),
                            type: TypeSyntax(
                                stringLiteral: "DIResolver"
                            )
                        )
                    )
                )
            ),
            body: .init(
                statements: .init(
                    itemsBuilder: {
                        .init(
                            item: .expr(
                                .init(
                                    FunctionCallExprSyntax.selfInit(properties, arguments)
                                )
                            )
                        )
                    }
                )
            )
        )
    }
}

// MARK: - FunctionParameterListSyntax + Parameters
private extension FunctionParameterListSyntax {
    
    /// <#Description#>
    /// - Parameters:
    ///   - properties: <#properties description#>
    ///   - arguments: <#arguments description#>
    /// - Returns: <#description#>
    static func parameters(_ properties: [AutoResolvableMacro.Property],
                           _ arguments: AutoResolvableMacro.Arguments) -> Self {
        .init(
            itemsBuilder: {
                for property in properties {
                    .init(
                        leadingTrivia: properties.isFirst(property) ? nil : .init(
                            pieces: [.newlines(1),
                                     .tabs(arguments.options.contains(.public) ? 3 : 1),
                                     .spaces(arguments.options.contains(.public) ? 0 : 1)]
                        ),
                        firstName: TokenSyntax(
                            stringLiteral: property.name
                        ),
                        type: TypeSyntax(
                            stringLiteral: property.type
                        )
                    )
                }
            }
        )
    }
}

// MARK: - FunctionCallExprSyntax + SelfInit
private extension FunctionCallExprSyntax {
    
    /// <#Description#>
    /// - Parameters:
    ///   - properties: <#properties description#>
    ///   - arguments: <#arguments description#>
    /// - Returns: <#description#>
    static func selfInit(_ properties: [AutoResolvableMacro.Property],
                         _ arguments: AutoResolvableMacro.Arguments) -> Self {
        .init(
            callee: DeclReferenceExprSyntax(
                baseName: .identifier("self.init")
            ),
            argumentList: {
                if arguments.shouldUseResolver {
                    .resolverSyntax(properties, arguments.implementations)
                } else {
                    .someSyntax(properties)
                }
            }
        )
    }
}

// MARK: - LabeledExprListSyntax + Properties
private extension LabeledExprListSyntax {
    
    /// <#Description#>
    /// - Parameter properties: <#properties description#>
    /// - Returns: <#description#>
    static func resolverSyntax(_ properties: [AutoResolvableMacro.Property], _ implementations: [String: String]) -> Self {
        .init {
            for property in properties {
                .init(
                    leadingTrivia: properties.isFirst(property) ? nil : .init(pieces: [.newlines(1), .tabs(2), .spaces(2)]),
                    label: TokenSyntax.init(stringLiteral: property.name),
                    colon: TokenSyntax.colonToken(),
                    expression: ExprSyntax.resolverSyntax(property.type, implementations[property.type])
                )
            }
        }
    }
    
    /// <#Description#>
    /// - Parameter properties: <#properties description#>
    /// - Returns: <#description#>
    static func someSyntax(_ properties: [AutoResolvableMacro.Property]) -> Self {
        .init {
            for property in properties {
                .init(
                    leadingTrivia: properties.isFirst(property) ? nil : .init(pieces: [.newlines(1), .tabs(2), .spaces(2)]),
                    label: TokenSyntax.init(stringLiteral: property.name),
                    colon: TokenSyntax.colonToken(),
                    expression: ExprSyntax(
                        stringLiteral: "resolver.unravel(some: \(property.type).self)"
                    )
                )
            }
        }
    }
}

private extension ExprSyntax {
    
    static func resolverSyntax(_ type: String, _ version: String?) -> Self {
        if let version {
            .init(
                stringLiteral: "\(type)Resolver(resolver).unravel(implementation: .\(version))"
            )
        } else {
            .init(
                stringLiteral: "\(type)Resolver(resolver).unravel()"
            )
        }
    }
}

// MARK: - Array + ([String], [String])
private extension Array where Element == ([String], [String]) {
    
    /// <#Description#>
    /// - Parameter transform: <#transform description#>
    /// - Returns: <#description#>
    func mapBoth<T>(_ transform: (String, String) throws -> T) rethrows -> [T] {
        var result = [T]()
        for var (first, second) in self {
            result.append(try transform(first.removeFirst(), second.removeFirst()))
        }
        return result
    }
}

// MARK: - Array + AutoResolvableMacro.Property
private extension Array where Element == AutoResolvableMacro.Property {
    
    /// <#Description#>
    /// - Parameter element: <#element description#>
    /// - Returns: <#description#>
    func isLast(_ element: Element) -> Bool {
        last == element
    }
    
    /// <#Description#>
    /// - Parameter element: <#element description#>
    /// - Returns: <#description#>
    func isFirst(_ element: Element) -> Bool {
        first == element
    }
}
