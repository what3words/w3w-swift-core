//
//  File.swift
//  
//
//  Created by Dave Duprey on 04/11/2022.
//

import CoreLocation



/// Protocol defining a W3W square
public protocol W3WSquare: W3WSuggestion, CustomStringConvertible {
  
  /// three word address
  var words: String? { get }

  /// contains ISO 3166-1 alpha-2 country codes, such as US,CA
  var country: W3WCountry? { get }
  
  /// nearest place
  var nearestPlace: String? { get }
  
  /// distance from focus in kilometers
  var distanceToFocus: W3WDistance? { get }
  
  /// the language to use
  var language: W3WLanguage? { get }
  
  /// coordinates of the square
  var coordinates: CLLocationCoordinate2D? { get }
  
  /// the square's bounds
  var bounds: W3WBaseBox? { get }
  
}


public extension W3WSquare {
  
  var description: String {
    var retval = ""
    
    if let w = words   {  retval += "\(w) " }
    if let c = country?.code {  retval += "\(c) " }
    if let n = nearestPlace {  retval += "\(n) " }
    if let d = distanceToFocus {  retval += "\(d) " }
    if let l = language?.locale ?? language?.code {  retval += "\(l) " }
    if let c = coordinates {  retval += "(\(c.latitude), \(c.longitude))" }
    
    return retval.trimmingCharacters(in: .whitespaces)
  }
  
}
  

/// Object representing a W3W square
public struct W3WBaseSquare: W3WSquare {
  
  public typealias W3WBaseCountry = W3WCountry
  public typealias W3WBaseDistance = W3WDistance
  public typealias W3WBaseLanguage = W3WLanguage

  /// three word address
  public var words: String?
  
  /// ISO 3166-1 alpha-2 country codes, such as US,CA
  public var country: W3WBaseCountry?
  
  /// nearest place
  public var nearestPlace: String?
  
  /// distance from focus in kilometers
  public var distanceToFocus: W3WBaseDistance?
  
  /// the language to use
  public var language: W3WBaseLanguage?
  
  /// coordinates of the square
  public var coordinates: CLLocationCoordinate2D?
  
  /// the square's bounds
  public var bounds: W3WBaseBox?
  
  
  public init(words: String? = nil, country: W3WBaseCountry? = nil, nearestPlace: String? = nil, distanceToFocus: W3WBaseDistance? = nil, language: W3WBaseLanguage? = nil, coordinates: CLLocationCoordinate2D? = nil, bounds: W3WBaseBox? = nil) {
    self.words = words
    self.country = country
    self.nearestPlace = nearestPlace
    self.distanceToFocus = distanceToFocus
    self.language = language
    self.coordinates = coordinates
    self.bounds = bounds
  }

  
}
