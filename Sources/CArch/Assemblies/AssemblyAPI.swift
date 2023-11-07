//
//  AssemblyAPI.swift
//

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
    
    /// Коллекция объектов
    var records: [any DIAssemblyCollection] { get }
    
    /// Инициализации без параметров
    init()
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
