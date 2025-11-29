//
//  File.swift
//  w3w-swift-core
//
//  Created by Kaley Nguyen on 21/11/25.
//

import Foundation
#if canImport(w3w)
import w3w

public extension W3WRfcLanguageProtocol {
  /// convert W3WRfcLanguage to W3WSdkLanguage
  func toW3wSdkLanguage() throws -> W3WSdkLanguage? {
    guard let code, !code.isEmpty else {
      return nil
    }
    return try W3WSdkLanguage(shortIdentifier)
  }
}

@available(iOS 13.0.0, *)
@available(watchOS 6.0.0, *)
extension W3WSdkLanguage: W3WRfcLanguageConvertable {
  /// convert W3WSdkLanguage to any W3WRfcLanguageProtocol
  public func toRfcLanguage() -> some W3WRfcLanguageProtocol {
    return W3WRfcLanguage(locale: Locale(identifier: locale))
  }
}
#endif

