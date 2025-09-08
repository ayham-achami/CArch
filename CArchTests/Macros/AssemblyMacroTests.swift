//
//  AssemblyMacroTests.swift
//

import MacroTesting
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

#if canImport(CArchMacros)
import CArchMacros
#endif

// swiftlint:disable closure_body_length function_body_length superfluous_disable_command line_length type_body_length file_length
class AssemblyMacroTests: XCTestCase {
    
    override func invokeTest() {
        #if canImport(CArchMacros)
        withMacroTesting(macros: [AssemblableMacro.self]) {
            super.invokeTest()
        }
        #else
        super.invokeTest()
        #endif
    }
    
    func testNoArguments() throws {
        #if canImport(CArchMacros)
        assertMacro {
            """
            @Assemblable
            class SomeObject {
            }
            """
        } expansion: {
            """
            class SomeObject {
            }

            extension SomeObject {
                final class Assembly: DIAssembly {
                    func assemble(container: DIContainer) {
                        container.record(some: SomeObject.self) { resolver in
                            SomeObject(resolver)
                        }
                    }
                }
                final class Resolver {
                    private let resolver: DIResolver
                    init(_ resolver: DIResolver) {
                        self.resolver = resolver
                    }
                    func unravel() -> SomeObject {
                        resolver.unravel(some: SomeObject.self)
                    }
                }
            }
            """
        }
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }
    
    func testBehaviorSome() throws {
        #if canImport(CArchMacros)
        assertMacro {
            """
            @Assemblable(behavior: .some)
            class SomeObject {
            }
            """
        } expansion: {
            """
            class SomeObject {
            }

            extension SomeObject {
                final class Assembly: DIAssembly {
                    func assemble(container: DIContainer) {
                        container.record(some: SomeObject.self) { resolver in
                            SomeObject(resolver)
                        }
                    }
                }
                final class Resolver {
                    private let resolver: DIResolver
                    init(_ resolver: DIResolver) {
                        self.resolver = resolver
                    }
                    func unravel() -> SomeObject {
                        resolver.unravel(some: SomeObject.self)
                    }
                }
            }
            """
        }
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }
    
    func testBehaviorAuto() throws {
        #if canImport(CArchMacros)
        assertMacro {
            """
            @Assemblable(behavior: .auto)
            class SomeObject {
            }
            
            @Assemblable(behavior: .auto)
            class SomeAgent {
            }
            
            @Assemblable(behavior: .auto)
            class SomeService {
            }
            
            @Assemblable(behavior: .auto)
            class SomeController {
            }
            
            @Assemblable(behavior: .auto)
            class SomeSingleton {
            }
            
            @Assemblable(behavior: .auto)
            class SomePool {
            }
            """
        } expansion: {
            """
            class SomeObject {
            }
            class SomeAgent {
            }
            class SomeService {
            }
            class SomeController {
            }
            class SomeSingleton {
            }
            class SomePool {
            }

            extension SomeObject {
                final class Assembly: DIAssembly {
                    func assemble(container: DIContainer) {
                        container.record(some: SomeObject.self) { resolver in
                            SomeObject(resolver)
                        }
                    }
                }
                final class Resolver {
                    private let resolver: DIResolver
                    init(_ resolver: DIResolver) {
                        self.resolver = resolver
                    }
                    func unravel() -> SomeObject {
                        resolver.unravel(some: SomeObject.self)
                    }
                }
            }

            extension SomeAgent {
                final class Assembly: DIAssembly {
                    func assemble(container: DIContainer) {
                        container.recordAgent(SomeAgent.self) { resolver in
                            SomeAgent(resolver)
                        }
                    }
                }
                final class Resolver {
                    private let resolver: DIResolver
                    init(_ resolver: DIResolver) {
                        self.resolver = resolver
                    }
                    func unravel() -> SomeAgent {
                        resolver.unravelAgent(SomeAgent.self)
                    }
                }
            }

            extension SomeService {
                final class Assembly: DIAssembly {
                    func assemble(container: DIContainer) {
                        container.recordService(SomeService.self) { resolver in
                            SomeService(resolver)
                        }
                    }
                }
                final class Resolver {
                    private let resolver: DIResolver
                    init(_ resolver: DIResolver) {
                        self.resolver = resolver
                    }
                    func unravel() -> SomeService {
                        resolver.unravelService(SomeService.self)
                    }
                }
            }

            extension SomeController {
                final class Assembly: DIAssembly {
                    func assemble(container: DIContainer) {
                        container.recordController(SomeController.self) { resolver in
                            SomeController(resolver)
                        }
                    }
                }
                final class Resolver {
                    private let resolver: DIResolver
                    init(_ resolver: DIResolver) {
                        self.resolver = resolver
                    }
                    func unravel() -> SomeController {
                        resolver.unravelController(SomeController.self)
                    }
                }
            }

            extension SomeSingleton {
                final class Assembly: DIAssembly {
                    func assemble(container: DIContainer) {
                        container.recordSingleton(SomeSingleton.self) { resolver in
                            SomeSingleton(resolver)
                        }
                    }
                }
                final class Resolver {
                    private let resolver: DIResolver
                    init(_ resolver: DIResolver) {
                        self.resolver = resolver
                    }
                    func unravel() -> SomeSingleton {
                        resolver.unravelSingleton(SomeSingleton.self)
                    }
                }
            }

            extension SomePool {
                final class Assembly: DIAssembly {
                    func assemble(container: DIContainer) {
                        container.recordPool(SomePool.self) { resolver in
                            SomePool(resolver)
                        }
                    }
                }
                final class Resolver {
                    private let resolver: DIResolver
                    init(_ resolver: DIResolver) {
                        self.resolver = resolver
                    }
                    func unravel() -> SomePool {
                        resolver.unravelPool(SomePool.self)
                    }
                }
            }
            """
        }
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }
    
