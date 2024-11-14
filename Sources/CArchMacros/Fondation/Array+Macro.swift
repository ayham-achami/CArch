//
//  Array+Macro.swift
//

import Foundation

// MARK: - Array + Chunked
extension Array {
    
    /// <#Description#>
    /// - Parameter size: <#size description#>
    /// - Returns: <#description#>
    func chunked(into size: Int) -> [[Element]] {
        stride(from: 0, to: count, by: size).map { .init(self[$0..<Swift.min($0 + size, count)]) }
    }
}
