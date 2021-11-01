//
//  ShareAbility.swift
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

/// Возможность поделиться разных материалов
public protocol ShareAbility {

    /// Поделиться разных материалов
    ///
    /// - Parameters:
    ///   - text: Текст
    ///   - image: Изображение
    ///   - url: Ссылка
    ///   - completion: Замылканине вызывается при завершение диалога
    func share(_ text: String?, _ image: UIImage?, _ url: URL?, _ completion: (() -> Void)?)
}

// MARK: - ShareAbility + Extension
public extension ShareAbility {

    /// Поделиться разных материалов
    ///
    /// - Parameters:
    ///   - text: Текст
    ///   - completion: Забылканине вызывается при завершение диалога
    func share(_ text: String, _ completion: (() -> Void)? = nil) {
        share(text, nil, nil, completion)
    }

    /// Поделиться разных материалов
    ///
    /// - Parameters:
    ///   - text: Текст
    ///   - url: Ссылка
    ///   - completion: Замылканине вызывается при завершение диалога
    func share(_ text: String? = nil, _ image: UIImage, _ completion: (() -> Void)? = nil) {
        share(text, image, nil, completion)
    }

    /// Поделиться разных материалов
    ///
    /// - Parameters:
    ///   - text: Текст
    ///   - url: Ссылка
    ///   - completion: Замылканине вызывается при завершение диалога
    func share(_ text: String? = nil, _ url: URL, _ completion: (() -> Void)? = nil) {
        share(text, nil, url, completion)
    }
}

// MARK: - UIViewController + ShareAbility
public extension ShareAbility where Self: UIViewController {

    func share(_ text: String?, _ image: UIImage?, _ url: URL?, _ completion: (() -> Void)?) {
        var activityItems = [Any]()
        if let text = text {
            activityItems.append(text + " ")
        }
        if let image = image {
            activityItems.append(image)
        }
        if let url = url {
            activityItems.append(url)
        }
        let activityViewController = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        if let popoverController = activityViewController.popoverPresentationController {
            popoverController.sourceView = view
            popoverController.sourceRect = CGRect(x: view.bounds.midX, y: view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        present(activityViewController, animated: true, completion: completion)
    }
}
