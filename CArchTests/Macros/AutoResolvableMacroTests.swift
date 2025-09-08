//
//  AutoResolvableMacroTests.swift
//

import MacroTesting
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

#if canImport(CArchMacros)
import CArchMacros
#endif

// swiftlint:disable closure_body_length function_body_length superfluous_disable_command line_length type_body_length file_length
class AutoResolvableMacroTests: XCTestCase {
    
    override func invokeTest() {
        #if canImport(CArchMacros)
        withMacroTesting(macros: [AutoResolvableMacro.self]) {
            super.invokeTest()
        }
        #else
        super.invokeTest()
        #endif
    }
    
    func testIsSwiftObjectDeclSyntax() throws {
        #if canImport(CArchMacros)
        assertMacro {
            """
            @AutoResolvable
            enum SomeEnum {}

            @AutoResolvable
            protocol SomeProtocol {}
            """
        } diagnostics: {
            """
            @AutoResolvable
            ┬──────────────
            ╰─ 🛑 AutoResolvableMacro can be applied to Structure, Class or Actors only
            enum SomeEnum {}

            @AutoResolvable
            ┬──────────────
            ╰─ 🛑 AutoResolvableMacro can be applied to Structure, Class or Actors only
            protocol SomeProtocol {}
            """
        }
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }
    
    func testInitializerConvenienceStructDeclSyntax() throws {
        #if canImport(CArchMacros)
        assertMacro {
            """
            @AutoResolvable(shouldUseResolver: true, options: [.public, .convenience])
            struct SomeStruct {
            
                let int: Int
            }
            """
        } diagnostics: {
            """
            @AutoResolvable(shouldUseResolver: true, options: [.public, .convenience])
            ┬─────────────────────────────────────────────────────────────────────────
            ╰─ 🛑 Initializers in structs are not marked with 'convenience'
            struct SomeStruct {

                let int: Int
            }
            """
        }
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }
    
    func testInitializerRequiredStructDeclSyntax() throws {
        #if canImport(CArchMacros)
        assertMacro {
            """
            @AutoResolvable(shouldUseResolver: true, options: [.public, .required])
            struct SomeStruct {
            
                let int: Int
            }
            """
        } diagnostics: {
            """
            @AutoResolvable(shouldUseResolver: true, options: [.public, .required])
            ┬──────────────────────────────────────────────────────────────────────
            ╰─ 🛑 'required' initializer in non-class type
            struct SomeStruct {

                let int: Int
            }
            """
        }
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }
    
    func testInitializerConvenienceActorDeclSyntax() throws {
        #if canImport(CArchMacros)
        assertMacro {
            """
            @AutoResolvable(shouldUseResolver: true, options: [.public, .convenience])
            actor SomeStruct {
            
                let int: Int
            }
            """
        } diagnostics: {
            """
            @AutoResolvable(shouldUseResolver: true, options: [.public, .convenience])
            ┬─────────────────────────────────────────────────────────────────────────
            ╰─ 🛑 Initializers in actor are not marked with 'convenience'
            actor SomeStruct {

                let int: Int
            }
            """
        }
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }
    
    func testInitializerRequiredActorDeclSyntax() throws {
        #if canImport(CArchMacros)
        assertMacro {
            """
            @AutoResolvable(shouldUseResolver: true, options: [.public, .required])
            actor SomeStruct {
            
                let int: Int
            }
            """
        } diagnostics: {
            """
            @AutoResolvable(shouldUseResolver: true, options: [.public, .required])
            ┬──────────────────────────────────────────────────────────────────────
            ╰─ 🛑 'required' initializer in non-class type
            actor SomeStruct {

                let int: Int
            }
            """
        }
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }
    
    func testInitializerEmptyObjectDeclSyntax() throws {
        #if canImport(CArchMacros)
        assertMacro {
            """
            @AutoResolvable(shouldUseResolver: true, options: [.public])
            struct SomeStruct {
            }
            
            @AutoResolvable(shouldUseResolver: true, options: [.public, .required, .convenience])
            class SomeClass {
            }
            
            @AutoResolvable(shouldUseResolver: true, options: [.public])
            actor SomeActor {
            }
            """
        } expansion: {
            """
            struct SomeStruct {

                public init() {
                }

                public init(_ resolver: DIResolver) {
                    self.init()
                }
            }
            class SomeClass {

                public init() {
                }

                public required convenience init(_ resolver: DIResolver) {
                    self.init()
                }
            }
            actor SomeActor {

                public init() {
                }

                public init(_ resolver: DIResolver) {
                    self.init()
                }
            }
            """
        }
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }
    
