// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation

public final class Container {
    
    public var defaultScope: Scope = .shared
    
    var isPreview: Bool = ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
    var isTest: Bool = {
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
    var sharedObjectStorage: [String: Any] = [:]
    
    private init() {}
    
}

extension Container {
    public enum Scope {
        case unique
        case shared
    }
}

extension Container {
    public func callAsFunction<T>(_ factory: @escaping () -> T) -> Factory<T> {
        Factory(container: self, factory: factory)
    }
}
