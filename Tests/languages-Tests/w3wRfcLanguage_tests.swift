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
  
  @Test func initRfcLanguage() async throws {
    let lang = W3WRfcLanguage(locale: Locale(identifier: "fr-FR"))
    #expect(lang.code == "fr")
    #expect(lang.nativeName == "français (France)")
    #expect(lang.name == "French (France)")
    #expect(lang.name(in: "ja") == "フランス語 (フランス)")
  }
  
  @Test func initRfcLanguage_changeDefault() async throws {
    let lang = W3WRfcLanguage(locale: Locale(identifier: "fr-FR"))
    #expect(lang.code == "fr")
  }
  
  @Test func initRfcLanguage_Exceptions_Mongolian() async throws {
    let lang1 = W3WRfcLanguage(from: "mn-Latn")
    #expect(lang1.code == "mn")
    #expect(lang1.name == "Mongolian")
    #expect(lang1.scriptCode == "Latn")
    
    let lang2 = W3WRfcLanguage(from: "mn-Cyrl")
    #expect(lang2.code == "mn")
    #expect(lang2.name == "Mongolian")
    #expect(lang2.scriptCode == "Cyrl")
    
    let lang3 = W3WRfcLanguage(from: "mn")
    #expect(lang3.code == "mn")
    #expect(lang3.name == "Mongolian")
    #expect(lang3.scriptCode == "Cyrl")
  }
  
  @Test func initRfcLanguage_Exceptions_Kazakh() async throws {
    let lang1 = W3WRfcLanguage(from: "kk-Cyrl")
    #expect(lang1.code == "kk")
    #expect(lang1.name == "Kazakh")
    #expect(lang1.scriptCode == "Cyrl")
    
    let lang2 = W3WRfcLanguage(from: "kk-Latn")
    #expect(lang2.code == "kk")
    #expect(lang2.name == "Kazakh")
    #expect(lang2.scriptCode == "Latn")
    
    let lang3 = W3WRfcLanguage(from: "kk")
    #expect(lang3.code == "kk")
    #expect(lang3.name == "Kazakh")
    #expect(lang3.scriptCode == "Cyrl")
  }
}

