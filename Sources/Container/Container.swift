// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation

@propertyWrapper
public struct Injected<T> {
    private let keyPath: KeyPath<Container, T>
    
    public var wrappedValue: T {
        Container.shared[keyPath: keyPath]
    }
    
    public init(_ keyPath: KeyPath<Container, T>) {
        self.keyPath = keyPath
    }
}

public final class Container {
    private var isPreview: Bool = ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
    private var isTest: Bool = {
        var testing = false
        if ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil {
            testing = true
        }
        if ProcessInfo.processInfo.processName.contains("xctest") {
            testing = true
        }
        return testing
    }()
    
    nonisolated(unsafe) public static let shared = Container()
    private var sharedObjectStorage: [String: Any] = [:]
    
    private init() {}
    
}

private final class WeakWrapper {
    weak var value: AnyObject?
    
    init(value: AnyObject? = nil) {
        self.value = value
    }
}

extension Container {
    public enum Scope {
        case unique
        case shared
    }
}

extension Container {
    public func resolve<T: Any>(scope: Scope, factory: @escaping () -> T, mockFactory: (() -> T)? = nil) -> T {
        
        if (isPreview || isTest) && mockFactory != nil {
            return mockFactory!()
        }
        
        if scope == .unique {
            return factory()
        } else {
            if let shared = sharedObjectStorage["\(T.self)"] as? T {
                return shared
            } else {
                let newInstance = factory()
                sharedObjectStorage["\(T.self)"] = newInstance
                return newInstance
            }
        }
    }
}

