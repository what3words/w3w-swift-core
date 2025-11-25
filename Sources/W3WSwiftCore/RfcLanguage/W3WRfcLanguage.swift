//
//  File.swift
//  w3w-swift-core
//
//  Created by Kaley Nguyen on 15/8/25.
//

import Foundation

/// language[-script][-region]
/// - language = ISO 639
///   Prefer ISO 639-1 (2-letter) whenever it exists
///   Only fall back to ISO 639-2 (3-letter) if a language has no 2-letter code
/// - script (optional, 4 letters, titlecased)
/// - region (optional, 2 letters or 3-digit number)
public struct W3WRfcLanguage: W3WRfcLanguageProtocol {
  public var code: String?
  public var scriptCode: String?
  public var regionCode: String?
  
  public init(locale: Locale) {
    if #available(iOS 16, *), #available(watchOS 9, *) {
      // from iOS 16 supports getting script
      self.init(from: locale.language)
    } else {
      // no script for iOS < 16
      self.init(
        languageCode: locale.languageCode,
        script: locale.scriptCode,
        region: locale.regionCode
      )
    }
  }
  
  public init(
    languageCode: String? = nil,
    script: String? = nil,
    region: String? = nil
  ) {
    self.code = languageCode
    self.scriptCode = script
    self.regionCode = region
  }
  
  @available(iOS 16, *)
  @available(watchOS 9, *)
  public init(from language: Locale.Language) {
    self.code = language.code
    self.scriptCode = language.scriptCode
    self.regionCode = language.regionCode
  }
}

public extension W3WRfcLanguage {
  /// Initialize from a string
  init(from string: String) {
    // Normalize separators
    let normalized = string
      .trimmingCharacters(in: .whitespacesAndNewlines)
      .replacingOccurrences(of: "_", with: "-")
    
    // Handle “Base” or empty strings, check if string is a valid locale string
    guard !normalized.isEmpty, string.isValidLocale else {
      self.init(languageCode: nil, script: nil, region: nil)
      return
    }
    
    if #available(iOS 16, *), #available(watchOS 9, *) {
      self.init(from: Locale.Language(identifier: normalized))
    } else {
      // Split into parts (e.g. zh-Hans-CN → ["zh", "Hans", "CN"])
      let parts = normalized.split(separator: "-").map(String.init)
      
      var langCode: String?
      var script: String?
      var region: String?
      
      if parts.count > 0 {
        langCode = parts[0]
      }
      
      if parts.count > 1 {
        let part = parts[1]
        // Detect if this is a script code (Titlecase and 4 letters)
        if part.count == 4, part.first?.isUppercase == true {
          script = part
          if parts.count > 2 {
            region = parts[2]
          }
        } else {
          region = part
        }
      }
      
      self.init(languageCode: langCode, script: script, region: region)
    }
  }
}

public extension W3WRfcLanguageProtocol {
  /// full version: code - script - region
  var identifier: String {
    return [code, scriptCode, regionCode]
      .compactMap { $0 }
      .joined(separator: "-")
    }
  /// short : code - region
  var shortIdentifier: String {
    return [code, regionCode]
      .compactMap { $0 }
      .joined(separator: "-")
  }
}

@available(watchOS 9, *)
@available(iOS 16, *)
extension Locale.Language : W3WRfcLanguageProtocol {
  public var code: String? {
    return languageCode?.identifier
  }
  
  public var scriptCode: String? {
    return self.script?.identifier
  }
  
  public var regionCode: String? {
    return region?.identifier
  }
}

