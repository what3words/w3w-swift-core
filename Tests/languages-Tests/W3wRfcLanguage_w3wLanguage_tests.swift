//
//  w3wRfcLanguage_w3wLanguage_tests.swift
//  w3w-swift-core
//
//  Created by Kaley Nguyen on 21/11/25.
//

import XCTest
@testable import W3WSwiftCore
import w3w

final class W3wRfcLanguage_w3wLanguage_tests: XCTestCase {
  
  func testConvertLanguageToRfcLanguage_LanguageOnly_Success() {
    let list = [
      "fr", "en", "ja", "ko", "pt", "de"
    ]
    for lang in list {
      let testLang = W3WBaseLanguage(locale: lang)
      let rfcLang = testLang.toRfcLanguage()
      XCTAssertNil(rfcLang.regionCode)
      XCTAssertEqual(rfcLang.code, testLang.code)
      
      let rfcLang2 = W3WRfcLanguage(from: lang)
      XCTAssertEqual(rfcLang2.code, rfcLang.code)
      XCTAssertEqual(rfcLang2.regionCode, rfcLang.regionCode)
      XCTAssertEqual(rfcLang2.scriptCode, rfcLang.scriptCode)
    }
  }
  
  func testConvertLanguageToRfcLangage_LanguageRegion_Success() {
    let list = [
      "en-US", "en-GB", "fr-CA", "pt-BR", "pt-PT",
      "es-MX", "es-ES", "vi-VN", "ja-JP", "ko-KR",
    ]
    for lang in list {
      let testLang = W3WBaseLanguage(locale: lang)
      let rfcLang = testLang.toRfcLanguage()
      XCTAssertNotNil(rfcLang.regionCode)
      XCTAssertEqual(rfcLang.code, testLang.code)
      
      let rfcLang2 = W3WRfcLanguage(from: lang)
      XCTAssertEqual(rfcLang2.code, rfcLang.code)
      XCTAssertEqual(rfcLang2.regionCode, rfcLang.regionCode)
      XCTAssertEqual(rfcLang2.scriptCode, rfcLang.scriptCode)
    }
  }
  
  func testConvertLanguageToRfcLangage_LanguageScript_Success() {
    let list = [
      "zh-Hans", "zh-Hant", "sr-Cyrl", "sr-Latn",
      "kk-Cyrl", "kk-Cyrl", "uz-Cyrl", "uz-Latn",
    ]
    for lang in list {
      let testLang = W3WBaseLanguage(locale: lang)
      let rfcLang = testLang.toRfcLanguage()
      XCTAssertNil(rfcLang.regionCode)
      if #available(iOS 16, *) {
        XCTAssertNotNil(rfcLang.scriptCode)
      }
      
      let rfcLang2 = W3WRfcLanguage(from: lang)
      XCTAssertEqual(rfcLang2.code, rfcLang.code)
      XCTAssertEqual(rfcLang2.regionCode, rfcLang.regionCode)
      if #available(iOS 16, *) {
        XCTAssertEqual(rfcLang2.scriptCode, rfcLang.scriptCode)
      }
    }
  }
  
  func testConvertLanguageToRfcLangage_LanguageScriptRegion_Success() {
    let list = [
      "zh-Hans-CN", "zh-Hant-TW", "sr-Cyrl-RS", "sr-Latn-BA",
      "kk-Cyrl-KZ", "uz-Latn-UZ",
    ]
    for lang in list {
      let testLang = W3WBaseLanguage(locale: lang)
      let rfcLang = testLang.toRfcLanguage()
      XCTAssertNotNil(rfcLang.regionCode)
      if #available(iOS 16, *) {
        XCTAssertNotNil(rfcLang.scriptCode)
      }
      XCTAssertNotNil(rfcLang.code)
      XCTAssertEqual(rfcLang.code, testLang.code)
      
      let rfcLang2 = W3WRfcLanguage(from: lang)
      XCTAssertEqual(rfcLang2.code, rfcLang.code)
      XCTAssertEqual(rfcLang2.regionCode, rfcLang.regionCode)
      if #available(iOS 16, *) {
        XCTAssertEqual(rfcLang2.scriptCode, rfcLang.scriptCode)
      }
    }
  }
  
  func testConvertLanguageToRfcLangage_CurrentLanguageList_Success() {
    let list: [String] = [
      "vi",
      "af",
      "id",
      "ms",
      "de",
      "en-AU",
      "en-GB",
      "en-US",
      "en-IN",
      "es-ES",
      "es-MX",
      "sw",
      "nl",
      "pt-BR",
      "pt-PT",
      "ro",
      "fi",
      "sv",
      "xh",
      "zu",
      "bg",
      "mn",
      "ru",
      "kk",
      "ko",
      "ja",
      "ar"
    ]
    
    for lang in list {
      let rfcLang = W3WRfcLanguage(from: lang)
      XCTAssertNotNil(rfcLang.code)
      if #available(iOS 16, *) {
        XCTAssertNotNil(rfcLang.scriptCode)
      }
      if lang.count > 3 {
        XCTAssertNotNil(rfcLang.regionCode)
      }
    }
  }
  
  func testConvertLanguageToRfcLangage_UnderscoreFormats_AppleLegacy_Success() {
    let list = [
      "en_US", "fr_FR", "pt_BR", "zh_CN", "zh_TW",
      "sr_Cyrl_RS",
    ]
    for lang in list {
      let rfcLang = W3WRfcLanguage(from: lang)
      let w3wLang = rfcLang.toW3wLanguage()
      XCTAssertEqual(w3wLang?.code, rfcLang.code)
    }
  }
  
  func testConvertLanguageToRfcLanguage_3CharactersCode_Success() {
    let list = [
      "haw-US",     // Hawaiian
      "yue-Hant",   // Cantonese
      "gsw-CH",     // Swiss German    ]
    ]
    for lang in list {
      let rfcLang = W3WRfcLanguage(from: lang)
      XCTAssertEqual(rfcLang.code?.count, 3)
    }
  }
  
  func testConvertLanguageToRfcLanguage_InvalidLanguage_Failure() {
    let list = [
      // invalid code
      "xx",
      "xxx",
      "123",
      // invalid script
      "en-ABCDE",
      "sr-OOO",
      "hr-12ab",
      // invalid region
      "en-USS",
      "fr-1234",
      "es-1X",
      "zh-Hans-CNN",
      // wrong order
      "CN-zh",
      "Cyrl-sr",
      "US-en",
      // too many components
      "en-US-extra",
      "sr-Cyrl-RS-foo",
      // empty component
      "-en",
      "en--US",
      "en-",
      "en- -US"
    ]
    for lang in list {
      let rfcLang = W3WRfcLanguage(from: lang)
      XCTAssertNil(rfcLang.code)
      XCTAssertNil(rfcLang.scriptCode)
      XCTAssertNil(rfcLang.regionCode)
    }
  }
  
}
