# DigiaEngageCleverTap iOS

Digia Engage CleverTap plugin for iOS. Routes CleverTap custom-template campaigns and display units into Digia Engage.

## Requirements

- Xcode 16+
- iOS 16+
- Swift 6

## Swift Package Manager

```swift
dependencies: [
    .package(
        url: "https://github.com/Digia-Technology-Private-Limited/digia_engage_clevertap_ios.git",
        from: "1.0.0-beta.1"
    ),
]
```

Then add `"DigiaEngageCleverTap"` as a target dependency.

## CocoaPods

```ruby
pod 'DigiaEngageCleverTap', '1.0.0-beta.1'
```

## Usage

```swift
import DigiaEngage
import DigiaEngageCleverTap

try await Digia.initialize(
    config: DigiaConfig(apiKey: "YOUR_API_KEY")
)

Digia.register(DigiaCleverTapPlugin())
```

---

Built with ❤️ by the Digia team
