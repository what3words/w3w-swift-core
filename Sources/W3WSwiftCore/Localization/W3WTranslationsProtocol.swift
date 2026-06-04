//
//  File.swift
//  
//
//  Created by Dave Duprey on 05/07/2024.
//


public protocol W3WTranslationsProtocol: W3WAvailableLanguageProtocol {
  
  /// given a translation id return the translation for the given device locale
  /// - Parameters:
  ///     - id: a translation id
  func get(id: String) -> String
  
  /// given a translation id return the translation for the given device locale rfc
  /// - Parameters:
  ///     - id: a translation id
  func getRfc(id: String) -> String
  
  /// given a translation id return the translation for the given device locale with rfcLanguage
  /// - Parameters:
  ///     - id: a translation id
  ///     - language: the language to translate into
  func getRfc(id: String, language: (any W3WRfcLanguageProtocol)?) -> String
}

public extension W3WTranslationsProtocol {
  
  func get(id: String) -> String {
    return getRfc(id: id)
  }
  
  func getRfc(id: String, language: (any W3WRfcLanguageProtocol)?) -> String {
    return getRfc(id: id)
  }
  
  func getRfc(id: String) -> String {
    return getRfc(id: id, language: nil)
  }
}


public extension W3WTranslationsProtocol {
  /// Returns a localized, formatted string for the given translation id using the provided arguments.
  ///
  /// - Parameters:
  ///   - id: The translation id or key to look up.
  ///   - arguments: Values to substitute into the localized string using `String(format:)`-style formatting.
  /// - Returns: A formatted localized string with arguments inserted.
  func get(id: String, _ arguments: CVarArg...) -> String {
    let localized = get(id: id)
    return String(format: localized, arguments)
  }
}
