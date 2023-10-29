//
//  File.swift
//  
//
//  Created by Dave Duprey on 03/04/2023.
//

import CoreLocation


public protocol W3WUtilitiesProtocol {
}


public extension W3WUtilitiesProtocol {
  
  /// returns the distance in meters between two squares or nil if the points are bad
  func distance(from: W3WSquare?, to: W3WSquare?) -> Double? {
    return distance(from: from?.coordinates, to: to?.coordinates)
  }
  
  
  /// returns the distance in meters between two points or nil if the points are bad
  /// - parameter from: point to measure from
  /// - parameter to: point to measure to
  /// - returns distance in meters
  func distance(from: CLLocationCoordinate2D?, to: CLLocationCoordinate2D?) -> Double? {
    if let from = from, let to = to {
      let from = CLLocation(latitude: from.latitude, longitude: from.longitude)
      let to = CLLocation(latitude: to.latitude, longitude: to.longitude)
      return from.distance(from: to)
    } else {
      return nil
    }
  }
  
  
  /// Uses the regex to determine if a String fits the three word address form of three words in any language separated by two separator characters
  func isPossible3wa(text: String) -> Bool {
    return W3WRegex.isPossible3wa(text: text)
  }
  
  
  /// checks if input looks like a 3 word address or not
  func didYouMean(text: String) -> Bool {
    return W3WRegex.didYouMean(text: text)
  }
  
  
  /// searches a string for possible three word address matches
  func findPossible3wa(text: String) -> [String] {
    return W3WRegex.findPossible3wa(text: text)
  }

  
}
