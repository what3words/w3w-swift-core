//
//  File.swift
//  
//
//  Created by Dave Duprey on 20/05/2022.
//

import Foundation

public struct W3WSettings {
  
  // mutable settings
  static public var measurement = W3WMeasurementSystem.system
  
  static public var separatorType = W3WSeparatorsType.firstCommaSecondDot

  // direction of writing
  static public var leftToRight = (NSLocale.characterDirection(forLanguage: NSLocale.preferredLanguages.first ?? W3WSettings.defaultLanguage.code) == Locale.LanguageDirection.leftToRight)
  
  // language to defaul to when not provided in a call
  public static var defaultLanguage = W3WBaseLanguage(code: "en", name: "English", nativeName: "English")

  
  // internal settings
  static let max_recording_length       = 4.0
  static let min_voice_sample_length    = 2.5
  static let end_of_speech_quiet_time   = 0.75
  static let defaultSampleRate          = Int32(44100)
  static let defaulMaxAmplitude         = 0.25

}

