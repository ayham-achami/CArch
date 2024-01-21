//
//  UIContactorMacroTests.swift
//

import MacroTesting
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

#if canImport(CArchMacros)
import CArchMacros
#endif

final class UIContactorMacroTests: XCTestCase {
    
    // swiftlint:disable closure_body_length function_body_length superfluous_disable_command
    override func invokeTest() {
        #if canImport(CArchMacros)
        withMacroTesting(
            macros: [UIContactorMacro.self],
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
            @UIContactor
            struct SomeStruct {}
            
            @UIContactor
            class SomeClass {}
            
            @UIContactor
            actor SomeActor {}
            """
        } diagnostics: {
            """
            @UIContactor
            ┬───────────
            ╰─ 🛑 UIContactorMacro can be applied to protocols only
            struct SomeStruct {}

            @UIContactor
            ┬───────────
            ╰─ 🛑 UIContactorMacro can be applied to protocols only
            class SomeClass {}

            @UIContactor
            ┬───────────
            ╰─ 🛑 UIContactorMacro can be applied to protocols only
            actor SomeActor {}
            """
        }
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }
    
    func testNonisolated() throws {
        #if canImport(CArchMacros)
        assertMacro {
            """
            @UIContactor
            @MainActor protocol TestUIProtocol: AnyObject {
                func function(_ object: Any)
            }
            """
        } expansion: {
            """
            @MainActor protocol TestUIProtocol: AnyObject {
                func function(_ object: Any)
            }

            extension TestUIProtocol {
                nonisolated func nonisolatedFunction(_ object: Any) {
                    Task { [weak self] in
                        await self?.function(object)
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
