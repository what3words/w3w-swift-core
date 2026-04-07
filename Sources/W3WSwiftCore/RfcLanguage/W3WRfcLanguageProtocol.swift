//
//  File.swift
//  w3w-swift-core
//
//  Created by Kaley Nguyen on 21/11/25.
//

import Foundation

public protocol W3WRfcLanguageProtocol: Equatable {
  var code: String? { get }
  var scriptCode: String? { get }
  var regionCode: String? { get }
}

public extension W3WRfcLanguageProtocol {
  // validate if language is supported by os, or else throw error
  static func validateiOSCompatibility(identifier: String) throws {
    let isValid: Bool
    if #available(iOS 16, watchOS 9, *) {
      let language = Locale.Language(identifier: identifier)
      let langCode = language.code ?? ""
      
      // Check if code exists and is either equivalent to a standard locale or passes custom validation
      isValid = !langCode.isEmpty &&
      (language.isEquivalent(to: .init(identifier: langCode)) || identifier.isValidLocale)
    } else {
      isValid = identifier.isValidLocale
    }
    
    if !isValid {
      throw W3WError.other(LanguageError.languageNotSupportedByOS)
    }
  }
}

public extension W3WRfcLanguageProtocol {
  /// full version: code - script - region
  var identifier: String {
    return [code, scriptCode, regionCode].compactJoined()
      
  }
  /// short : code - region
  var shortIdentifier: String {
    return [code, regionCode].compactJoined()
  }
  
  var iOSCompatible: Bool {
    do {
      try Self.validateiOSCompatibility(identifier: identifier)
      return true
    } catch {
      return false
    }
  }
  
  func direction() -> W3WWritingDirection {
    switch NSLocale.characterDirection(forLanguage: identifier) {
      case .unknown:
        return .leftToRight
      case .leftToRight:
        return .leftToRight
      case .rightToLeft:
        return .rightToLeft
      case .topToBottom:
        return .topToBottom
      case .bottomToTop:
        return .bottomToTop
      @unknown default:
        return .leftToRight
    }
  }
}

public extension W3WRfcLanguageProtocol {
  ///Exceptional cases
  var exceptionalCases: [String: String] { return [:] }
}

public enum LanguageError: Error {
  case languageNotSupportedByOS
}

/// protocol to convert any language to W3WRfcLanguage
public protocol W3WRfcLanguageConvertable<Language> {
  associatedtype Language: W3WRfcLanguageProtocol
  func toRfcLanguage() -> Language
}

extension Sequence where Element == String? {
  func compactJoined(separator: String = "-") -> String {
    return self.compactMap { $0 }.joined(separator: separator)
  }
}

