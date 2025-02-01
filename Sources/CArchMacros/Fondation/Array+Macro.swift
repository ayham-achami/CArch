//
//  Array+Macro.swift
//

import Foundation

// MARK: - Array + Chunked
extension Array {
    
    /// Разделить массив на под-массивы по заданному количеству
    /// - Parameter size: Размер под-массива
    /// - Returns: Массив под-массивов
    func chunked(into size: Int) -> [[Element]] {
        stride(from: 0, to: count, by: size).map { .init(self[$0..<Swift.min($0 + size, count)]) }
    }
}