    func testInitializerEmptyArgumentsDeclSyntax() throws {
        #if canImport(CArchMacros)
        assertMacro {
            """
            @AutoResolvable
            struct SomeStruct {
            
                let object: Object
            }
            
            @AutoResolvable
            class SomeClass {
            
                let object: Object
            }
            
            @AutoResolvable
            actor SomeActor {
            
                let object: Object
            }
            """
        } expansion: {
            """
            struct SomeStruct {

                let object: Object

                init(object: Object) {
                    self.object = object
                }

                init(_ resolver: DIResolver) {
                    self.init(object: ObjectResolver(resolver).unravel())
                }
            }
            class SomeClass {

                let object: Object

                init(object: Object) {
                    self.object = object
                }

                required convenience init(_ resolver: DIResolver) {
                    self.init(object: ObjectResolver(resolver).unravel())
                }
            }
            actor SomeActor {

                let object: Object

                init(object: Object) {
                    self.object = object
                }

                init(_ resolver: DIResolver) {
                    self.init(object: ObjectResolver(resolver).unravel())
                }
            }
            """
        }
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }
    
    func testInitializerClassResolverDecl() throws {
        #if canImport(CArchMacros)
        assertMacro {
            """
            @AutoResolvable
            struct SomeStruct {

                let object: Object

                init(object: Object) {
                    self.object = object
                }

                init(_ resolver: DIResolver) {
                    self.init(object: ObjectResolver(resolver).unravel())
                }
            }
            
            @AutoResolvable
            class SomeClass {

                let object: Object

                init(object: Object) {
                    self.object = object
                }

                required convenience init(_ resolver: DIResolver) {
                    self.init(object: ObjectResolver(resolver).unravel())
                }
            }
            
            @AutoResolvable
            actor SomeActor {

                let object: Object

                init(object: Object) {
                    self.object = object
                }

                init(_ resolver: DIResolver) {
                    self.init(object: ObjectResolver(resolver).unravel())
                }
            }
            """
        } diagnostics: {
            """
            @AutoResolvable
            ╰─ 🛑 AutoResolvableMacro can be applied to object don't have initializer only
               ✏️ Remove initializer
            struct SomeStruct {

                let object: Object

                init(object: Object) {
                    self.object = object
                }

                init(_ resolver: DIResolver) {
                    self.init(object: ObjectResolver(resolver).unravel())
                }
            }

            @AutoResolvable
            ╰─ 🛑 AutoResolvableMacro can be applied to object don't have initializer only
               ✏️ Remove initializer
            class SomeClass {

                let object: Object

                init(object: Object) {
                    self.object = object
                }

                required convenience init(_ resolver: DIResolver) {
                    self.init(object: ObjectResolver(resolver).unravel())
                }
            }

            @AutoResolvable
            ╰─ 🛑 AutoResolvableMacro can be applied to object don't have initializer only
               ✏️ Remove initializer
            actor SomeActor {

                let object: Object

                init(object: Object) {
                    self.object = object
                }

                init(_ resolver: DIResolver) {
                    self.init(object: ObjectResolver(resolver).unravel())
                }
            }
            """
        } fixes: {
            """
            @AutoResolvable
            struct SomeStruct {

                let object: Object
            }

            @AutoResolvable
            class SomeClass {

                let object: Object
            }

            @AutoResolvable
            actor SomeActor {

                let object: Object
            }
            """
        } expansion: {
            """
            struct SomeStruct {

                let object: Object

                init(object: Object) {
                    self.object = object
                }

                init(_ resolver: DIResolver) {
                    self.init(object: ObjectResolver(resolver).unravel())
                }
            }
            class SomeClass {

                let object: Object

                init(object: Object) {
                    self.object = object
                }

                required convenience init(_ resolver: DIResolver) {
                    self.init(object: ObjectResolver(resolver).unravel())
                }
            }
            actor SomeActor {

                let object: Object

                init(object: Object) {
                    self.object = object
                }

                init(_ resolver: DIResolver) {
                    self.init(object: ObjectResolver(resolver).unravel())
                }
            }
            """
        }
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }
    
