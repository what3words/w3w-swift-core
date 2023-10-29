//
//  File.swift
//  
//
//  Created by Dave Duprey on 31/10/2022.
//

import Foundation


public protocol W3WLanguage {
  
  /// name of the language
  //var name: String? { get }
  
  /// name of the language in that language
  //var nativeName: String? { get }

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


public struct W3WBaseLanguage: W3WLanguage {
  
  /// name of the language
  public var name: String? = ""
  
  /// name of the language in that language
  public var nativeName: String? = ""
  
  /// ISO 639-1 2 letter code
  public var code: String = ""
  
  /// 5 letter code for the locale
  public var locale:String = ""

  
  /// Language struct
  /// - Parameters:
  ///   - code: ISO 639-1 two letter language code
  ///   - name: Name of the language in English
  ///   - nativeName: Name of the langiage in that language
  public init(code: String, name: String = "", nativeName: String = "") {
    self.name       = name
    self.nativeName = nativeName
    self.code       = String(code.prefix(2))
    self.locale     = code.count == 5 ? code : ""
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
  
  
  /// Language struct
  /// - Parameters:
  ///   - locale: iOS' Locale.Language.Components struct
  @available(iOS 16.0, macOS 13.0, macCatalyst 16.0, tvOS 16.0, watchOS 9.0, *)
  init(locale l: Locale.Language.Components) {
    self.code       = l.languageCode?.identifier ?? ""
    self.name       = l.languageCode?.identifier ?? ""
    self.nativeName = l.languageCode?.identifier ?? ""
    self.locale     = (l.languageCode?.identifier ?? "") + "_" + (l.region?.identifier ?? "")
  }
  

  public init(locale: String) {
    //self.nativeName = self.code
    //self.name       = self.code
    self.code   = Self.getLanguageCode(from: locale)

    let region = Self.getLanguageRegion(from: locale)
    self.locale = Self.getLanguageCode(from: locale) + (region.count > 0 ? "_" + region : "")
  }

    
  static public let english = W3WBaseLanguage(locale: "en_gb")
}
