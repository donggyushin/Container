//
//  File.swift
//  Container
//
//  Created by 신동규 on 9/12/25.
//

import Foundation

@propertyWrapper
public struct Injected<T> {
    private let keyPath: KeyPath<Container, Factory<T>>
    
    public var wrappedValue: T {
        Container.shared[keyPath: keyPath]()
    }
    
    public init(_ keyPath: KeyPath<Container, Factory<T>>) {
        self.keyPath = keyPath
    }
}
