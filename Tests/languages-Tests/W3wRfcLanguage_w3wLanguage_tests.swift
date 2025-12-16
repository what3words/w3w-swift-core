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
  
  @Test(arguments: ["fr", "en", "ja", "ko", "pt", "de"])
  func convertLanguageToRfcLanguage_LanguageOnly_Success(lang: String) {
    let testLang = W3WBaseLanguage(locale: lang)
    let rfcLang = testLang.toRfcLanguage()
    
    #expect(rfcLang.regionCode == nil)
    #expect(rfcLang.code == testLang.code)
    
    let rfcLang2 = W3WRfcLanguage(from: lang)
    #expect(rfcLang2.code == rfcLang.code)
    #expect(rfcLang2.regionCode == rfcLang.regionCode)
    #expect(rfcLang2.scriptCode == rfcLang.scriptCode)
  }
  
  @Test(arguments: [
    "en-US", "en-GB", "fr-CA", "pt-BR", "pt-PT",
    "es-MX", "es-ES", "vi-VN", "ja-JP", "ko-KR"
  ])
  func convertLanguageToRfcLangage_LanguageRegion_Success(lang: String) {
    let testLang = W3WBaseLanguage(locale: lang)
    let rfcLang = testLang.toRfcLanguage()
    
    #expect(rfcLang.regionCode != nil)
    #expect(rfcLang.code == testLang.code)
    
    let rfcLang2 = W3WRfcLanguage(from: lang)
    #expect(rfcLang2.code == rfcLang.code)
    #expect(rfcLang2.regionCode == rfcLang.regionCode)
    #expect(rfcLang2.scriptCode == rfcLang.scriptCode)
    
  }
  
  @Test(arguments: [
    "zh-Hans", "zh-Hant", "sr-Cyrl", "sr-Latn",
    "uz-Cyrl", "uz-Latn"
  ])
  func convertLanguageToRfcLangage_LanguageScript_Success(lang: String) {
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
  
  @Test(arguments: [
    "zh-Hans-CN", "zh-Hant-TW", "sr-Cyrl-RS",
    "sr-Latn-BA", "uz-Latn-UZ"
  ])
  func convertLanguageToRfcLangage_LanguageScriptRegion_Success(lang: String) {
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
  
  @Test(arguments: [
    "vi", "af", "id", "ms", "de",
    "en-AU", "en-GB", "en-US", "en-IN",
    "es-ES", "es-MX", "sw", "nl",
    "pt-BR", "pt-PT", "ro", "fi",
    "sv", "xh", "zu", "bg", "mn",
    "ru", "kk", "ko", "ja", "ar"
  ])
  func convertLanguageToRfcLangage_CurrentLanguageList_Success(lang: String) {
    let rfcLang = W3WRfcLanguage(from: lang)
    
    #expect(rfcLang.code != nil)
    if #available(iOS 16, *) {
      #expect(rfcLang.scriptCode != nil)
    }
    if lang.count > 3 {
      #expect(rfcLang.regionCode != nil)
    }
  }
  
  @Test(arguments: [
    "en_US", "fr_FR", "pt_BR", "zh_CN", "zh_TW",
    "sr_Cyrl_RS"
  ])
  func convertLanguageToRfcLangage_UnderscoreFormats_AppleLegacy_Success(lang: String) {
    let rfcLang = W3WRfcLanguage(from: lang)
    let w3wLang = rfcLang.toW3wLanguage()
    
    #expect(w3wLang?.code == rfcLang.code)
  }
  
  @Test(arguments: [
    "haw-US",
    "yue-Hant",
    "gsw-CH"
  ])
  func convertLanguageToRfcLanguage_3CharactersCode_Success(lang: String) {
    let rfcLang = W3WRfcLanguage(from: lang)
    #expect(rfcLang.code?.count == 3)
  }
  
  @Test(arguments: [
    "xx", "xxx", "123",
    "en-ABCDE", "sr-OOO", "hr-12ab",
    "en-USS", "fr-1234", "es-1X", "zh-Hans-CNN",
    "CN-zh", "Cyrl-sr", "US-en",
    "en-US-extra", "sr-Cyrl-RS-foo",
    "-en", "en--US", "en-", "en- -US"
  ])
  func convertLanguageToRfcLanguage_InvalidLanguage_Failure(lang: String) {
    let rfcLang = W3WRfcLanguage(from: lang)
    #expect(rfcLang.code == nil)
    #expect(rfcLang.scriptCode == nil)
    #expect(rfcLang.regionCode == nil)
  }
}
