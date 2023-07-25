//
//  RoutingAdvantage.swift
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

/// Тип перехода с преимуществом
public protocol RoutingAdvantageType {}

/// Перехода с преимуществом
@MainActor public protocol RoutingAdvantage: AnyObject {
    
    /// Требуется переход с преимуществом
    /// - Parameter type: Тип
    /// - Returns: Носитель информации о переходе
    func didRequestTransition<T>(with type: T) -> TransitionHolder where T: RoutingAdvantageType
}

/// Представление о контроле перехода
@MainActor public protocol TransitionControllerRepresentable {
    
    /// Протокол контроля перехода между моделями
    var transition: TransitionController { get }
}

// MARK: - TransitionControllerRepresentable + Default
public extension TransitionControllerRepresentable {
    
    var transition: TransitionController {
        guard
            let transition = Mirror(reflecting: self)
                .children
                .compactMap({ $0.value as? TransitionController })
                .first
        else { preconditionFailure("Couldn't to found TransitionController in \(String(describing: type(of: self)))") }
        return transition
    }
}

// MARK: RootRoutingLogic + TransitionControllerRepresentable
public extension RootRoutingLogic where Self: TransitionControllerRepresentable {
    
    /// Выполнение перехода с преимуществом
    /// - Parameters:
    ///   - type: Тип
    ///   - advantage: Перехода с преимуществом
    @MainActor func advantageRoute<T>(with type: T, from advantage: RoutingAdvantage) where T: RoutingAdvantageType {
        let holder = advantage.didRequestTransition(with: type)
        TransitionBuilder
            .with(transition, holder)
            .commit()
        
    }
}
#endif
