//
//  ContractMacroTests.swift
//

import MacroTesting
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

#if canImport(CArchMacros)
import CArchMacros
#endif

class ContractMacroTests: XCTestCase {

    // swiftlint:disable closure_body_length function_body_length superfluous_disable_command
    override func invokeTest() {
        #if canImport(CArchMacros)
        withMacroTesting(
            macros: [ContractMacro.self],
            operation: {
                super.invokeTest()
            }
        )
        #else
        super.invokeTest()
        #endif
    }
    
    func testIsProtocolDeclSyntax() throws {
        #if canImport(CArchMacros)
        assertMacro {
            """
            @Contract
            struct SomeStruct {}
            
            @Contract
            class SomeClass {}
            
            @Contract
            actor SomeActor {}
            """
        } diagnostics: {
            """
            @Contract
            ┬────────
            ├─ 🛑 ContractMacro can be applied to protocols only
            ╰─ 🛑 ContractMacro can be applied to protocols only
            struct SomeStruct {}

            @Contract
            ┬────────
            ├─ 🛑 ContractMacro can be applied to protocols only
            ╰─ 🛑 ContractMacro can be applied to protocols only
            class SomeClass {}

            @Contract
            ┬────────
            ├─ 🛑 ContractMacro can be applied to protocols only
            ╰─ 🛑 ContractMacro can be applied to protocols only
            actor SomeActor {}
            """
        }
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }
    
    func testInheritedCArchComponent() throws {
        #if canImport(CArchMacros)
        assertMacro {
            """
            @Contract
            protocol SomeRootAgent: AutoResolve {}
            """
        } diagnostics: {
            """
            @Contract
            ┬────────
            ├─ 🛑 Contract protocol must inherited from some CArch component protocol
            ╰─ 🛑 Contract protocol must inherited from some CArch component protocol
            protocol SomeRootAgent: AutoResolve {}
            """
        }
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }
    
    func testInheritedFromAutoResolve() throws {
        #if canImport(CArchMacros)
        assertMacro {
            """
            @Contract
            protocol SomeRootAgent: BusinessLogicAgent {}
            """
        } diagnostics: {
            """
            @Contract
            protocol SomeRootAgent: BusinessLogicAgent {}
            ┬───────
            ╰─ 🛑 Macro can be applied to protocols inherited from AutoResolve only
               ✏️ add inheritance from AutoResolve
            """
        } fixes: {
            """
            @Contract
            protocol SomeRootAgent: BusinessLogicAgent, AutoResolve {}
            """
        } expansion: {
            """
            protocol SomeRootAgent: BusinessLogicAgent, AutoResolve {}

            enum SomeRootAgentImplementations: Equatable {
                case `default`
            }

            final class SomeRootAgentAssembly: DIAssembly {
                func assemble(container: DIContainer) {
                    container.recordAgent(SomeRootAgentImplementation.self) { resolver in
                        .init(resolver)
                    }
                }
            }

            final class SomeRootAgentResolver {
                private let resolver: DIResolver
                init(_ resolver: DIResolver) {
                    self.resolver = resolver
                }
                func unravel(implementation: SomeRootAgentImplementations = .default) -> SomeRootAgent {
                    switch implementation {
                    case .default:
                        return resolver.unravelAgent(SomeRootAgentImplementation.self)
                    }
                }
            }

            extension SomeRootAgent {
                static func resolve(from resolver: DIResolver, implementation: SomeRootAgentImplementations = .default) -> SomeRootAgent {
                    SomeRootAgentResolver(resolver).unravel(implementation: implementation)
                }
            }
            """
        }
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }
    
