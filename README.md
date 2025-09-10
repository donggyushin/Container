# Container

A Swift Package for A modern approach to Service Locator for Swift and SwiftUI.

## About

Container is inspired by the excellent [Factory](https://github.com/hmlongco/Factory) library, but designed as a lightweight alternative. This library focuses on simplicity while providing essential dependency injection features with automatic memory management through weak references, even when using shared scope.

## Installation

### Swift Package Manager

Add Container to your project using Swift Package Manager. In Xcode:

1. Go to File → Add Package Dependencies
2. Enter the repository URL: `https://github.com/yourusername/Container`
3. Select the version you want to use

Or add it to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/donggyushin/Container", from: "1.0.0")
]
```

## Usage

### Registration
```swift
import Container

extension Container {
    var repository: Repository {
        resolve(scope: .shared) {
            APIService()
        } mockFactory: {
            // on Preview and Test
            MockRepository()
        }
    }
}
```

## Requirements

- iOS 13.0+
- macOS 10.15+
- watchOS 6.0+
- tvOS 13.0+
- Swift 5.9+

## License

donggyushin