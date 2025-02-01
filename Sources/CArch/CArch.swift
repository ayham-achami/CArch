//
//  CArch.swift
//

import Foundation
#if canImport(UIKit)
import UIKit
#endif

/// Основной протокол новой архитектурой, все протоколы
/// компонентов архитектурой должны быть унаследованным
/// от этого протокола, основная задача протокола `CArchProtocol`
/// создать метку в коде для того, чтобы различить
/// протоколы архитектурные от других
public protocol CArchProtocol: AnyObject {}

/// Основной протокол, все протоколы компонентов модуля
public protocol CArchModuleComponent: CArchProtocol {}

/// Основной протокол любого объекта UI модели
public protocol UIModel {}
#if canImport(UIKit)
public typealias ViewController = UIViewController
#else
public typealias ViewController = Any
#endif

/// CArch Модуль
public protocol CArchModule: CArchProtocol {

    /// View component
    nonisolated var node: ViewController { get }

    /// Инициализатор модуля
    nonisolated var initializer: AnyModuleInitializer? { get }

    /// Делегат модуля, объекта ожидаемый результат от текущего модуля
    nonisolated var finalizer: AnyModuleFinalizer? { get }
}

#if canImport(UIKit)
// MARK: - UIViewController + CArchModule
extension UIViewController: CArchModule {
    
    public nonisolated var node: ViewController {
        self
    }
    
    public nonisolated var initializer: AnyModuleInitializer? {
        self as? AnyModuleInitializer
    }
    
    public nonisolated var finalizer: AnyModuleFinalizer? {
        self as? AnyModuleFinalizer
    }
}
#endif

/// Конфигурация инъекции
public protocol InjectConfiguration: RawRepresentable, Sendable where RawValue == String {}

/// Конфигурация двигателя
public struct EngineConfiguration: InjectConfiguration {
    
    public let rawValue: String
    
    public init(rawValue: String) {
        self.rawValue = rawValue
    }
}

/// Базовый протокол любого двигателя слоя бизнес логики
/// нельзя создавать двигатель и не наследовать данный протокол
public protocol BusinessLogicEngine: CArchProtocol, CustomStringConvertible, CustomDebugStringConvertible {}

// MARK: - BusinessLogicEngine + StringConvertible
public extension BusinessLogicEngine {
    
    nonisolated var description: String {
        "🧰 \(String(describing: Self.self))"
    }
    
    nonisolated var debugDescription: String {
        description
    }
}

/// Базовый протокол любого агента слоя бизнес логики
/// нельзя создавать агент и не наследовать данный протокол
public protocol BusinessLogicAgent: CArchProtocol, Actor, CustomStringConvertible, CustomDebugStringConvertible {}

// MARK: - BusinessLogicAgent + StringConvertible
public extension BusinessLogicAgent {
    
    nonisolated var description: String {
        "🛠️ \(String(describing: Self.self))"
    }
    
    nonisolated var debugDescription: String {
        description
    }
}

/// Базовый протокол любого сервиса слоя бизнес логики
/// нельзя создавать сервис и не наследовать данный протокол
public protocol BusinessLogicService: CArchProtocol, Actor, CustomStringConvertible, CustomDebugStringConvertible {}

// MARK: - BusinessLogicService + StringConvertible
public extension BusinessLogicService {

    nonisolated var description: String {
        "⚙️ \(String(describing: Self.self))"
    }

    nonisolated var debugDescription: String {
        description
    }
}

/// Базовый протокол любого контроллер слоя бизнес логики
public protocol BusinessLogicController: CArchProtocol, CustomStringConvertible, CustomDebugStringConvertible {}

// MARK: - BusinessLogicController + StringConvertible
public extension BusinessLogicController {

    var description: String {
        "🎛️ \(String(describing: Self.self))"
    }

    var debugDescription: String {
        description
    }
}

/// Протокол множества сервисов
public protocol BusinessLogicServicePool: CArchProtocol, Actor, CustomStringConvertible, CustomDebugStringConvertible {}

// MARK: - BusinessLogicServicePool + StringConvertible
public extension BusinessLogicServicePool {

    nonisolated var description: String {
        "🏭 \(String(describing: Self.self))"
    }