    func testImplementations() throws {
        #if canImport(CArchMacros)
        assertMacro {
            """
            @Contract(implementations: [
                .v2: SomeAgentV2Implementation.self,
                .v1: SomeAgentV1Implementation.self,
                .default: SomeAgentImplementation.self
            ])
            public protocol SomeAgent: BusinessLogicAgent, AutoResolve {}
            """
        } expansion: {
            """
            public protocol SomeAgent: BusinessLogicAgent, AutoResolve {}

            public enum SomeAgentImplementations: Equatable {
                case v2
                case v1
                case `default`
            }

            final class SomeAgentAssembly: DIAssembly {
                func assemble(container: DIContainer) {
                    container.recordAgent(SomeAgentV2Implementation.self.self) { resolver in
                        .init(resolver)
                    }
                    container.recordAgent(SomeAgentV1Implementation.self.self) { resolver in
                        .init(resolver)
                    }
                    container.recordAgent(SomeAgentImplementation.self.self) { resolver in
                        .init(resolver)
                    }
                }
            }

            public final class SomeAgentResolver {
                private let resolver: DIResolver
                public init(_ resolver: DIResolver) {
                    self.resolver = resolver
                }
                public func unravel(implementation: SomeAgentImplementations = .default) -> SomeAgent {
                    switch implementation {
                    case .v2:
                        return resolver.unravelAgent(SomeAgentV2Implementation.self)
                    case .v1:
                        return resolver.unravelAgent(SomeAgentV1Implementation.self)
                    case .default:
                        return resolver.unravelAgent(SomeAgentImplementation.self)
                    }
                }
            }

            public extension SomeAgent {
                static func resolve(from resolver: DIResolver, implementation: SomeAgentImplementations = .default) -> SomeAgent {
                    SomeAgentResolver(resolver).unravel(implementation: implementation)
                }
            }
            """
        }
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }
    
    func testIsPublicAssembly() throws {
        #if canImport(CArchMacros)
        assertMacro {
            """
            @Contract(isPublicAssembly: true)
            public protocol SomePool: BusinessLogicServicePool, AutoResolve {}
            """
        } expansion: {
            """
            public protocol SomePool: BusinessLogicServicePool, AutoResolve {}

            public enum SomePoolImplementations: Equatable {
                case `default`
            }

            public final class SomePoolAssembly: DIAssembly {
                public func assemble(container: DIContainer) {
                    container.recordPool(SomePoolImplementation.self) { resolver in
                        .init(resolver)
                    }
                }
            }

            public final class SomePoolResolver {
                private let resolver: DIResolver
                public init(_ resolver: DIResolver) {
                    self.resolver = resolver
                }
                public func unravel(implementation: SomePoolImplementations = .default) -> SomePool {
                    switch implementation {
                    case .default:
                        return resolver.unravelPool(SomePoolImplementation.self)
                    }
                }
            }

            public extension SomePool {
                static func resolve(from resolver: DIResolver, implementation: SomePoolImplementations = .default) -> SomePool {
                    SomePoolResolver(resolver).unravel(implementation: implementation)
                }
            }
            """
        }
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }
    
    func testEmptyArguments() throws {
        #if canImport(CArchMacros)
        assertMacro {
            """
            @Contract
            protocol SomeAgent: BusinessLogicAgent, AutoResolve {}
            """
        } expansion: {
            """
            protocol SomeAgent: BusinessLogicAgent, AutoResolve {}

            enum SomeAgentImplementations: Equatable {
                case `default`
            }

            final class SomeAgentAssembly: DIAssembly {
                func assemble(container: DIContainer) {
                    container.recordAgent(SomeAgentImplementation.self) { resolver in
                        .init(resolver)
                    }
                }
            }

            final class SomeAgentResolver {
                private let resolver: DIResolver
                init(_ resolver: DIResolver) {
                    self.resolver = resolver
                }
                func unravel(implementation: SomeAgentImplementations = .default) -> SomeAgent {
                    switch implementation {
                    case .default:
                        return resolver.unravelAgent(SomeAgentImplementation.self)
                    }
                }
            }

            extension SomeAgent {
                static func resolve(from resolver: DIResolver, implementation: SomeAgentImplementations = .default) -> SomeAgent {
                    SomeAgentResolver(resolver).unravel(implementation: implementation)
                }
            }
            """
        }
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }
    // swiftlint:enable closure_body_length function_body_length superfluous_disable_command
}
