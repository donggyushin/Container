//
//  File.swift
//  Container
//
//  Created by 신동규 on 9/12/25.
//

import Foundation

public struct Factory<T> {
    private let container: Container
    private let factory: () -> T
    private var scope: Container.Scope?
    private var previewFactory: (() -> T)?
    
    init(container: Container, factory: @escaping () -> T) {
        self.container = container
        self.factory = factory
    }
    
    public var shared: Factory<T> {
        var copy = self
        copy.scope = .shared
        return copy
    }
    
    public var unique: Factory<T> {
        var copy = self
        copy.scope = .unique
        return copy
    }
    
    public func onPreview(_ previewFactory: @escaping () -> T) -> Factory<T> {
        var copy = self
        copy.previewFactory = previewFactory
        return copy
    }
    
    public var wrappedValue: T {
        if (container.isPreview || container.isTest) && previewFactory != nil {
            return previewFactory!()
        }
        
        let scope = self.scope ?? container.defaultScope
        
        if scope == .shared {
            if let weakWrapper = container.sharedObjectStorage["\(T.self)"] as? WeakWrapper {
                if let shared = weakWrapper.value as? T {
                    return shared
                }
            }

            if let shared = container.sharedObjectStorage["\(T.self)"] as? T {
                return shared
            }

            let newInstance = factory()

            // Only use WeakWrapper for reference types to avoid type casting issues
            if type(of: newInstance) is AnyClass {
                let objectInstance = newInstance as AnyObject
                container.sharedObjectStorage["\(T.self)"] = WeakWrapper(value: objectInstance)
            } else {
                // Store value types directly
                container.sharedObjectStorage["\(T.self)"] = newInstance
            }

            return newInstance
        } else if scope == .unique {
            return factory()
        } else {
            return factory()
        }
    }
    
    public func callAsFunction() -> T {
        return wrappedValue
    }
}
