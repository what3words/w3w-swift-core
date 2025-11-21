//
//  w3wRfcLanguage_w3wSdkLanguage_tests.swift
//  w3w-swift-core
//
//  Created by Kaley Nguyen on 21/11/25.
//

import XCTest
@testable import W3WSwiftCore
import w3w

final class W3wRfcLanguage_w3wSdkLanguage_tests: XCTestCase {
  func testConvertSdkLanguageToRfcLanguage_Success() throws {
    //1
    let sdkLanguage = try W3WSdkLanguage("fr_fr")
    let convertedRfcLanguage = sdkLanguage.toRfcLanguage() as! W3WRfcLanguage
    let rfcLanguage = W3WRfcLanguage(from: "fr_FR")
    
    XCTAssertTrue(convertedRfcLanguage == rfcLanguage )
    XCTAssertEqual(convertedRfcLanguage.code, "fr")
    XCTAssertEqual(convertedRfcLanguage.regionCode, "FR")
    if #available(iOS 16, *) {
      XCTAssertNotNil(convertedRfcLanguage.scriptCode)
    }
  }
  
  func testConvertSdkLanguageToRfcLanguage_CodeOnly_Success() throws {
    //1
    let sdkLanguage = try W3WSdkLanguage("ja")
    let convertedRfcLanguage = sdkLanguage.toRfcLanguage() as! W3WRfcLanguage
    let rfcLanguage = W3WRfcLanguage(from: "ja")
    
    XCTAssertTrue(convertedRfcLanguage == rfcLanguage )
    XCTAssertEqual(convertedRfcLanguage.code, "ja")
    XCTAssertNil(convertedRfcLanguage.regionCode)
    if #available(iOS 16, *) {
      XCTAssertNotNil(convertedRfcLanguage.scriptCode)
    }
  }
  
  func testConvertRfcLanguageToSdkLanguage_Success() throws {
    let rfcLanguage = W3WRfcLanguage(from: "zh-Hans")
    let sdkLanguage = try rfcLanguage.toW3wSdkLanguage()
    
    XCTAssertNotNil(sdkLanguage)
    XCTAssertEqual(sdkLanguage?.code, "zh")
  }
  
  func testConvertRfcLanguageToSdkLanguage_Code3Characters_Failure() throws {
    let rfcLanguage = W3WRfcLanguage(from: "yue-Hans")

    XCTAssertThrowsError(try rfcLanguage.toW3wSdkLanguage()) { error in
      XCTAssertNotNil(error)
    }
  }
  
  func testConvertSdkLanguageToRfcLanguage_CodeScriptRegion_failure() throws {
    let rfcLanguage = W3WRfcLanguage(from: "kk_Cyrl_KZ")

    XCTAssertThrowsError(try rfcLanguage.toW3wSdkLanguage()) { error in
      XCTAssertNotNil(error)
    }
  }
  
  // comparing 2 languages (W3WBaseLanguage & W3WSdkLanguage) by converting them to W3WRfcLanguage
  func testMatchingRfcLanguage() throws {
    let string = "sv-SE"
    let sdkString = "sv_se"
    let w3wBaseLanguage = W3WBaseLanguage(locale: string)
    let w3wSdkLanguage = try W3WSdkLanguage(sdkString)
    
    let firstLang = w3wBaseLanguage.toRfcLanguage() as! W3WRfcLanguage
    let secondLang = w3wSdkLanguage.toRfcLanguage() as! W3WRfcLanguage
    XCTAssertTrue(firstLang == secondLang)
    XCTAssertEqual(firstLang.code, secondLang.code)
    XCTAssertEqual(firstLang.regionCode, secondLang.regionCode)
  }

}
