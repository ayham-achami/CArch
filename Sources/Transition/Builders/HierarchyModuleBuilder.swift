//
//  HierarchyModuleBuilder.swift
//
//  The MIT License (MIT)
//
//  Copyright (c) 2019 Community Arch
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

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
        guard self == hierarchy else { preconditionFailure("Could't to build module with hierarchy: \(hierarchy)") }
    }
}

/// Любая иерархия модуля
@MainActor public protocol AnyHierarchyModuleBuilder {

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
        guard let initialState = initialState as? InitialStateType else {
            preconditionFailure("Could't cast to \(String(describing: InitialStateType.self))")
        }
        return build(with: initialState)
    }
}

/// Чистая иерархия модуля простой VC
@MainActor public protocol ClearHierarchyModuleBuilder: AnyHierarchyModuleBuilder, ModuleBuilder {}

// MARK: - ClearHierarchyModuleBuilder + Default
public extension ClearHierarchyModuleBuilder {

    func build(with initialState: ModuleInitialState?, into hierarchy: Hierarchy) -> CArchModule {
        hierarchy.assert(is: .clear)
        return initialState == nil ? build() : build(with: initialState!)
    }
}

/// VC в NavigationController
@MainActor public protocol NavigationHierarchyModuleBuilder: AnyHierarchyModuleBuilder, ModuleBuilder {}

// MARK: - NavigationHierarchyModuleBuilder + Default
public extension NavigationHierarchyModuleBuilder {

    func build(with initialState: ModuleInitialState?, into hierarchy: Hierarchy) -> CArchModule {
        hierarchy.assert(is: .navigation)
        return initialState == nil ? build() : build(with: initialState!)
    }
}

/// VC Мастер SplitViewController
@MainActor public protocol MasterHierarchyModuleBuilder: AnyHierarchyModuleBuilder, ModuleBuilder {}

// MARK: - MasterHierarchyModuleBuilder + Default
public extension MasterHierarchyModuleBuilder {

    func build(with initialState: ModuleInitialState?, into hierarchy: Hierarchy) -> CArchModule {
        hierarchy.assert(is: .master)
        return initialState == nil ? build() : build(with: initialState!)
    }
}

/// VC Детали SplitViewController
@MainActor public protocol DetailsHierarchyModuleBuilder: AnyHierarchyModuleBuilder, ModuleBuilder {}

// MARK: - DetailsHierarchyModuleBuilder + Default
public extension DetailsHierarchyModuleBuilder {

    func build(with initialState: ModuleInitialState?, into hierarchy: Hierarchy) -> CArchModule {
        hierarchy.assert(is: .details)
        return initialState == nil ? build() : build(with: initialState!)
    }
}

/// VC c TabItem
@MainActor public protocol TabHierarchyModuleBuilder: AnyHierarchyModuleBuilder, ModuleBuilder {}

// MARK: - TabHierarchyModuleBuilder + Default
public extension TabHierarchyModuleBuilder {

    func build(with initialState: ModuleInitialState?, into hierarchy: Hierarchy) -> CArchModule {
        hierarchy.assert(is: .tab)
        return initialState == nil ? build() : build(with: initialState!)
    }
}
