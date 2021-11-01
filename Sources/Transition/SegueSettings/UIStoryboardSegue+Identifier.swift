//
//  UIStoryboardSegue+Identifier.swift
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

// MARK: - UIStoryboardSegue + CArch
extension UIStoryboardSegue {

    /// Названине storyboard
    public struct Identifier: RawRepresentable, Hashable {

        public typealias RawValue = String

        public var rawValue: String

        /// Инициализация
        ///
        /// - Parameter rawValue: Названине
        public init?(rawValue: Identifier.RawValue) {
            guard !rawValue.isEmpty else { return nil }
            self.rawValue = rawValue
        }

        /// Инициализация
        ///
        /// - Parameter rawValue: Названине
        public init?(rawValue: Identifier.RawValue?) {
            guard let rawValue = rawValue, !rawValue.isEmpty else { return nil }
            self.rawValue = rawValue
        }

        public func hash(into hasher: inout Hasher) {
            hasher.combine(rawValue)
        }

        public static func == (lhs: Identifier, rhs: Identifier) -> Bool {
            return lhs.rawValue == rhs.rawValue
        }
    }
}
