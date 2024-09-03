//
//  File.swift
//  
//
//  Created by Dave Duprey on 20/04/2022.
//

import Foundation
import CoreLocation


/// Holds location and hearding along with accuracy values
public struct W3WGpsReading: CustomStringConvertible {
  
  /// the device's heading
  public var heading: Double?
  
  /// accuracy of the device heading in degrees
  public var headdingAccuracy: Double?
  
  /// the current location
  public var location: CLLocationCoordinate2D?
  
  /// the accuracy of the current location in meters
  public var accuracy: W3WDistance?

  
  public init() {
    self.heading = nil
    self.headdingAccuracy = nil
    self.location = nil
    self.accuracy = nil
  }
  
  
  public var description: String {
    get {
      return "\(location?.latitude ?? Double.nan), \(location?.longitude ?? Double.nan), ±\(String(describing: accuracy))"
    }
  }

  
}