    nonisolated var debugDescription: String {
        description
    }
}

/// Протокол объекта типа ``Singleton``
public protocol BusinessLogicSingleton: CArchProtocol, Actor, CustomStringConvertible, CustomDebugStringConvertible {}

// MARK: - BusinessLogicSingleton + StringConvertible
public extension BusinessLogicSingleton {

    nonisolated var description: String {
        "🎯 \(String(describing: Self.self))"
    }

    nonisolated var debugDescription: String {
        description
    }
}

/// Протокол создания объект из контейнера зависимости
public protocol AutoResolve {
    
    /// Инициализация
    /// - Parameter resolver: Контейнера зависимости
    init(_ resolver: DIResolver)
}

/// Ключи имплементаций
@frozen public struct ImplementationsKeys: RawRepresentable, Hashable, Sendable {
    
    /// Ключ по умолчанию
    public static var `default`: Self = .init(rawValue: "default")
    
    public let rawValue: String
    
    public init(rawValue: String) {
        self.rawValue = rawValue
    }
}

/// Прицеливание имплементации
@frozen public struct ImplementationsAiming: Hashable {
    
    /// Тип объекта
    public let type: String
    
    /// Версия имплементации
    public let version: ImplementationsKeys
    
    /// Инициализация
    /// - Parameters:
    ///   - type: Тип объекта
    ///   - version: Версия имплементации
    public init(type: Any.Type, version: ImplementationsKeys) {
        self.version = version
        self.type = String(describing: type)
    }
}

/// Опции атрибутов метода инициализации
public struct InitAttributesOptions: OptionSet {
    
    /// Публичный
    public static let `public` = Self(rawValue: 1 << 0)
    
    /// Востребованный
    public static let required = Self(rawValue: 1 << 1)
    
    /// Удобный
    public static let convenience = Self(rawValue: 1 << 2)
    
    /// Все
    public static let all = [Self.public, Self.required, Self.convenience]
    
    public let rawValue: Int

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
}

/// Поведение (тип сборки) сборки
public enum AssemblyBehavior {
    
    /// Автоматический
    case auto
    /// Любой тип
    case some
}

/// Опции сборки
public struct AssemblyOptions: OptionSet {
    
    /// Публичный
    public static let `public` = Self(rawValue: 1 << 0)
    
    /// Создать отдельный объект а не использовать расширение
    public static let freestanding = Self(rawValue: 1 << 1)
    
    public let rawValue: Int
    
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
}

/// Макрос, который добавит alias не асинхронной функции всех асинхронных функций
///
///     @SyncAlias
///     protocol TestProtocol: TestProtocolInc, ErrorAsyncHandler {
///
///         func someFunction(_ object: Any) async
///     }
///
///     extension TestProtocol {
///
///         func someFunction(_ object: Any) {
///             Task { [weak self] in
///                 await self?.someFunction(object)
///             }
///         }
///     }
@attached(extension, conformances: ErrorAsyncHandler, names: arbitrary, overloaded)
public macro SyncAlias() = #externalMacro(module: "CArchMacros", type: "SyncAliasMacro")

/// Макрос, который добавит nonisolated alias всех не асинхронных функций
///
///     @UIContactor
///     @MainActor protocol TestUIProtocol: AnyObject {
///
///         func function(_ object: Any)
///     }
///
///     extension TestUIProtocol {
///
///         nonisolated func nonisolatedFunction(_ object: Any) {
///             Task { [weak self] in
///                 await self?.function(object)
///             }
///         }
///     }
@attached(extension, names: arbitrary, overloaded)
public macro UIContactor() = #externalMacro(module: "CArchMacros", type: "UIContactorMacro")

