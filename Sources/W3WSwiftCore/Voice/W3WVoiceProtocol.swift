//
//  W3WVoice.swift
//  
//
//  Created by Dave Duprey on 31/05/2023.
//


@available(*, deprecated, renamed: "W3WVoiceProtocol")
typealias W3WVoice = W3WVoiceProtocol


/// The protocol for any what3words Swift voice processing objects
public protocol W3WVoiceProtocol {
  
  /// Returns a list of 3 word address suggestions based on user input and other parameters.
  /// - parameter audio: An audio source such as a W3WMicrophone
  /// - parameter options: are provided as an array of W3Option objects.
  /// - parameter callback: A completion block providing the suggestions and any error
  func autosuggest(audio: W3WAudioStream, language: W3WLanguage, options: [W3WOption]?, callback: @escaping W3WVoiceSuggestionsResponse)
  
  
  /// Returns a list of 3 word address suggestions based on user input and other parameters.
  /// - parameter audio: An audio source such as a W3WMicrophone
  /// - parameter options: are provided as a varidic list of W3Option objects.
  /// - parameter callback: A completion block providing the suggestions and any error
  func autosuggest(audio: W3WAudioStream, language: W3WLanguage, options: W3WOption..., callback: @escaping W3WVoiceSuggestionsResponse)


  /// Returns a list of 3 word address suggestions based on user input and other parameters.
  /// - parameter audio: An audio source such as a W3WMicrophone
  /// - parameter options: are provided as a W3Options object.
  /// - parameter callback: A completion block providing the suggestions and any error
  func autosuggest(audio: W3WAudioStream, language: W3WLanguage, options: W3WOptions, callback: @escaping W3WVoiceSuggestionsResponse)
  
}


