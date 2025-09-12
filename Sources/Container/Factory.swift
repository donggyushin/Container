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
    private var scope: Container.Scope = .unique
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
    
    public func onPreview(_ previewFactory: @escaping () -> T) -> Factory<T> {
        var copy = self
        copy.previewFactory = previewFactory
        return copy
    }
    
    public var wrappedValue: T {
        if (container.isPreview || container.isTest) && previewFactory != nil {
            return previewFactory!()
        }
        
        if scope == .unique {
            return factory()
        } else {
            if let shared = container.sharedObjectStorage["\(T.self)"] as? T {
                return shared
            } else {
                let newInstance = factory()
                container.sharedObjectStorage["\(T.self)"] = newInstance
                return newInstance
            }
        }
    }
}