/// Макрос, который добавит код внедрения зависимости
///
///     @Contract(implementations: [
///         .init(type: SomeAgentV2Implementation.self, version: .v2),
///         .init(type: SomeAgentV1Implementation.self, version: .v1),
///         .init(type: SomeAgentImplementation.self, version: .default)
///     ])
///     protocol SomeAgent: BusinessLogicAgent, AutoResolve {}
///
///     enum SomeAgentImplementations: Equatable {
///         case v2
///         case v1
///         case `default`
///     }
///
///     class SomeAgentAssembly: DIAssembly {
///         func assemble(container: DIContainer) {
///             container.recordAgent(SomeAgentV2Implementation.self.self) { resolver in
///                 .init(resolver)
///             }
///             container.recordAgent(SomeAgentV1Implementation.self.self) { resolver in
///                 .init(resolver)
///             }
///             container.recordAgent(SomeAgentImplementation.self.self) { resolver in
///                 .init(resolver)
///             }
///         }
///     }
///
///     final class SomeAgentResolver {
///         private let resolver: DIResolver
///         public init(_ resolver: DIResolver) {
///             self.resolver = resolver
///         }
///         public func unravel(implementation: SomeAgentImplementations = .default) -> SomeAgent {
///             switch implementation {
///                 case .v2:
///                     return resolver.unravelAgent(SomeAgentV2Implementation.self)
///                 case .v1:
///                     return resolver.unravelAgent(SomeAgentV1Implementation.self)
///                 case .default:
///                     return resolver.unravelAgent(SomeAgentImplementation.self)
///             }
///         }
///     }
///
///     extension SomeAgent {
///         static func resolve(from resolver: DIResolver, implementation: SomeAgentImplementations = .default) -> SomeAgent {
///             SomeAgentResolver(resolver).unravel(implementation: implementation)
///         }
///     }
@attached(extension, names: arbitrary, named(resolve))
@attached(peer, conformances: AutoResolve, names: suffixed(Assembly), suffixed(Resolver), suffixed(Implementations))
public macro Contract(implementations: Set<ImplementationsAiming> = [],
                      options: AssemblyOptions = []) = #externalMacro(module: "CArchMacros", type: "ContractMacro")

/// Макрос, который добавит Init метода к Class, Actor и Struct и также генерирует `init(_ resolver: DIResolver)` метод
///
///     @AutoResolvable
///     actor SomeActor: AutoResolve {
///
///         let firstProperty: SomeFirstPropertyType
///         let secondProperty: SomeSecondPropertyType
///
///         init(firstProperty: SomeFirstPropertyType,
///              secondProperty: SomeSecondPropertyType) {
///                 self.firstProperty = firstProperty
///                 self.secondProperty = secondProperty
///         }
///
///         init(_ resolver: any DIResolver) {
///             self.init(firstProperty: SomeFirstPropertyTypeResolver(resolver).unravel(),
///                       secondProperty: SomeSecondPropertyTypeResolver(resolver).unravel())
///         }
///
///         func doSomething() {}
///     }
@attached(member, conformances: AutoResolve, names: named(init))
public macro AutoResolvable(shouldUseResolver: Bool = true,
                            options: InitAttributesOptions = [],
                            implementations: Set<ImplementationsAiming> = []) = #externalMacro(module: "CArchMacros", type: "AutoResolvableMacro")

/// Макрос, который добавит `Assemble` и `Resolver`  Class, Actor, Struct и Protocol
///
///     @Assemblable
///     actor SomeFacade: AutoResolve {
///
///         init() {
///         }
///
///         init(_ resolver: any DIResolver) {
///             self.init()
///         }
///     }
///
///     extension SomeFacade {
///         public enum Implementations: Equatable {
///             case `default`
///         }
///
///         final class Assembly: DIAssembly {
///             func assemble(container: DIContainer) {
///                 container.record(some: SomeFacade.self) { resolver in
///                     .init(resolver)
///                 }
///             }
///         }
///
///         final class Resolver {
///             private let resolver: DIResolver
///             init(_ resolver: DIResolver) {
///                 self.resolver = resolver
///             }
///             func unravel(implementation: Implementations = .default) -> SomeFacade {
///                 switch implementation {
///                 case .default:
///                     return resolver.unravel(some: SomeFacade.self)
///             }
///         }
///     }
@attached(peer, conformances: AutoResolve, names: suffixed(Assembly), suffixed(Resolver))
@attached(extension, conformances: AutoResolve, names: named(Resolver), named(Assembly))
public macro Assemblable(behavior: AssemblyBehavior = .auto,
                         options: AssemblyOptions = []) = #externalMacro(module: "CArchMacros", type: "AssemblableMacro")
