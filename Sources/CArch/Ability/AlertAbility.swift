//
//  AlertAbility.swift
//

#if canImport(UIKit)
import UIKit

/// Протокол способности оповещения
@UIContactor
@MainActor public protocol AlertAbility: CArchProtocol {

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
    nonisolated func nonisolatedDisplayErrorAlert(with message: String) {
        Task {
            await displayAlert(with: NSLocalizedString("Error", comment: "Error"), message)
        }
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
    nonisolated func nonisolatedDisplayErrorAlert(with error: Error) {
        Task {
            await displayAlert(with: NSLocalizedString("Error", comment: "Error"), error.localizedDescription)
        }
    }
}

// MARK: - AlertAbility + UIViewController
extension UIViewController: AlertAbility {

    public func displayAlert(with title: String, _ message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true)
    }

    public func displayAlert(with title: String, _ message: String?, _ actions: [UIAlertAction]) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        actions.forEach { alert.addAction($0) }
        present(alert, animated: true)
    }

    public func displayAlert(with title: String, _ message: String?, _ textFieldHandler: ((UITextField) -> Void)?, _ actions: [UIAlertAction]) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addTextField(configurationHandler: textFieldHandler)
        actions.forEach { alert.addAction($0) }
        present(alert, animated: true)
    }

    public func displayActionSheet(with title: String?, _ message: String?, _ actions: [UIAlertAction]) {
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
