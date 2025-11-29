//
//  W3wRfcLanguage_w3wLanguage_tests.swift
//  w3w-swift-core
//
//  Created by Kaley Nguyen on 21/11/25.
//

import Testing
@testable import W3WSwiftCore
import w3w

@Suite
struct W3wRfcLanguage_W3wLanguage_Tests {
  
  @Test
  func convertLanguageToRfcLanguage_LanguageOnly_Success() {
    let list = ["fr", "en", "ja", "ko", "pt", "de"]
    
    for lang in list {
      let testLang = W3WBaseLanguage(locale: lang)
      let rfcLang = testLang.toRfcLanguage()
      
      #expect(rfcLang.regionCode == nil)
      #expect(rfcLang.code == testLang.code)
      
      let rfcLang2 = W3WRfcLanguage(from: lang)
      #expect(rfcLang2.code == rfcLang.code)
      #expect(rfcLang2.regionCode == rfcLang.regionCode)
      #expect(rfcLang2.scriptCode == rfcLang.scriptCode)
    }
  }
  
  @Test
  func convertLanguageToRfcLangage_LanguageRegion_Success() {
    let list = [
      "en-US", "en-GB", "fr-CA", "pt-BR", "pt-PT",
      "es-MX", "es-ES", "vi-VN", "ja-JP", "ko-KR"
    ]
    
    for lang in list {
      let testLang = W3WBaseLanguage(locale: lang)
      let rfcLang = testLang.toRfcLanguage()
      
      #expect(rfcLang.regionCode != nil)
      #expect(rfcLang.code == testLang.code)
      
      let rfcLang2 = W3WRfcLanguage(from: lang)
      #expect(rfcLang2.code == rfcLang.code)
      #expect(rfcLang2.regionCode == rfcLang.regionCode)
      #expect(rfcLang2.scriptCode == rfcLang.scriptCode)
    }
  }
  
  @Test
  func convertLanguageToRfcLangage_LanguageScript_Success() {
    let list = [
      "zh-Hans", "zh-Hant", "sr-Cyrl", "sr-Latn",
      "uz-Cyrl", "uz-Latn"
    ]
    
    for lang in list {
      let testLang = W3WBaseLanguage(locale: lang)
      let rfcLang = testLang.toRfcLanguage()
      
      #expect(rfcLang.regionCode == nil)
      if #available(iOS 16, *) {
        #expect(rfcLang.scriptCode != nil)
      }
      
      let rfcLang2 = W3WRfcLanguage(from: lang)
      #expect(rfcLang2.code == rfcLang.code)
      #expect(rfcLang2.regionCode == rfcLang.regionCode)
      if #available(iOS 16, *) {
        #expect(rfcLang2.scriptCode == rfcLang.scriptCode)
      }
    }
  }
  
  @Test
  func convertLanguageToRfcLangage_LanguageScriptRegion_Success() {
    let list = [
      "zh-Hans-CN", "zh-Hant-TW", "sr-Cyrl-RS", "sr-Latn-BA",
      "uz-Latn-UZ"
    ]
    
    for lang in list {
      let testLang = W3WBaseLanguage(locale: lang)
      let rfcLang = testLang.toRfcLanguage()
      
      #expect(rfcLang.regionCode != nil)
      if #available(iOS 16, *) {
        #expect(rfcLang.scriptCode != nil)
      }
      #expect(rfcLang.code == testLang.code)
      
      let rfcLang2 = W3WRfcLanguage(from: lang)
      #expect(rfcLang2.code == rfcLang.code)
      #expect(rfcLang2.regionCode == rfcLang.regionCode)
      if #available(iOS 16, *) {
        #expect(rfcLang2.scriptCode == rfcLang.scriptCode)
      }
    }
  }
  
  @Test
  func convertLanguageToRfcLangage_CurrentLanguageList_Success() {
    let list: [String] = [
      "vi", "af", "id", "ms", "de",
      "en-AU", "en-GB", "en-US", "en-IN",
      "es-ES", "es-MX", "sw", "nl",
      "pt-BR", "pt-PT", "ro", "fi",
      "sv", "xh", "zu", "bg", "mn",
      "ru", "kk", "ko", "ja", "ar"
    ]
    
    for lang in list {
      let rfcLang = W3WRfcLanguage(from: lang)
      
      #expect(rfcLang.code != nil)
      if #available(iOS 16, *) {
        #expect(rfcLang.scriptCode != nil)
      }
      if lang.count > 3 {
        #expect(rfcLang.regionCode != nil)
      }
    }
  }
  
  @Test
  func convertLanguageToRfcLangage_UnderscoreFormats_AppleLegacy_Success() {
    let list = [
      "en_US", "fr_FR", "pt_BR", "zh_CN", "zh_TW",
      "sr_Cyrl_RS"
    ]
    
    for lang in list {
      let rfcLang = W3WRfcLanguage(from: lang)
      let w3wLang = rfcLang.toW3wLanguage()
      
      #expect(w3wLang?.code == rfcLang.code)
    }
  }
  
  @Test
  func convertLanguageToRfcLanguage_3CharactersCode_Success() {
    let list = [
      "haw-US",
      "yue-Hant",
      "gsw-CH"
    ]
    
    for lang in list {
      let rfcLang = W3WRfcLanguage(from: lang)
      #expect(rfcLang.code?.count == 3)
    }
  }
  
  @Test
  func convertLanguageToRfcLanguage_InvalidLanguage_Failure() {
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
      #expect(rfcLang.code == nil)
      #expect(rfcLang.scriptCode == nil)
      #expect(rfcLang.regionCode == nil)
    }
  }
}
