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
  public let words: String?
  
  /// ISO 3166-1 alpha-2 country codes, such as US,CA
  public let country: W3WBaseCountry?
  
  /// nearest place
  public let nearestPlace: String?
  
  /// distance from focus in kilometers
  public let distanceToFocus: W3WBaseDistance?
  
  /// the language to use
  public let language: W3WBaseLanguage?
  
  /// coordinates of the square
  public let coordinates: CLLocationCoordinate2D?
  
  /// the square's bounds
  public let bounds: W3WBaseBox?
  
  
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

public protocol W3WAppSquareProtocol: W3WSquare {
  /// Secondary address
  var secondaryAddress: String? { get }
  
  /// Secondary language
  var secondaryLanguage: W3WLanguage? { get }
  
  /// the squares's label
  var label: String? { get }
  
  /// If the square is saved
  var isSaved: Bool? { get }
  
  /// If the square is shared
  var isShared: Bool? { get }
  
  /// If the square is editable
  var isEditable: Bool? { get }
}

public struct W3WAppSquare: W3WAppSquareProtocol {
  /// three word address
  public let words: String?
  
  /// ISO 3166-1 alpha-2 country codes, such as US,CA
  public let country: W3WCountry?
  
  /// nearest place
  public let nearestPlace: String?
  
  /// distance from focus in kilometers
  public let distanceToFocus: W3WDistance?
  
  /// the language to use
  public let language: W3WLanguage?
  
  /// coordinates of the square
  public let coordinates: CLLocationCoordinate2D?
  
  /// the square's bounds
  public let bounds: W3WBaseBox?
  
  /// Secondary address
  public let secondaryAddress: String?
  
  /// Secondary language
  public let secondaryLanguage: W3WLanguage?
  
  /// the squares's label
  public let label: String?
  
  /// If the square is saved
  public let isSaved: Bool?
  
  /// If the square is shared
  public let isShared: Bool?
  
  /// If the square is editable
  public let isEditable: Bool?
  
  public init(
    words: String? = nil,
    secondaryAddress: String? = nil,
    country: W3WBaseCountry? = nil,
    nearestPlace: String? = nil,
    distanceToFocus: W3WBaseDistance? = nil,
    language: W3WBaseLanguage? = nil,
    secondaryLanguage: W3WBaseLanguage? = nil,
    coordinates: CLLocationCoordinate2D? = nil,
    bounds: W3WBaseBox? = nil,
    label: String? = nil,
    isSaved: Bool? = nil,
    isShared: Bool? = nil,
    isEditable: Bool? = nil
  ) {
    self.words = words
    self.secondaryAddress = secondaryAddress
    self.country = country
    self.nearestPlace = nearestPlace
    self.distanceToFocus = distanceToFocus
    self.language = language
    self.secondaryLanguage = secondaryLanguage
    self.coordinates = coordinates
    self.bounds = bounds
    self.label = label
    self.isSaved = isSaved
    self.isShared = isShared
    self.isEditable = isEditable
  }
}
