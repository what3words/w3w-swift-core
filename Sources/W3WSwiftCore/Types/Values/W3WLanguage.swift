//
//  File.swift
//  
//
//  Created by Dave Duprey on 31/10/2022.
//
//  As of 2024 we started a transisiton to use standards
//  defined in RFC 5646, implementing the language, script
//  and region codes.
//  https://www.rfc-editor.org/rfc/rfc5646.txt
//
//  language ["-" script] ["-" region]
//  language is two characters ISO 639
//  script is four character ISO 15924
//  region is two character ISO 3166-1 code
//
//  This version, v1.X, is ambiguous on the locale contents
//  in that it could hold old SDK values or RFC 5646
//

import Foundation


public protocol W3WLanguage {
  
  /// ISO 639-1 2 letter code
  var code:String { get }
  
  /// RFC 5646 locale  (optionally w3w SDK values instead)
  var locale:String { get }
}


extension W3WLanguage {
  
  public static func getLanguageCode(from: String) -> String {
    return String(from.prefix(2))
  }
  
  
  public static func getLanguageRegion(from: String) -> String {
    if from.count == 5 {
      if String(Array(from)[2]) == "_" {
        return String(from.suffix(2))
      }
      if String(Array(from)[2]) == "-" {
        return String(from.suffix(2))
      }
    }
    
    return ""
  }

  
  /// gets the langauge name for a locale in the language specified by 'inLocale'
  /// Parameters
  ///   - forLocale: locale to find the language of
  ///   - inLocale: locale to translate the langauge name into
  public static func getLanguageName(forLocale: String, inLocale: String) -> String? {
    let inLocaleObj  = NSLocale(localeIdentifier: inLocale)
    let forLocaleObj = NSLocale(localeIdentifier: forLocale)
    
    var langaugeName = inLocaleObj.localizedString(forLanguageCode: forLocale) ?? ""
    
    if forLocale.count > 2 {
      if let countryCode = forLocaleObj.countryCode {
        langaugeName += " (" + (inLocaleObj.localizedString(forCountryCode: countryCode) ?? "") + ")"
      }
    }
    
    return langaugeName
  }

  
  public func getDeviceLanguages() -> [W3WLanguage] {
    var langauges = [W3WLanguage]()
    
    for locale_code in NSLocale.availableLocaleIdentifiers.sorted() {
      let language = W3WBaseLanguage(
        locale: locale_code,
        name: Self.getLanguageName(forLocale: locale_code, inLocale: self.locale) ?? "",
        nativeName: Self.getLanguageName(forLocale: locale_code, inLocale: locale_code) ?? ""
      )
      langauges.append(language)
    }

    return langauges
  }

  
  public func direction() -> W3WWritingDirection {
    switch NSLocale.characterDirection(forLanguage: locale) {
        
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


public struct W3WBaseLanguage: W3WLanguage, ExpressibleByStringLiteral {
  public typealias StringLiteralType = String
  
  
  /// name of the language
  public let name: String?
  
  /// name of the language in that language
  public let nativeName: String?
  
  /// ISO 639-1 2 letter code
  public let code: String
  
  /// 5 letter code for the locale
  public let locale:String

  
  /// Language struct
  /// - Parameters:
  ///   - code: ISO 639-1 two letter language code
  ///   - name: Name of the language in English
  ///   - nativeName: Name of the langiage in that language
  public init(code: String, name: String = "", nativeName: String = "") {
    if name == "" {
      self.name = Self.getLanguageName(forLocale: code, inLocale: "en")
    } else {
      self.name = name
    }
    
    if nativeName == "" {
      self.nativeName = Self.getLanguageName(forLocale: code, inLocale: code)
    } else {
      self.nativeName = nativeName
    }
    
    self.code       = String(code.prefix(2))
    self.locale     = String(code.prefix(2))
  }
  
  
  /// Language struct
  /// - Parameters:
  ///   - locale: Two letter region code
  ///   - name: Name of the language in English
  ///   - nativeName: Name of the langiage in that language
  public init(locale: String, name: String = "", nativeName: String = "") {
    if name == "" {
      self.name = Self.getLanguageName(forLocale: locale, inLocale: "en")
    } else {
      self.name = name
    }
    
    if nativeName == "" {
      self.nativeName = Self.getLanguageName(forLocale: locale, inLocale: locale)
    } else {
      self.nativeName = nativeName
    }
    
    self.code       = String(locale.prefix(2))
    self.locale     = locale
  }
  
  
  public init(stringLiteral: String) {
    self.init(locale: stringLiteral)
  }
  

  static public let english = W3WBaseLanguage(locale: "en_gb")
}
