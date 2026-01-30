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
  /// default language is "en". name's default can be changed externally to use a different language by an app if nessesary
  public static var `default` = W3WRfcLanguage(code: "en")
  
  public var code: String?
  public var scriptCode: String?
  public var regionCode: String?
  
  public init(locale: Locale) {
    if #available(iOS 16, *), #available(watchOS 9, *) {
      // from iOS 16 supports getting script
      self.init(from: locale.language)
    } else {
      // no script for iOS < 16
      self.init(code: locale.languageCode,
                scriptCode: locale.scriptCode,
                regionCode: locale.regionCode)
    }
  }
  
  public init(
    code: String? = nil,
    scriptCode: String? = nil,
    regionCode: String? = nil
  ) {
    self.code = code
    self.scriptCode = scriptCode
    self.regionCode = regionCode
  }
  
  /// if you want to init and validate that the language is supported on os, set `iOSCompatible` = `true`, or else = `false`
  /// if it's not valid, an error will be thrown
  public init(
    code: String? = nil,
    scriptCode: String? = nil,
    regionCode: String? = nil,
    iOSCompatible: Bool
  ) throws {
    let string = [code, scriptCode, regionCode].compactJoined()
    // 1. Validate only if iOS compatibility is required
    if iOSCompatible {
      try Self.validateiOSCompatibility(identifier: string)
    }
    self.code = code
    self.scriptCode = scriptCode
    self.regionCode = regionCode
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
  /// if you want to init and validate that the language is supported on os, set `iOSCompatible` = `true`, or else = `false`
  /// if it's not valid, an error will be thrown
  init(from string: String, iOSCompatible: Bool) throws {
    if iOSCompatible {
      try Self.validateiOSCompatibility(identifier: string)
    }
    
    self.init(from: string)
  }
  /// Initialize from a string
  init(from string: String) {
    // Normalize separators
    let normalized = string
      .trimmingCharacters(in: .whitespacesAndNewlines)
      .replacingOccurrences(of: "_", with: "-")
    
    // Check not empty string
    guard !normalized.isEmpty else {
      self.init(code: nil, scriptCode: nil, regionCode: nil)
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
      
      self.init(code: langCode, scriptCode: script, regionCode: region)
    }
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

extension W3WRfcLanguage {
  /// this is returned correctly as long as OS recognizes the language code,
  /// or else it will be the name in English (the same as name below)
  /// this can happen as we have some sdk languages which are not supported by OS, ex: mn-Latn
  public var nativeName: String? {
    return LanguageUtils.getLanguageName(forLocale: identifier, inLocale: identifier)
  }
  
  public var name: String? {
    return LanguageUtils.getLanguageName(forLocale: identifier, inLocale: Self.default.identifier)
  }
  
  /// get name of the language in any particular locale
  func name(in locale: String) -> String? {
    return LanguageUtils.getLanguageName(forLocale: identifier, inLocale: locale)
  }
  
  /// get name of the language in any other language
  func name(in language: W3WRfcLanguage) -> String? {
    return name(in: language.identifier)
  }
}

