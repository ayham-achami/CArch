//
//  UIViewController+Name.swift
//

#if canImport(UIKit)
import UIKit

// MARK: - UIViewController + CArch
public extension UIViewController {

    /// Названине UIViewController
    @available(*, deprecated, message: "This feature has be deprecated and will be removed in future release")
    struct Name: RawRepresentable, Hashable {

        public typealias RawValue = String

        public var rawValue: String

        public init?(rawValue: Name.RawValue) {
            guard !rawValue.isEmpty else { return nil }
            self.rawValue = rawValue
        }

        /// Инициализация с классом UIViewController
        ///
        /// - Parameter class: классом UIViewController
        public init?(class: AnyClass) {
            let rawValue = String(describing: `class`.self)
            guard !rawValue.isEmpty else { return nil }
            self.rawValue = rawValue
        }

        /// Инициализация
        ///
        /// - Parameter rawValue: Названине
        fileprivate init(_ rawValue: Name.RawValue) {
            self.rawValue = rawValue
        }

        public func hash(into hasher: inout Hasher) {
            hasher.combine(rawValue)
        }

        public static func == (lhs: Name, rhs: Name) -> Bool {
            lhs.rawValue == rhs.rawValue
        }
    }
}
#endif
