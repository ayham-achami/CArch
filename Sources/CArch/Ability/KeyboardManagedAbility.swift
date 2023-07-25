//
//  KeyboardManagedAbility.swift
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

/// Тип слабая ссылка на объект
public final class ViewBox<View: UIView> {

    /// Объект назначения
    public private(set) weak var view: View?

    /// Инициализация с объектом
    /// - Parameter view: Объект, на которого ссылка будет создано
    public init(_ view: View) {
        self.view = view
    }
}

/// Делегат нажатия на экране, чтобы скрыть клавиатуру
@MainActor public final class HideKeyboardWhenTappedAroundDelegate: NSObject, UIGestureRecognizerDelegate {

    /// Исключенные элементы при нажатии
    private let exceptElements: [ViewBox<UIView>]
    private let exceptTypes: [AnyClass]

    /// Инициализация с исключенными элементам при нажатии
    /// - Parameter exceptElements: Исключенные элементы при нажатии
    fileprivate init(exceptElements: [ViewBox<UIView>], exceptTypes: [AnyClass]) {
        self.exceptElements = exceptElements
        self.exceptTypes = exceptTypes
        super.init()
    }

    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        guard let view = touch.view else { return true }
        let notExceptElement = exceptElements.first(where: { $0.view === view }) == nil
        let notExceptType = exceptTypes.first(where: { view.isKind(of: $0) }) == nil
        return notExceptElement && notExceptType
    }
}

/// Способность управления клавиатурой
@MainActor public protocol KeyboardManagedAbility {

    /// Скрыть клавиатуру при нажатии на экране
    /// - Parameters:
    ///   - exceptElements: Исключенные элементы при нажатии
    ///   - exceptTypes: Исключенные типы при нажатии
    /// - Returns: Делегат нажатия на экране
    func hideKeyboardWhenTappedAround(exceptElements: [ViewBox<UIView>], exceptTypes: [AnyClass]) -> HideKeyboardWhenTappedAroundDelegate
}

// MARK: - KeyboardManagedAbility + UIViewController
extension UIViewController: KeyboardManagedAbility {

    public func hideKeyboardWhenTappedAround(exceptElements: [ViewBox<UIView>] = [], exceptTypes: [AnyClass] = []) -> HideKeyboardWhenTappedAroundDelegate {
        let delegate = HideKeyboardWhenTappedAroundDelegate(exceptElements: exceptElements, exceptTypes: exceptTypes)
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tap.cancelsTouchesInView = false
        tap.delegate = delegate
        view.addGestureRecognizer(tap)
        return delegate
    }
}

// MARK: - UIViewController + hideKeyboard
private extension UIViewController {

    @objc
    func hideKeyboard() {
        view.endEditing(true)
    }
}
#endif