    func testOptionsFreestanding() throws {
        #if canImport(CArchMacros)
        assertMacro {
            """
            @Assemblable(options: .freestanding)
            class SomeObject {
            }
            
            @Assemblable(options: [.freestanding])
            class SomeObject {
            }
            """
        } expansion: {
            """
            class SomeObject {
            }

            final class SomeObjectAssembly: DIAssembly {
                func assemble(container: DIContainer) {
                    container.record(some: SomeObject.self) { resolver in
                        SomeObject(resolver)
                    }
                }
            }

            final class SomeObjectResolver {
                private let resolver: DIResolver
                init(_ resolver: DIResolver) {
                    self.resolver = resolver
                }
                func unravel() -> SomeObject {
                    resolver.unravel(some: SomeObject.self)
                }
            }
            class SomeObject {
            }

            final class SomeObjectAssembly: DIAssembly {
                func assemble(container: DIContainer) {
                    container.record(some: SomeObject.self) { resolver in
                        SomeObject(resolver)
                    }
                }
            }

            final class SomeObjectResolver {
                private let resolver: DIResolver
                init(_ resolver: DIResolver) {
                    self.resolver = resolver
                }
                func unravel() -> SomeObject {
                    resolver.unravel(some: SomeObject.self)
                }
            }
            """
        }
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }
    
    func testOptionsPublic() throws {
        #if canImport(CArchMacros)
        assertMacro {
            """
            @Assemblable(options: .public)
            class SomeObject {
            }
            
            @Assemblable(options: [.public])
            class SomeObject {
            }
            """
        } expansion: {
            """
            class SomeObject {
            }
            class SomeObject {
            }

            extension SomeObject {
                public final class Assembly: DIAssembly {
                    public func assemble(container: DIContainer) {
                        container.record(some: SomeObject.self) { resolver in
                            SomeObject(resolver)
                        }
                    }
                }
                public final class Resolver {
                    private let resolver: DIResolver
                    public init(_ resolver: DIResolver) {
                        self.resolver = resolver
                    }
                    public func unravel() -> SomeObject {
                        resolver.unravel(some: SomeObject.self)
                    }
                }
            }

            extension SomeObject {
                public final class Assembly: DIAssembly {
                    public func assemble(container: DIContainer) {
                        container.record(some: SomeObject.self) { resolver in
                            SomeObject(resolver)
                        }
                    }
                }
                public final class Resolver {
                    private let resolver: DIResolver
                    public init(_ resolver: DIResolver) {
                        self.resolver = resolver
                    }
                    public func unravel() -> SomeObject {
                        resolver.unravel(some: SomeObject.self)
                    }
                }
            }
            """
        }
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }
    
    func testStruct() throws {
        #if canImport(CArchMacros)
        assertMacro {
            """
            @Assemblable
            struct SomeObject {
            }
            """
        } expansion: {
            """
            struct SomeObject {
            }

            extension SomeObject {
                final class Assembly: DIAssembly {
                    func assemble(container: DIContainer) {
                        container.record(some: SomeObject.self) { resolver in
                            SomeObject(resolver)
                        }
                    }
                }
                final class Resolver {
                    private let resolver: DIResolver
                    init(_ resolver: DIResolver) {
                        self.resolver = resolver
                    }
                    func unravel() -> SomeObject {
                        resolver.unravel(some: SomeObject.self)
                    }
                }
            }
            """
        }
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }
    
    func testActor() throws {
        #if canImport(CArchMacros)
        assertMacro {
            """
            @Assemblable
            actor SomeObject {
            }
            """
        } expansion: {
            """
            actor SomeObject {
            }

            extension SomeObject {
                final class Assembly: DIAssembly {
                    func assemble(container: DIContainer) {
                        container.record(some: SomeObject.self) { resolver in
                            SomeObject(resolver)
                        }
                    }
                }
                final class Resolver {
                    private let resolver: DIResolver
                    init(_ resolver: DIResolver) {
                        self.resolver = resolver
                    }
                    func unravel() -> SomeObject {
                        resolver.unravel(some: SomeObject.self)
                    }
                }
            }
            """
        }
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }
    
    func testProtocol() throws {
        #if canImport(CArchMacros)
        assertMacro {
            """
            @Assemblable
            protocol SomeObject {
            }
            """
        } diagnostics: {
            """
            @Assemblable
            ┬───────────
            ├─ 🛑 Invalid argument Must be a class, actor or struct, object declaration
            ╰─ 🛑 Invalid argument Must be a class, actor or struct, object declaration
            protocol SomeObject {
            }
            """
        }
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }
    
    func testEnum() throws {
        #if canImport(CArchMacros)
        assertMacro {
            """
            @Assemblable
            enum SomeObject {
            }
            """
        } diagnostics: {
            """
            @Assemblable
            ┬───────────
            ├─ 🛑 Invalid argument Must be a class, actor or struct, object declaration
            ╰─ 🛑 Invalid argument Must be a class, actor or struct, object declaration
            enum SomeObject {
            }
            """
        }
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }
}
// swiftlint:enable closure_body_length function_body_length superfluous_disable_command line_length type_body_length file_length
