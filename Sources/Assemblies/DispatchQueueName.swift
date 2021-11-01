//
//  DispatchQueueName.swift
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

import Foundation

/// Название очереди для внедрения в контейнер зависимости
public struct DispatchQueueName: RawRepresentable {
    
    public typealias RawValue = String
    
    public var rawValue: RawValue
    
    public init?(rawValue: String) {
        self.rawValue = rawValue
    }
}

// MARK: - DIResolver + DispatchQueueName
public extension DIResolver {
    
    /// Получение объекта из контейнера зависимости тип `DispatchQueue` по названию
    ///
    /// - Parameters:
    ///   - name: Название объекта `DispatchQueueName`
    /// - Returns: объекта из контейнера зависимости
    func unravel(dispatchQueueName: DispatchQueueName) -> DispatchQueue? {
        unravel(DispatchQueue.self, name: dispatchQueueName.rawValue)
    }
}

// MARK: - DIRegistrar + DispatchQueueName
public extension DIRegistrar {
    
    /// Регистрация объекта тип `DispatchQueue` в контейнер зависимости по названию
    ///
    /// - Parameters:
    ///   - queueName: `DispatchQueueName`
    ///   - storage: Тип ссылки по умолчанию `.autoRelease`
    func record(queueName: DispatchQueueName,
                inScope storage: StorageType = .autoRelease) {
        record(DispatchQueue.self, name: queueName.rawValue) { _ in
            DispatchQueue(label: queueName.rawValue)
        }
    }
    
    /// Регистрация объекта тип `DispatchQueue` в контейнер зависимости по названию
    /// - Parameters:
    ///   - queueName: DispatchQueueName`
    ///   - storage: Тип ссылки по умолчанию `.autoRelease`
    ///   - factory: Блок содержащий код реализующий логику внедрения очереди
    func record(queueName: DispatchQueueName,
                inScope storage: StorageType = .autoRelease,
                factory: @escaping (DIResolver) -> DispatchQueue) {
        record(DispatchQueue.self, name: queueName.rawValue) { resolver in factory(resolver) }
    }
}
