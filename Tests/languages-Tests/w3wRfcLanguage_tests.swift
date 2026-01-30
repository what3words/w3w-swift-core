//
//  w3wRfcLanguage_tests.swift
//  w3w-swift-core
//
//  Created by Kaley Nguyen on 3/12/25.
//

import Testing
import Foundation
@testable import W3WSwiftCore

@Suite
struct w3wRfcLanguage_tests {
  // these languages are not supported by iOS
  let exceptions = ["mn-Latn", "kk-Latn"]
  
  @Test func initRfcLanguage() async throws {
    let lang = W3WRfcLanguage(locale: Locale(identifier: "fr-FR"))
    #expect(lang.code == "fr")
    #expect(lang.nativeName == "français (France)")
    #expect(lang.name == "French (France)")
    #expect(lang.name(in: "ja") == "フランス語 (フランス)")
    #expect(lang.iOSCompatible)
  }
  
  @Test func initRfcLanguage_Exception_NoValidation() {
    let lang1 = W3WRfcLanguage(from: "mn-Latn")
    #expect(lang1.code == "mn")
    #expect(lang1.name == "Mongolian")
    #expect(lang1.scriptCode == "Latn")
    #expect(!lang1.iOSCompatible)
    
    let lang2 = W3WRfcLanguage(from: "mn-Cyrl")
    #expect(lang2.code == "mn")
    #expect(lang2.name == "Mongolian")
    #expect(lang2.scriptCode == "Cyrl")
    #expect(lang2.iOSCompatible)
    
    let lang3 = W3WRfcLanguage(from: "mn")
    #expect(lang3.code == "mn")
    #expect(lang3.name == "Mongolian")
    #expect(lang3.scriptCode == "Cyrl")
    #expect(lang2.iOSCompatible)
    
    let lang4 = W3WRfcLanguage(from: "kk-Cyrl")
    #expect(lang4.code == "kk")
    #expect(lang4.name == "Kazakh")
    #expect(lang4.scriptCode == "Cyrl")
    #expect(lang4.iOSCompatible)
    
    let lang5 = W3WRfcLanguage(from: "kk-Latn")
    #expect(lang5.code == "kk")
    #expect(lang5.name == "Kazakh")
    #expect(lang5.scriptCode == "Latn")
    #expect(!lang5.iOSCompatible)
    
    let lang6 = W3WRfcLanguage(from: "kk")
    #expect(lang6.code == "kk")
    #expect(lang6.name == "Kazakh")
    #expect(lang6.scriptCode == "Cyrl")
    #expect(lang6.iOSCompatible)
    
    // language with any random code that matches the format
    let lang7 = W3WRfcLanguage(code: "kk", scriptCode: "iost")
    #expect(lang7.code == "kk")
    #expect(lang7.scriptCode == "iost")
    #expect(!lang7.iOSCompatible)
  }
  
  @Test func initRfcLanguage_Exceptions_CheckiOSCompatible_Error() throws {
    // throw error when language is not supported
    #expect(throws: W3WError.other(LanguageError.languageNotSupportedByOS)) {
      _ = try W3WRfcLanguage(from: "mn-Latn", iOSCompatible: true)
    }
    
    #expect(throws: W3WError.other(LanguageError.languageNotSupportedByOS)) {
      _ = try W3WRfcLanguage(code: "mn", scriptCode: "Latn", iOSCompatible: true)
    }
  }
  
  /// some languages' codes are different but they are the same language
  @Test func initRfcLanguage_SameLanguageDifferentCode_CheckiOSCompatible_Success() throws {
    // code = mn, script = Cyrl
    let lang1 = try W3WRfcLanguage(from: "mn-Cyrl", iOSCompatible: true)
    #expect(lang1.code == "mn")
    #expect(lang1.name == "Mongolian")
    #expect(lang1.scriptCode == "Cyrl")
    
    let lang2 = try W3WRfcLanguage(code: "mn", scriptCode: "Cyrl", iOSCompatible: true)
    #expect(lang2.code == "mn")
    #expect(lang2.name == "Mongolian")
    #expect(lang2.scriptCode == "Cyrl")
    
    let lang3 = try W3WRfcLanguage(from: "mn", iOSCompatible: true)
    #expect(lang3.code == "mn")
    #expect(lang3.name == "Mongolian")
    #expect(lang3.scriptCode == "Cyrl")
    
    //2. code = kk, script = Cyrl
    let lang4 = try W3WRfcLanguage(from: "kk-Cyrl", iOSCompatible: true)
    #expect(lang4.code == "kk")
    #expect(lang4.scriptCode == "Cyrl")
    
    let lang5 = try W3WRfcLanguage(code: "kk", scriptCode: "Cyrl", iOSCompatible: true)
    #expect(lang5.code == "kk")
    #expect(lang5.scriptCode == "Cyrl")
    #expect(lang5.name == "Kazakh")
    
    let lang6 = try W3WRfcLanguage(code: "kk", iOSCompatible: true)
    #expect(lang6.code == "kk")
    #expect(lang6.name == "Kazakh")
  }
  
  /// List of our current w3w languages
  /// with the check iOS compatible, all languages except exceptions will be init successfully
  @Test(arguments: [
    "af", "am", "ar", "bn", "bs-Cyrl", "bs-Latn", "bg", "ca", "zh-Hant-HK",
    "zh-Hant-TW", "zh-Hans", "hr", "cs", "da", "nl", "en-AU", "en-CA",
    "en-GB", "en-IN", "en-US", "et", "fi", "fr-FR", "fr-CA", "de", "el",
    "gu", "he", "hi", "hu", "id", "it", "ja", "kn", "kk-Cyrl", "kk-Latn",
    "km", "ko", "lo", "ms", "ml", "mr", "mn-Cyrl", "mn-Latn", "sr-Cyrl-ME",
    "sr-Latn-ME", "ne", "no", "or", "fa", "pl", "pt-PT", "pt-BR", "pa",
    "ro", "ru", "sr-Cyrl-RS", "sr-Latn-RS", "si", "sk", "sl", "es-ES",
    "es-MX", "sw", "sv", "ta", "te", "th", "tr", "uk", "ur", "vi", "cy",
    "xh", "zu"
])
  func initRfcLanguage_fromW3WLanguages(lang: String) throws {
    if exceptions.contains(lang) {
      #expect(throws: W3WError.other(LanguageError.languageNotSupportedByOS)) {
        _ = try W3WRfcLanguage(from: lang, iOSCompatible: true)
      }
    } else {
      let rfcLanguage = try W3WRfcLanguage(from: lang, iOSCompatible: true)
      print(lang)
      #expect(rfcLanguage.code != nil)
    }
  }
}

