//
//  AlertAbility.swift
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

/// Протокол способности оповещения
public protocol AlertAbility: CArchProtocol {

    /// Показать диалог оповещения с одной кнопкой
    /// ```
    /// +----------------------+
    /// |        Title         |
    /// |   Message from app   |
    /// +----------------------+
    /// |          OK          |
    /// +----------------------+
    /// ```
    /// - Parameters:
    ///   - title: Заголовок диалога
    ///   - message: Сообщение пользователя
    func displayAlert(with title: String, _ message: String?)

    /// Показать диалог оповещения с более одной кнопкой
    /// ```
    /// +-----------------------+
    /// |        Title          |
    /// |   Message from app    |
    /// +-----------------------+
    /// | Action 1  |  Action 2 |
    /// +-----------------------+
    /// ```
    /// - Parameters:
    ///   - title: Заголовок диалога
    ///   - message: Сообщение пользователя
    ///   - actions: Список действий
    func displayAlert(with title: String, _ message: String?, _ actions: [UIAlertAction])

    /// Показать диалог оповещения с более одной кнопкой с поле вода текста
    /// ```
    /// +-----------------------+
    /// |        Title          |
    /// |   Message from app    |
    /// |                       |
    /// |  ┇-----------------┇  |
    /// +-----------------------+
    /// | Action 1  |  Action 2 |
    /// +-----------------------+
    /// ```
    /// - Parameters:
    ///   - title: Заголовок диалога
    ///   - message: Сообщение пользователя
    ///   - textFieldHandler: Замыкание для настройки текстового поля перед отображением предупреждения.
    ///   - actions: Список действий
    func displayAlert(with title: String,
                      _ message: String?,
                      _ textFieldHandler: ((UITextField) -> Void)?,
                      _ actions: [UIAlertAction])

    /// Показать оповещения в виде bottom sheet
    ///
    /// ```
    /// +-----------------------+
    /// |        Title          |
    /// |   Message from app    |
    /// +-----------------------+
    /// |       Action 1        |
    /// +-----------------------+
    /// +-----------------------+
    /// |       Action 2        |
    /// +-----------------------+
    /// +-----------------------+
    /// |       Action 3        |
    /// +-----------------------+
    /// ```
    /// - Parameters:
    ///   - title: Заголовок диалога
    ///   - message: Сообщение пользователя
    ///   - actions: Список действий
    func displayActionSheet(with title: String?,
                            _ message: String?,
                            _ actions: [UIAlertAction])
}

public extension AlertAbility {

    /// Показать диалог ошибки
    /// ```
    /// +----------------------+
    /// |        Error         |
    /// |   Some error has     |
    /// |   happened check     |
    /// |   your settings      |
    /// +----------------------+
    /// |          OK          |
    /// +----------------------+
    /// ```
    /// - Parameter message: Случающая ошибка
    func displayErrorAlert(with message: String) {
        displayAlert(with: NSLocalizedString("Error", comment: "Error"), message)
    }

    /// показать диалог ошибки
    /// ```
    /// +----------------------+
    /// |        Error         |
    /// |   Some error has     |
    /// |   happened check     |
    /// |   your settings      |
    /// +----------------------+
    /// |          OK          |
    /// +----------------------+
    /// ```
    /// - Parameter error: Случающая ошибка
    func displayErrorAlert(with error: Error) {
        displayAlert(with: NSLocalizedString("Error", comment: "Error"), error.localizedDescription)
    }
}

// MARK: - AlertAbility + UIViewController
public extension AlertAbility where Self: UIViewController {

    func displayAlert(with title: String, _ message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true)
    }

    func displayAlert(with title: String, _ message: String?, _ actions: [UIAlertAction]) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        actions.forEach { alert.addAction($0) }
        present(alert, animated: true)
    }

    func displayAlert(with title: String, _ message: String?, _ textFieldHandler: ((UITextField) -> Void)?, _ actions: [UIAlertAction]) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addTextField(configurationHandler: textFieldHandler)
        actions.forEach { alert.addAction($0) }
        present(alert, animated: true)
    }

    func displayActionSheet(with title: String?, _ message: String?, _ actions: [UIAlertAction]) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        actions.forEach { alert.addAction($0) }
        if let popoverController = alert.popoverPresentationController {
            popoverController.sourceView = view
            popoverController.sourceRect = CGRect(x: view.bounds.midX, y: view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        present(alert, animated: true)
    }
}
#endif
