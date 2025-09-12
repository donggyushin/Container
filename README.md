# Container

A Swift Package for a modern approach to Service Locator for Swift and SwiftUI.

## About

Container is inspired by the excellent [Factory](https://github.com/hmlongco/Factory) library, but designed as a lightweight alternative. This library focuses on simplicity while providing essential dependency injection features with fluent API and automatic mock injection for previews and tests.

## Installation

### Swift Package Manager

Add Container to your project using Swift Package Manager. In Xcode:

1. Go to File → Add Package Dependencies
2. Enter the repository URL: `https://github.com/donggyushin/Container`
3. Select the version you want to use

Or add it to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/donggyushin/Container", from: "1.2.0")
]
```

## Usage

### Basic Registration

Register your dependencies using the fluent Factory API:

```swift
import Container

protocol Repository {
    func fetchData() -> String
}

class RepositoryImpl: Repository {
    func fetchData() -> String { "Real data" }
}

class RepositoryMock: Repository {
    func fetchData() -> String { "Mock data" }
}

extension Container {
    var repository: Factory<Repository> {
        self {
            RepositoryImpl()
        }
        .shared  // Optional: Use shared scope (singleton-like)
        .onPreview {
            RepositoryMock()  // Automatically used in Xcode Previews and Tests
        }
    }
}
```

### Dependency Injection in ViewModels

Use the `@Injected` property wrapper for clean dependency injection:

```swift
class ViewModel: ObservableObject {
    @Injected(\.repository) private var repository
    
    func loadData() {
        let data = repository.fetchData()
        // Use data...
    }
}
```

### Alternative Access Methods

You can also access dependencies directly:

```swift
// Method 1: Function call syntax
let repo = Container.shared.repository()

// Method 2: Wrapped value property
let repo = Container.shared.repository.wrappedValue
```

### Scopes

Container supports two scopes:

- `.shared`: Creates a singleton instance (default)
- `.unique`: Creates a new instance each time

```swift
extension Container {
    var uniqueService: Factory<SomeService> {
        self {
            SomeService()
        }
        .unique  // New instance every time
    }
}
```

### Default Scope Configuration

Set a default scope for all factories:

```swift
// In your app initialization
Container.shared.defaultScope = .shared
```

## Requirements

- iOS 13.0+
- macOS 10.15+
- watchOS 6.0+
- tvOS 13.0+
- Swift 5.9+

## License

donggyushin