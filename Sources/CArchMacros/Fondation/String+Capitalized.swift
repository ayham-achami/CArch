//
//  String+Capitalized.swift
//

import Foundation

// MARK: - String + capitalized
extension String {
    
    var capitalizedFunctionName: Self {
        prefix(1).uppercased() + dropFirst()
    }
}

// MARK: - String + uncapitalized
extension String {
    
    var uncapitalize: Self {
        prefix(1).lowercased() + dropFirst()
    }
}

// MARK: - String + Equel
extension String {
    
    var isDefault: Bool {
        self == "default"
    }
}

// MARK: - Dictionary + Sort by key count
extension Dictionary where Key == String, Value == String {
    
    var countSorted: [(key: Key, value: Value)] {
        sorted(by: { $0.key > $1.key })
    }
}

// MARK: - Dictionary.Keys + Sort by key count
extension Dictionary.Keys where Element == String {
    
    var countSorted: [Key] {
        sorted(by: { $0 > $1 })
    }
}

// MARK: - Dictionary.Values + Sort by key count
extension Dictionary.Values where Element == String {
    
    var countSorted: [Value] {
        sorted(by: { $0 > $1 })
    }
}
