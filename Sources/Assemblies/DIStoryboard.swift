//
//  DIStoryboard.swift
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

#if canImport(UIKit)
import UIKit

/// Протокол получения UIViewController из Storyboard с помощью DI
public protocol DIStoryboard {
    
    /// Настроить замыкание, которое необходимо
    /// выполнять при заверении инициализации UIViewController из Storyboard
    ///
    /// - Parameters:
    ///   - controllerType: Тип UIViewController
    ///   - name: Названине UIViewController
    ///   - initCompleted: Замыкание инициализации
    func setInitCompleted<Controller>(for controllerType: Controller.Type,
                                      name: String?,
                                      initCompleted: @escaping (DIResolver, Controller) -> Void) where Controller: UIViewController
}

// MARK: - DIStoryboard + Additions
public extension DIStoryboard {
    
    /// Настроить замыкание, которое необходимо
    /// выполнять при заверении инициализации UIViewController из Storyboard
    ///
    /// - Parameters:
    ///   - controllerType: Тип UIViewController
    ///   - initCompleted: Замыкание инициализации
    func setInitCompleted<Controller>(for controllerType: Controller.Type,
                                      initCompleted: @escaping (DIResolver, Controller) -> Void) where Controller: UIViewController {
        setInitCompleted(for: controllerType, name: nil, initCompleted: initCompleted)
    }
}
#endif
