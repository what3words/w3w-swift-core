//
//  File.swift
//  w3w-swift-core
//
//  Created by Kaley Nguyen on 16/9/25.
//

import Foundation

public extension W3WRfcLanguageProtocol {
  /// convert W3WRfcLanguage to W3WLanguage
  func toW3wLanguage() -> W3WLanguage? {
    guard let code, !code.isEmpty else {
      return nil
    }
    return W3WBaseLanguage(locale: self.shortIdentifier)
  }
}

@available(iOS 13.0.0, *)
@available(watchOS 6.0.0, *)
extension W3WBaseLanguage: W3WRfcLanguageConvertable {
  /// convert W3WBaseLanguage to any W3WRfcLanguageProtocol
  public func toRfcLanguage() -> some W3WRfcLanguageProtocol {
    let parsedLocale = Locale(identifier: locale)
    return W3WRfcLanguage(locale: parsedLocale)
  }
}

