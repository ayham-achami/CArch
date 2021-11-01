//
//  SplitTransitionControllerDelegate.swift
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

import UIKit

/// Протокол обозначения PrimaryViewController в SplitViewController
public protocol PrimaryViewController: CArchProtocol {

    /// Получить дефолтный контроллер, при разделении экрана.
    ///
    /// - Returns: module convertator
    func splitViewControllerSeparateFor(_ splitViewController: UISplitViewController) -> ModuleStoryboardConvertor.Type
}

/// Реализация делегата работы со SplitViewController
public final class SplitTransitionControllerDelegate: NSObject, UISplitViewControllerDelegate {

    public let isTransitionBuilder: Bool

    public init(isTransitionBuilder: Bool) {
        self.isTransitionBuilder = isTransitionBuilder
    }

    public func splitViewController(_ splitViewController: UISplitViewController,
                                    collapseSecondary secondaryViewController: UIViewController,
                                    onto primaryViewController: UIViewController) -> Bool {
        return true
    }

    public func splitViewController(_ splitViewController: UISplitViewController,
                                    showDetail vc: UIViewController,
                                    sender: Any?) -> Bool {
        guard !isTransitionBuilder else { return false }
        guard let sender = sender else { return false }
        guard let configurator = sender as? TransitionConfigurator else {
            preconditionFailure("Error: \(TransitionPrepareError(case: .invalidConfigurator))")
        }
        if let initializer = vc as? AnyModuleInitializer {
            configurator.configurator(initializer)
        } else if let nc = vc as? UINavigationController,
            let initializer = nc.viewControllers.first as? AnyModuleInitializer {
            configurator.configurator(initializer)
        } else {
            preconditionFailure("Error: \(TransitionPrepareError(case: .invalidInitializer))")
        }
        return false
    }

    public func splitViewController(_ splitViewController: UISplitViewController, separateSecondaryFrom primaryViewController: UIViewController) -> UIViewController? {
        if let primaryViewController = (primaryViewController as? UINavigationController)?.topViewController as? PrimaryViewController {
            return primaryViewController.splitViewControllerSeparateFor(splitViewController).viewController()
        } else if let primaryViewController = primaryViewController as? PrimaryViewController {
            return primaryViewController.splitViewControllerSeparateFor(splitViewController).viewController()
        } else {
            return nil
        }
    }
}
