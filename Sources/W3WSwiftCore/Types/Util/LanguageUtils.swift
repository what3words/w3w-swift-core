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
}

extension String {
  var isValidLocale: Bool {
    let normalized = self.replacingOccurrences(of: "-", with: "_")
    /// 1. Direct check
    if Locale.availableIdentifiers.contains(normalized) {
      return true
    }
    /// 2. Fallback: Strip the script code and check again
    /// Ex: en_Latn_IN -> en_IN
    let components = Locale.components(fromIdentifier: normalized)
    if let language = components[NSLocale.Key.languageCode.rawValue], let region = components[NSLocale.Key.countryCode.rawValue] {
      let shortIdentifier = "\(language)_\(region)"
      return Locale.availableIdentifiers.contains(shortIdentifier)
    }
    
    return false
  }
}
