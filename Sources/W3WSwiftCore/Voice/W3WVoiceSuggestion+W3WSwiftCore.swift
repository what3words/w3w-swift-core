//
//  File.swift
//  
//
//  Created by Dave Duprey on 26/06/2023.
//


public typealias W3WVoiceLanguage   = W3WBaseLanguage
//public typealias W3WVoiceSuggestion = W3WBaseSuggestion


// Represents a W3W suggestion from a voice system
public struct W3WVoiceSuggestion: W3WSuggestion, W3WRanked {

  // W3WSuggestion
  public var words : String?                    // the three word address
  public var country : W3WCountry?          // ISO 3166-1 alpha-2 country code
  public var nearestPlace : String?             // text description of a nearby place
  public var distanceToFocus : W3WDistance? // number of kilometers to the nearest place
  public var language : W3WLanguage?        // two letter language code

  // W3WRanked
  public var rank : Int?                 // indicates this suggestion's place in list from most probable to least probable match

  public init(words: String? = nil, country : W3WCountry? = nil, nearestPlace : String? = nil, distanceToFocus : W3WDistance? = nil, language : W3WVoiceLanguage? = nil, rank: Int? = nil) {
    self.words = words
    self.country = country
    self.nearestPlace = nearestPlace
    self.distanceToFocus = distanceToFocus
    self.language = language
    self.rank = rank
  }

}


