//
//  AssemblyAPI.swift
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

/// Протокол внедрения зависимости
public protocol DIAssembly {

    /// Предоставить хук для «Ассемблера» для загрузки сервисов в предоставленный контейнер
    /// - Parameter container: контейнер, предоставленный «Ассемблером»
    func assemble(container: DIContainer)
}

/// Коллекция объектов для добавления в контейнер зависимости
public protocol DIAssemblyCollection: Collection {
    
    /// Коллекция объектов
    var services: [DIAssembly] { get }
}

// MARK: - ServicesDICollection + Default
public extension DIAssemblyCollection {
    
    var startIndex: Int {
        services.startIndex
    }
    
    var endIndex: Int {
        services.endIndex
    }
    
    subscript(position: Int) -> DIAssembly {
        services[position]
    }
    
    func index(after index: Int) -> Int {
        services.index(after: index)
    }
}

/// Протокол отвечающий за создание всех серверов
@available(*, deprecated, message: "This feature has be deprecated and will be removed in future release")
public protocol ServicesRecorder {
    
    /// Инициализации без параметров
    init()
    
    /// Коллекция объектов
    var records: [any DIAssemblyCollection] { get }
}

// MARK: - ServicesRecorder + DIAssemblyCollection
@available(*, deprecated, message: "This feature has be deprecated and will be removed in future release")
public extension ServicesRecorder {
    
    var all: [DIAssembly] {
        records.reduce([]) { partialResult, assemblyCollection in
            partialResult + assemblyCollection.services
        }
    }
}
