# DigiaEngageCleverTap iOS

[![Swift Package Index](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2FDigia-Technology-Private-Limited%2Fdigia_engage_clevertap_ios%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/Digia-Technology-Private-Limited/digia_engage_clevertap_ios)
[![Swift Package Index](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2FDigia-Technology-Private-Limited%2Fdigia_engage_clevertap_ios%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/Digia-Technology-Private-Limited/digia_engage_clevertap_ios)
[![License: BSL 1.1](https://img.shields.io/badge/License-BSL%201.1-blue.svg)](LICENSE)

A [Digia Engage](https://github.com/Digia-Technology-Private-Limited/digia_engage_ios) plugin that bridges CleverTap custom templates and display units into the Digia rendering engine. Enables CleverTap campaigns to render Digia-powered UI experiences.

## Requirements

| | Minimum |
|---|---|
| iOS | 16.0 |
| Swift | 6.0 |
| Xcode | 16.0 |
| CleverTap iOS SDK | 7.5.1 |

## Installation

### Swift Package Manager

Add the package to your `Package.swift`:

```swift
dependencies: [
    .package(
        url: "https://github.com/Digia-Technology-Private-Limited/digia_engage_clevertap_ios.git",
        from: "1.0.0-beta.1"
    ),
]
```

Then add `DigiaEngageCleverTap` as a target dependency:

```swift
.target(
    name: "YourTarget",
    dependencies: [
        .product(name: "DigiaEngageCleverTap", package: "digia_engage_clevertap_ios"),
    ]
)
```

Or add it directly in Xcode via **File → Add Package Dependencies** and enter the repository URL.

### CocoaPods

Add to your `Podfile`:

```ruby
pod 'DigiaEngageCleverTap', '~> 1.0.0-beta.1'
```

Then run:

```bash
pod install
```

## Usage

### 1. Initialize Digia Engage

```swift
import DigiaEngage

try await Digia.initialize(
    config: DigiaConfig(apiKey: "YOUR_DIGIA_API_KEY")
)
```

### 2. Register the CleverTap plugin

```swift
import DigiaEngageCleverTap

Digia.register(DigiaCleverTapPlugin())
```

### 3. Register CleverTap custom templates

Call this after initializing the CleverTap SDK, before `CleverTap.autoIntegrate()`:

```swift
import DigiaEngageCleverTap

DigiaCleverTapPlugin.registerTemplates()
```

### Full example

```swift
import DigiaEngage
import DigiaEngageCleverTap
import CleverTapSDK

@main
struct MyApp: App {
    init() {
        // Register Digia CleverTap templates before CT auto-integrate
        DigiaCleverTapPlugin.registerTemplates()
        CleverTap.autoIntegrate()

        Task {
            try await Digia.initialize(
                config: DigiaConfig(apiKey: "YOUR_DIGIA_API_KEY")
            )
            Digia.register(DigiaCleverTapPlugin())
        }
    }

    var body: some Scene {
        WindowGroup { ContentView() }
    }
}
```

## How It Works

This plugin implements the `DigiaCEPPlugin` protocol from `DigiaEngage`. When CleverTap triggers a custom template campaign, the plugin:

1. Maps the CleverTap payload to a Digia experience using `CleverTapPayloadMapper`
2. Fires Digia experience events back to CleverTap via `CleverTapEventBridge`
3. Registers custom display unit templates via `CleverTapTemplateRegistration`

## Dependencies

| Package | Version |
|---|---|
| [DigiaEngage iOS](https://github.com/Digia-Technology-Private-Limited/digia_engage_ios) | ≥ 1.0.0-beta.1 |
| [CleverTap iOS SDK](https://github.com/CleverTap/clevertap-ios-sdk) | 7.5.1 |

## License

[BSL 1.1](LICENSE) — Business Source License 1.1. Source available; production use requires a license from Digia Technology.

---

Built with ❤️ by the [Digia](https://digia.tech) team
