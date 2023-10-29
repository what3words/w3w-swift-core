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


//  public var country: W3WBaseCountry? { get { return self.country } }
//  public var distanceToFocus: W3WBaseDistance? { get { return self.distanceToFocus } }
//  public var language: W3WBaseLanguage? { get { return self.language } }
//  }
//
//extension W3WSdkBox: W3WBox { }
//
//extension W3WSdkSquare: W3WSquare {
//  public var country: W3WBaseCountry? { get { return self.country } }
//  public var distanceToFocus: W3WBaseDistance? { get { return self.distanceToFocus } }
//  public var language: W3WBaseLanguage? { get { return self.language } }
//  public var bounds: W3WBaseBox? { get { return self.bounds } }
//}



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


//extension W3WSdkLine {
//  func asW3WLine() -> W3WLine {
//    return W3WBaseLine(start: start, end: end)
//  }
//}
//
//
//extension W3WSdkLanguage {
//  func asW3WLanguage() -> W3WLanguage {
//    return W3WBaseLanguage(locale: locale)
//  }
//}
//
//
//extension W3WSdkCountry {
//  func asW3WCountry() -> any W3WCountry {
//    return W3WBaseCountry(code: code)
//  }
//}

#endif
