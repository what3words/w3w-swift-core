//
//  File.swift
//  
//
//  Created by Dave Duprey on 31/10/2022.
//

import Foundation


public protocol W3WLanguage {
  
  /// ISO 639-1 2 letter code
  var code:String { get }
  
  /// locale of the form xx_xx
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
    }
    
    return ""
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
    self.name       = name
    self.nativeName = nativeName
    self.code       = String(code.prefix(2))
    self.locale     = String(code.prefix(2))
  }
  
  
  /// Language struct
  /// - Parameters:
  ///   - locale: Two letter region code
  ///   - name: Name of the language in English
  ///   - nativeName: Name of the langiage in that language
  public init(locale: String, name: String = "", nativeName: String = "") {
    self.name       = name
    self.nativeName = nativeName
    self.code       = String(locale.prefix(2))
    self.locale     = locale
  }
  
  
  public init(stringLiteral: String) {
    self.init(locale: stringLiteral)
  }
  
  
  public init(locale: String) {
    let region = Self.getLanguageRegion(from: locale)

    self.nativeName = nil
    self.name       = nil
    self.code       = Self.getLanguageCode(from: locale)
    self.locale = Self.getLanguageCode(from: locale) + (region.count > 0 ? "_" + region : "")
  }

    
  static public let english = W3WBaseLanguage(locale: "en_gb")
}
