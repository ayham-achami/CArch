//
//  LodingAbility.swift
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

/// Протокол получения доступа к заглушке прогресс загрузки
public protocol LoadingPlaceholder {

    /// Заглушка прогресс загрузки
    var front: UIView { get }
}

/// Возможность показать индикатор загрузки
public protocol LoadingAbility {

    /// Показать индикатор загрузки
    ///
    /// - Parameter message: Сообщение, будет отображаться под индикатором загрузки
    func displayLoading(with message: String)

    /// Скрыть индикатор загрузки
    ///
    /// - Parameter completion: Замыкание выполняться после того, как срывается индикатор загрузки
    func hideLoading(completion: (() -> Void))

    /// Показать индикатор загрузки
    ///
    /// - Parameter placeholder: Заглушке прогресс загрузки
    func displayLoading(_ placeholder: LoadingPlaceholder?)

    /// Скрыть заглушку прогресс загрузки
    ///
    /// - Parameter completion: Замыкание выполняться после того, как срывается заглушке прогресс
    func hideLoadingPlaceholder(completion: (() -> Void)?)

    /// Показать индикатор загрузки
    ///
    /// - Parameter view: Цель, где показать индикатор загрузки
    func displayLoading(on view: UIView)

    /// Скрыть индикатор загрузки
    ///
    /// - Parameter view: Цель, где скрыть индикатор загрузки
    func hideLoading(on view: UIView)
}

// MARK: - LodingAbility + Default
public extension LoadingAbility {

    func displayLoading() {
        displayLoading(with: "")
    }

    func hideLoading() {
        hideLoading {}
    }
}
