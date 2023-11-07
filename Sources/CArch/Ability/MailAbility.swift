//
//  MailAbility.swift
//

#if canImport(UIKit) && canImport(MessageUI)
import MessageUI
import UIKit

/// Возможность показать экран отправление E-Mail
@MainActor public protocol MailAbility {

    /// Показать стандартный интерфейс для управления, редактирования и отправки сообщений электронной почты.
    /// - Parameter mailComposer: Стандартный интерфейс для управления электронной почты.
    func displayMailComposer(mailComposer: MFMailComposeViewController)
}

// MARK: - UIViewController + MailAbility
extension UIViewController: MailAbility {

    public func displayMailComposer(mailComposer: MFMailComposeViewController) {
        present(mailComposer, animated: true)
    }
}
#endif
