//
//  DocumentInteractionAbility.swift
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

/// Протокол работы с документами
public protocol DocumentInteractionAbility: CArchProtocol {

    /// Показать содержание документа
    /// - Parameters:
    ///   - url: Ссылка к документу на диске
    ///   - delegate: Набор методов, которые вы можете реализовать для ответа на сообщения от контроллера взаимодействия документов.
    func showPreview(for url: URL, delegate: UIDocumentInteractionControllerDelegate) -> Bool
}

// MARK: - DocumentInteractionAbility + UIViewController
public extension DocumentInteractionAbility where Self: UIViewController {

    func showPreview(for url: URL, delegate: UIDocumentInteractionControllerDelegate) -> Bool {
        return UIDocumentInteractionController(url: url, delegate: delegate).presentPreview(animated: true)
    }
}

// MARK: UIDocumentInteractionController + Init
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

// MARK: - URL + UIDocumentInteractionController
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
