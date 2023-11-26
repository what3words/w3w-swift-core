//
//  File.swift
//  
//
//  Created by Dave Duprey on 07/11/2022.
//

import Foundation



// common denominated suggestion structure
public protocol W3WSuggestion: CustomStringConvertible {
  
  /// three word address
  var words: String? { get }
  
  /// contains ISO 3166-1 alpha-2 country codes, such as US,CA
  var country: (any W3WCountry)? { get }
  
  /// nearest place
  var nearestPlace: String? { get }
  
  /// distance from focus
  var distanceToFocus: W3WDistance? { get }
  
  /// the language to use
  var language: W3WLanguage? { get }
  
}


extension W3WSuggestion {
  
  public var description: String {
    var retval = ""
    
    if let w = words {  retval += "\(w) " }
    if let c = country?.code {  retval += "\(c) " }
    if let n = nearestPlace {  retval += "\(n) " }
    if let d = distanceToFocus {  retval += "\(d) " }
    if let l = language?.locale ?? language?.code {  retval += "\(l) " }
    
    return retval.trimmingCharacters(in: .whitespaces)
  }
  
}


/// Suggestions returned from autosuggest API calls
public struct W3WBaseSuggestion: W3WSuggestion {

  /// three word address
  public let words: String?
  
  /// contains ISO 3166-1 alpha-2 country codes, such as US,CA
  public let country: W3WCountry?
  
  /// nearest place
  public let nearestPlace: String?
  
  /// distance from focus
  public let distanceToFocus: W3WDistance?
  
  /// the language to use
  public let language: W3WLanguage?
  
  
  public init(words: String? = nil, country: W3WCountry? = nil, nearestPlace: String? = nil, distanceToFocus: W3WDistance? = nil, language: W3WLanguage? = nil) {
    self.words = words
    self.country = country
    self.nearestPlace = nearestPlace
    self.distanceToFocus = distanceToFocus
    self.language = language
  }

}

