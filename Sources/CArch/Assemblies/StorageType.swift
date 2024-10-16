//
//  StorageType.swift
//

import Foundation

/// Типы ссылок на объекты в контейнер зависимостей
public enum StorageType: @unchecked Sendable {
    
    /// Слабая ссылка на объект
    public class WeakReference<Wrapped: AnyObject> {
        
        /// Объект назначения
        public private(set) weak var wrapped: Wrapped?
        
        /// Инициализация с объектом
        /// - Parameter wrapped:  Объект, на которого ссылка будет создано
        public init(_ wrapped: Wrapped) {
            self.wrapped = wrapped
        }
    }
    
    /// Сильная ссылка на объект
    public class StrongReference<Wrapped: AnyObject> {
        
        /// Объект назначения
        public private(set) var wrapped: Wrapped?
        
        /// Инициализация с объектом
        /// - Parameter wrapped: Объект, на которого ссылка будет создано
        public init(_ wrapped: Wrapped) {
            self.wrapped = wrapped
        }
    }
    
    /// - fleeting: Всегда будет новый экземпляр объекта при цикле revolve
    case fleeting
    /// - singleton: Cинглтон, объект всегда есть, и будет всегда при цикле resolve
    ///              возвращен один и тоже объект
    case singleton
    /// - autoRelease: Автоматическое уничтожение, пока на объекта есть сильная
    ///                ссылка всегда он есть при цикле revolve, уничтожается когда
    ///                нет не каких сильных ссылка на объект и тогда при следующем цикле
    ///                возвращается новый экземпляр объекта
    case autoRelease
    /// - alwaysNewInstance: Всегда будет новый экземпляр объекта при цикле revolve
    @available(*, deprecated, message: "This feature has be deprecated and will be removed in future release")
    case alwaysNewInstance
}
