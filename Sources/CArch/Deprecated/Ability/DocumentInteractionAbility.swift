//
//  DocumentInteractionAbility.swift
//

#if canImport(UIKit)
import UIKit

// MARK: UIDocumentInteractionController + Init
@available(*, deprecated, message: "This feature has been deprecated and will be removed in future release")
private extension UIDocumentInteractionController {

    /// Инициализация
    /// - Parameters:
    ///   - url:  Ссылка к документу на диске
    ///   - delegate: Набор методов, которые вы можете реализовать для ответа на сообщения от контроллера взаимодействия документов.
    convenience init(url: URL, delegate: UIDocumentInteractionControllerDelegate) {
        self.init(url: url)
        self.delegate = delegate
    }
}

/// Протокол работы с документами
@available(*, deprecated, message: "This feature has been deprecated and will be removed in future release")
@MainActor public protocol DocumentInteractionAbility: CArchProtocol {

    /// Показать содержание документа
    /// - Parameters:
    ///   - url: Ссылка к документу на диске
    ///   - delegate: Набор методов, которые вы можете реализовать для ответа на сообщения от контроллера взаимодействия документов.
    func showPreview(for url: URL, delegate: UIDocumentInteractionControllerDelegate) -> Bool
}

// MARK: - DocumentInteractionAbility + UIViewController
@available(*, deprecated, message: "This feature has been deprecated and will be removed in future release")
extension UIViewController: DocumentInteractionAbility {

    public func showPreview(for url: URL, delegate: UIDocumentInteractionControllerDelegate) -> Bool {
        UIDocumentInteractionController(url: url, delegate: delegate).presentPreview(animated: true)
    }
}

// MARK: - URL + UIDocumentInteractionController
@available(*, deprecated, message: "This feature has been deprecated and will be removed in future release")
public extension URL {

    var typeIdentifier: String {
        let identifier: String
        do {
            if let typeIdentifier = try resourceValues(forKeys: [.typeIdentifierKey]).typeIdentifier {
                identifier = typeIdentifier
            } else {
                identifier = "public.data"
            }
        } catch {
            identifier = "public.data"
        }
        return identifier
    }

    var localizedName: String? {
        let name: String
        do {
            if let localizedName = try resourceValues(forKeys: [.localizedNameKey]).localizedName {
                name = localizedName
            } else {
                name = lastPathComponent
            }
        } catch {
            name = lastPathComponent
        }
        return name
    }
}
#endif
