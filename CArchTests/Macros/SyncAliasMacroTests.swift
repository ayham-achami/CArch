//
//  SyncAliasMacroTests.swift
//

import MacroTesting
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

#if canImport(CArchMacros)
import CArchMacros
#endif

final class SyncAliasMacroTests: XCTestCase {

    // swiftlint:disable closure_body_length function_body_length superfluous_disable_command
    override func invokeTest() {
        #if canImport(CArchMacros)
        withMacroTesting(
            macros: [SyncAliasMacro.self],
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
            @SyncAlias
            struct SomeStruct {}
            
            @SyncAlias
            class SomeClass {}
            
            @SyncAlias
            actor SomeActor {}
            """
        } diagnostics: {
            """
            @SyncAlias
            ┬─────────
            ╰─ 🛑 SyncAliasMacro can be applied to protocols only
            struct SomeStruct {}

            @SyncAlias
            ┬─────────
            ╰─ 🛑 SyncAliasMacro can be applied to protocols only
            class SomeClass {}

            @SyncAlias
            ┬─────────
            ╰─ 🛑 SyncAliasMacro can be applied to protocols only
            actor SomeActor {}
            """
        }
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }
    
    func testInheritedErrorAsyncHandler() throws {
        #if canImport(CArchMacros)
        assertMacro {
            """
            @SyncAlias
            protocol TestProtocol {}
            """
        } diagnostics: {
            """
            @SyncAlias
            protocol TestProtocol {}
            ┬───────
            ╰─ 🛑 Macro can be applied to protocols inherited from ErrorAsyncHandler only
               ✏️ add inheritance from ErrorAsyncHandler
            """
        } fixes: {
            """
            @SyncAlias
            protocol TestProtocol : ErrorAsyncHandler {}
            """
        } expansion: {
            """
            protocol TestProtocol : ErrorAsyncHandler {}

            extension TestProtocol {
            }
            """
        }
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }
    
    func testIfHaveSyncOnly() throws {
        #if canImport(CArchMacros)
        assertMacro {
            """
            @SyncAlias
            public protocol TestProtocol: ErrorAsyncHandler {
                func syncFunction(_ object: Any)
            }
            """
        } expansion: {
            """
            public protocol TestProtocol: ErrorAsyncHandler {
                func syncFunction(_ object: Any)
            }

            public extension TestProtocol {
            }
            """
        }
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }
    
    func testSyncFromAsync() throws {
        #if canImport(CArchMacros)
        assertMacro {
            """
            @SyncAlias
            public protocol TestProtocol: ErrorAsyncHandler {
                func asyncFunction(_ object: Any) async
            }
            """
        } expansion: {
            """
            public protocol TestProtocol: ErrorAsyncHandler {
                func asyncFunction(_ object: Any) async
            }

            public extension TestProtocol {
                func asyncFunction(_ object: Any) {
                    Task { [weak self] in
                        await self?.asyncFunction(object)
                    }
                }
            }
            """
        }
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }
    
    func testSyncFromAsyncThrows() throws {
        #if canImport(CArchMacros)
        assertMacro {
            """
            @SyncAlias
            protocol TestProtocol: TestProtocolInc, ErrorAsyncHandler {
                func asyncThrowsFunction(_ object: Any) async throws
            }
            """
        } expansion: {
            """
            protocol TestProtocol: TestProtocolInc, ErrorAsyncHandler {
                func asyncThrowsFunction(_ object: Any) async throws
            }

            extension TestProtocol {
                func asyncThrowsFunction(_ object: Any) {
                    Task { [weak self] in
                        do {
                            try await self?.asyncThrowsFunction(object)
                        } catch {
                            self?.encountered(error)
                        }
                    }
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
