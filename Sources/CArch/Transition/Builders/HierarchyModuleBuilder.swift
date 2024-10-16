//
//  HierarchyModuleBuilder.swift
//

import Foundation

/// Типы иерархии модуля
public enum Hierarchy {

    /// - clear: Протос VC
    case clear
    /// - navigation: VC в NavigationController
    case navigation
    /// - master: VC мастер SplitViewController
    case master
    /// - details: VC детали SplitViewController
    case details
    /// - tab: VC c TabItem
    case tab
}

// MARK: - Hierarchy + Assert
extension Hierarchy {

    func assert(is hierarchy: Hierarchy) {
        guard
            self == hierarchy
        else { preconditionFailure("Could't to build module with hierarchy: \(hierarchy)") }
    }
}

/// Любая иерархия модуля
public protocol AnyHierarchyModuleBuilder: Sendable {

    /// Создает и возвращает новый модуль передавая ему данные
    /// инициализации, с нужной иерархия исходя из объекта `Hierarchy`
    /// - Parameters:
    ///   - initialState: Данные инициализации
    ///   - anarchy: Типы иерархии модуля
    /// - Returns: Модуль CArch
    func build(with initialState: ModuleInitialState?, into hierarchy: Hierarchy) -> CArchModule
}

// MARK: - AnyHierarchyModuleBuilder + ModuleBuilder + Реализация по умолчанию
public extension AnyHierarchyModuleBuilder where Self: ModuleBuilder {

    func build(with initialState: ModuleInitialState) -> CArchModule {
        guard
            let initialState = initialState as? InitialStateType
        else { preconditionFailure("Could't cast to \(String(describing: InitialStateType.self))") }
        return build(with: initialState)
    }
}

/// Чистая иерархия модуля простой VC
public protocol ClearHierarchyModuleBuilder: AnyHierarchyModuleBuilder, ModuleBuilder {}

// MARK: - ClearHierarchyModuleBuilder + Default
public extension ClearHierarchyModuleBuilder {

    func build(with initialState: ModuleInitialState?, into hierarchy: Hierarchy) -> CArchModule {
        hierarchy.assert(is: .clear)
        return initialState == nil ? build() : build(with: initialState!)
    }
}

/// VC в NavigationController
public protocol NavigationHierarchyModuleBuilder: AnyHierarchyModuleBuilder, ModuleBuilder {}

// MARK: - NavigationHierarchyModuleBuilder + Default
public extension NavigationHierarchyModuleBuilder {

    func build(with initialState: ModuleInitialState?, into hierarchy: Hierarchy) -> CArchModule {
        hierarchy.assert(is: .navigation)
        return initialState == nil ? build() : build(with: initialState!)
    }
}

/// VC Мастер SplitViewController
public protocol MasterHierarchyModuleBuilder: AnyHierarchyModuleBuilder, ModuleBuilder {}

// MARK: - MasterHierarchyModuleBuilder + Default
public extension MasterHierarchyModuleBuilder {

    func build(with initialState: ModuleInitialState?, into hierarchy: Hierarchy) -> CArchModule {
        hierarchy.assert(is: .master)
        return initialState == nil ? build() : build(with: initialState!)
    }
}

/// VC Детали SplitViewController
public protocol DetailsHierarchyModuleBuilder: AnyHierarchyModuleBuilder, ModuleBuilder {}

// MARK: - DetailsHierarchyModuleBuilder + Default
public extension DetailsHierarchyModuleBuilder {

    func build(with initialState: ModuleInitialState?, into hierarchy: Hierarchy) -> CArchModule {
        hierarchy.assert(is: .details)
        return initialState == nil ? build() : build(with: initialState!)
    }
}

/// VC c TabItem
public protocol TabHierarchyModuleBuilder: AnyHierarchyModuleBuilder, ModuleBuilder {}

// MARK: - TabHierarchyModuleBuilder + Default
public extension TabHierarchyModuleBuilder {

    func build(with initialState: ModuleInitialState?, into hierarchy: Hierarchy) -> CArchModule {
        hierarchy.assert(is: .tab)
        return initialState == nil ? build() : build(with: initialState!)
    }
}