    func testInitializerClassResolverDeclSyntax() throws {
        #if canImport(CArchMacros)
        assertMacro {
            """
            @AutoResolvable(shouldUseResolver: true, options: [.public, .required, .convenience])
            class SomeClass {
            
                static let int: Int = .zero
                static let int1: Int = .zero
                
                let object: Object
                let object1: Object1
                let object2: Object2
                let object3: Object3
            }
            """
        } diagnostics: {
            """
            """
        } expansion: {
            """
            class SomeClass {

                static let int: Int = .zero
                static let int1: Int = .zero
                
                let object: Object
                let object1: Object1
                let object2: Object2
                let object3: Object3

                public init(object: Object,
                			object1: Object1,
                			object2: Object2,
                			object3: Object3) {
                    self.object = object
                    self.object1 = object1
                    self.object2 = object2
                    self.object3 = object3
                }

                public required convenience init(_ resolver: DIResolver) {
                    self.init(object: ObjectResolver(resolver).unravel(),
                    		  object1: Object1Resolver(resolver).unravel(),
                    		  object2: Object2Resolver(resolver).unravel(),
                    		  object3: Object3Resolver(resolver).unravel())
                }
            }
            """
        }
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }
    
    func testInitializerClassNoResolverDeclSyntax() throws {
        #if canImport(CArchMacros)
        assertMacro {
            """
            @AutoResolvable(shouldUseResolver: false, options: [.public, .required, .convenience])
            class SomeClass {
            
                static let int: Int = .zero
                static let int1: Int = .zero
                
                let object: Object
                let object1: Object1
                let object2: Object2
                let object3: Object3
            }
            """
        } expansion: {
            """
            class SomeClass {

                static let int: Int = .zero
                static let int1: Int = .zero
                
                let object: Object
                let object1: Object1
                let object2: Object2
                let object3: Object3

                public init(object: Object,
                			object1: Object1,
                			object2: Object2,
                			object3: Object3) {
                    self.object = object
                    self.object1 = object1
                    self.object2 = object2
                    self.object3 = object3
                }

                public required convenience init(_ resolver: DIResolver) {
                    self.init(object: resolver.unravel(some: Object.self),
                    		  object1: resolver.unravel(some: Object1.self),
                    		  object2: resolver.unravel(some: Object2.self),
                    		  object3: resolver.unravel(some: Object3.self))
                }
            }
            """
        }
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }
    
    func testInitializerClassResolverImplementationsDeclSyntax() throws {
        #if canImport(CArchMacros)
        assertMacro {
            """
            @AutoResolvable(shouldUseResolver: true, options: [.public, .required, .convenience], implementations: [.init(type: Object1.self, version: .v1), .init(type: Object.self, version: .v2)])
            class SomeClass {
            
                static let int: Int = .zero
                static let int1: Int = .zero
                
                let object: Object
                let object1: Object1
                let object2: Object2
                let object3: Object3
            }
            """
        } diagnostics: {
            """
            """
        } expansion: {
            """
            class SomeClass {

                static let int: Int = .zero
                static let int1: Int = .zero
                
                let object: Object
                let object1: Object1
                let object2: Object2
                let object3: Object3

                public init(object: Object,
                			object1: Object1,
                			object2: Object2,
                			object3: Object3) {
                    self.object = object
                    self.object1 = object1
                    self.object2 = object2
                    self.object3 = object3
                }

                public required convenience init(_ resolver: DIResolver) {
                    self.init(object: ObjectResolver(resolver).unravel(implementation: .v2),
                    		  object1: Object1Resolver(resolver).unravel(implementation: .v1),
                    		  object2: Object2Resolver(resolver).unravel(),
                    		  object3: Object3Resolver(resolver).unravel())
                }
            }
            """
        }
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }
}
// swiftlint:enable closure_body_length function_body_length superfluous_disable_command line_length type_body_length file_length
