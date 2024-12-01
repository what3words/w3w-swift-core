//
//  File.swift
//  
//
//  Created by Dave Duprey on 05/07/2024.
//


public protocol W3WTranslationsProtocol {
  
  /// given a translation id return the translation for the given device locale
  /// - Parameters:
  ///     - id: a translation id
  func get(id: String) -> String
  
  /// given a translation id return the translation for the given device locale
  /// - Parameters:
  ///     - id: a translation id
  ///     - language: the language to translate into
  func get(id: String, language: W3WLanguage?) -> String
  
}


public extension W3WTranslationsProtocol {
  
  func get(id: String) -> String {
    return get(id: id, language: nil)
  }
  
}
