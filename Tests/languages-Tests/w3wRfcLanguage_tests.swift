//
//  w3wRfcLanguage_tests.swift
//  w3w-swift-core
//
//  Created by Kaley Nguyen on 3/12/25.
//

import Testing
@testable import W3WSwiftCore
import w3w

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
    W3WRfcLanguage.default = W3WRfcLanguage(from: "de")
    #expect(lang.code == "fr")
    #expect(lang.name == "Französisch (Frankreich)")
  }
}
