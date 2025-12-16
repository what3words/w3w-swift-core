# W3WRfcLanguage

A lightweight representation of an RFC 5646 language tag used in w3w-swift-core. It models:

- language code (ISO 639; prefer 2-letter when available)
- optional script code (4 letters, Titlecase)
- optional region code (2 letters or 3 digits)

It provides:
- A protocol `W3WRfcLanguageProtocol` that any type can conform to
- A concrete struct `W3WRfcLanguage`
- An extension that makes `Locale.Language` conform to the protocol on iOS 16+/watchOS 9+
- Utilities to build identifiers and parse from strings

## Availability

- `Locale.Language` conformance requires iOS 16+ or watchOS 9+.
- `W3WRfcLanguage` itself is available on all supported platforms; when running on iOS < 16/watchOS < 9, script extraction from `Locale` may be unavailable and remain `nil`.

## Types

### W3WRfcLanguageProtocol
```swift
public protocol W3WRfcLanguageProtocol: Equatable {
  var code: String? { get }        // ISO 639 language code
  var scriptCode: String? { get }  // 4-letter Titlecase script code (e.g. "Latn", "Hans")
  var regionCode: String? { get }  // 2-letter or 3-digit region (e.g. "US", "419")
}

