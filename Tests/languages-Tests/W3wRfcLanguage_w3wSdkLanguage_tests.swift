//
//  w3wRfcLanguage_w3wSdkLanguage_tests.swift
//  w3w-swift-core
//
//  Created by Kaley Nguyen on 21/11/25.
//

import Testing
@testable import W3WSwiftCore
import w3w

@Suite
struct W3wRfcLanguage_W3wSdkLanguage_Tests {
  
  @Test
  func convertSdkLanguageToRfcLanguage_Success() throws {
    let sdkLanguage = try W3WSdkLanguage("fr_fr")
    let convertedRfcLanguage = sdkLanguage.toRfcLanguage() as! W3WRfcLanguage
    let rfcLanguage = W3WRfcLanguage(from: "fr_FR")
    
    #expect(convertedRfcLanguage == rfcLanguage)
    #expect(convertedRfcLanguage.code == "fr")
    #expect(convertedRfcLanguage.regionCode == "FR")
    
    if #available(iOS 16, *) {
      #expect(convertedRfcLanguage.scriptCode != nil)
    }
  }
  
  @Test
  func convertSdkLanguageToRfcLanguage_CodeOnly_Success() throws {
    let sdkLanguage = try W3WSdkLanguage("ja")
    let convertedRfcLanguage = sdkLanguage.toRfcLanguage() as! W3WRfcLanguage
    let rfcLanguage = W3WRfcLanguage(from: "ja")
    
    #expect(convertedRfcLanguage == rfcLanguage)
    #expect(convertedRfcLanguage.code == "ja")
    #expect(convertedRfcLanguage.regionCode == nil)
    
    if #available(iOS 16, *) {
      #expect(convertedRfcLanguage.scriptCode != nil)
    }
  }
  
  @Test
  func convertRfcLanguageToSdkLanguage_Success() throws {
    let rfcLanguage = W3WRfcLanguage(from: "zh-Hans")
    let sdkLanguage = try rfcLanguage.toW3wSdkLanguage()
    
    #expect(sdkLanguage != nil)
    #expect(sdkLanguage?.code == "zh")
  }
  
  @Test
  func convertRfcLanguageToSdkLanguage_Code3Characters_Failure() {
    let rfcLanguage = W3WRfcLanguage(from: "yue-Hans")
    
    #expect(throws: Error.self) {
      _ = try rfcLanguage.toW3wSdkLanguage()
    }
  }
  
  @Test
  func convertSdkLanguageToRfcLanguage_CodeScriptRegion_Failure() {
    let rfcLanguage = W3WRfcLanguage(from: "zh-Hans-CN")
    
    #expect(throws: Error.self) {
      _ = try rfcLanguage.toW3wSdkLanguage()
    }
  }
  
  /// Compare W3WBaseLanguage & W3WSdkLanguage by converting to W3WRfcLanguage
  @Test
  func matchingRfcLanguage() throws {
    let string = "sv-SE"
    let sdkString = "sv_se"
    
    let w3wBaseLanguage = W3WBaseLanguage(locale: string)
    let w3wSdkLanguage = try W3WSdkLanguage(sdkString)
    
    let firstLang = w3wBaseLanguage.toRfcLanguage() as! W3WRfcLanguage
    let secondLang = w3wSdkLanguage.toRfcLanguage() as! W3WRfcLanguage
    
    #expect(firstLang == secondLang)
    #expect(firstLang.code == secondLang.code)
    #expect(firstLang.regionCode == secondLang.regionCode)
  }
}

