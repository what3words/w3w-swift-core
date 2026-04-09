//
//  W3WRfcLanguageProtocols.swift
//  w3w-swift-core
//
//  Created by Kaley Nguyen on 2/2/26.
//

import Foundation

public protocol W3WLanguageSelectionProtocol {
  /// to set RFCLanguage
  func set(language: any W3WRfcLanguageProtocol)
}

/// list out all available RFCLanguages
public protocol W3WAvailableLanguageProtocol {
  func availableLanguages() -> [W3WRfcLanguage]
}

public extension W3WAvailableLanguageProtocol {
  /// default convenience func for available languages, should override when in need
  func availableLanguages() -> [W3WRfcLanguage] {
    return []
  }
}

public protocol W3WExceptionalLanguagesProtocol {
  ///Exceptional cases
  var exceptionalCases: [String: String] { get }
}
