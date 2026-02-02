//
//  LanguageUtils.swift
//  w3w-swift-core
//
//  Created by Kaley Nguyen on 14/11/25.
//
import Foundation

public class LanguageUtils {
  
  /// gets the langauge name for a locale in the language specified by 'inLocale'
  /// Parameters
  ///   - forLocale: locale to find the language of
  ///   - inLocale: locale to translate the langauge name into
  public static func getLanguageName(forLocale: String, inLocale: String) -> String? {
    let inLocaleObj  = NSLocale(localeIdentifier: inLocale)
    let forLocaleObj = NSLocale(localeIdentifier: forLocale)
    
    var languageName = inLocaleObj.localizedString(forLanguageCode: forLocale) ?? ""
    
    if forLocale.count > 2 {
      if let countryCode = forLocaleObj.countryCode {
        languageName += " (" + (inLocaleObj.localizedString(forCountryCode: countryCode) ?? "") + ")"
      }
    }
    
    return languageName
  }
  
  
  public static func availableLanguages() -> [any W3WRfcLanguageProtocol] {
    var languages = [W3WRfcLanguage]()
    
    for language in Locale.availableIdentifiers {
      languages.append(W3WRfcLanguage(from: language))
    }
    
    return languages
  }
  
}

extension String {
  var isValidLocale: Bool {
    let normalized = self.replacingOccurrences(of: "-", with: "_")
    return Locale.availableIdentifiers.contains(normalized)
  }
}
