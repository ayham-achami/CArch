//
//  UIStoryboard+Name.swift
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

// MARK: - UIStoryboard + CArch
public extension UIStoryboard {

    /// Названине storyboard
    struct Name: RawRepresentable, Hashable {

        public typealias RawValue = String

        public var rawValue: String

        public init?(rawValue: Name.RawValue) {
            guard !rawValue.isEmpty else { return nil }
            self.rawValue = rawValue
        }

        /// Инициализация
        ///
        /// - Parameter rawValue: названине
        fileprivate init(_ rawValue: Name.RawValue) {
            self.rawValue = rawValue
        }

        public func hash(into hasher: inout Hasher) {
            hasher.combine(rawValue)
        }

        public static func == (lhs: Name, rhs: Name) -> Bool {
            return lhs.rawValue == rhs.rawValue
        }
    }

    /// Инициализация с названием
    ///
    /// - Parameter name: названине storyboard
    convenience init(name: UIStoryboard.Name, bundle: Bundle? = nil) {
        self.init(name: name.rawValue, bundle: bundle)
    }

    /// Создает и возвращает UIViewController с указанным названием
    ///
    /// - Parameter name: названине UIViewController
    /// - Returns: `UIViewController` с указанным названием, если не
    ///             какого контроллера не было найден, этот метод выдает исключение
    func instantiateViewController(with name: UIViewController.Name) -> UIViewController {
        return instantiateViewController(withIdentifier: name.rawValue)
    }
}
