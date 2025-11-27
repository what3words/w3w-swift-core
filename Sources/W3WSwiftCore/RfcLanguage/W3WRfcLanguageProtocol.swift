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

extension W3WRfcLanguageProtocol {
  public var nativeName: String? {
    return LanguageUtils.getLanguageName(forLocale: identifier, inLocale: identifier)
  }
  
  public var name: String? {
    return LanguageUtils.getLanguageName(forLocale: identifier, inLocale: "en")
  }
}

/// protocol to convert any language to W3WRfcLanguage
public protocol W3WRfcLanguageConvertable<Language> {
  associatedtype Language: W3WRfcLanguageProtocol
  func toRfcLanguage() -> Language
}
