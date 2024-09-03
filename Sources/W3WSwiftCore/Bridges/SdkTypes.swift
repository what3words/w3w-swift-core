//
//  File.swift
//  
//
//  Created by Dave Duprey on 06/04/2023.
//

import Foundation


#if canImport(w3w)
import w3w


//// make the following conform to the main protocols


extension W3WSdkLanguage: W3WLanguage { }
extension W3WSdkLine: W3WLine { }
extension W3WSdkCountry: W3WCountry { }
extension W3WSdkDistance: W3WDistance { }


public extension W3WSdkSquare {

  func asBaseSquare() -> W3WSquare {
    return W3WBaseSquare(
      words:           words,
      country:         (country == nil) ? nil : W3WBaseCountry(code: country!.code),
      nearestPlace:    nearestPlace,
      distanceToFocus: (distanceToFocus == nil) ? nil : W3WBaseDistance(meters: distanceToFocus!.meters),
      language:        (language == nil) ? nil : W3WBaseLanguage(locale: language!.locale),
      coordinates:     coordinates,
      bounds:          (bounds == nil) ? nil : W3WBaseBox(southWest: bounds!.southWest, northEast: bounds!.northEast)
    )
  }
}


public extension W3WSdkSuggestion {
  
  func asBaseSuggestion() -> W3WSuggestion {
    return W3WBaseSuggestion(
      words:            words,
      country:          (country == nil) ? nil : W3WBaseCountry(code: country!.code),
      nearestPlace:     nearestPlace,
      distanceToFocus:  (distanceToFocus == nil) ? nil : W3WBaseDistance(meters: distanceToFocus!.meters),
      language:         (language == nil) ? nil : W3WBaseLanguage(locale: language!.locale)
    )
  }
}

#endif
