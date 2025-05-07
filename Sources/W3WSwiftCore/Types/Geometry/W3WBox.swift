//
//  W3WBox.swift
//
//
//  Created by Dave Duprey on 01/11/2022.
//

import CoreLocation


/// defines a geograpfical region
public protocol W3WBox {
  var southWest: CLLocationCoordinate2D { get }
  var northEast: CLLocationCoordinate2D { get }
}

public extension W3WBox {
  /// Unique ID of the bounds

//  var id: Int64 {
//        let sw = self.southWest
//        let ne = self.northEast
//        guard (-90...90).contains(sw.latitude), (-90...90).contains(ne.latitude) else {
//            fatalError("Invalid latitude value: must be between -90 and 90")
//        }
//        guard (-180...180).contains(sw.longitude), (-180...180).contains(ne.longitude) else {
//            fatalError("Invalid longitude value: must be between -180 and 180")
//        }
//        let swLatBits = Int64((sw.latitude * 1e6).rounded()) & 0x7FFFFFFF
//        let swLngBits = Int64((sw.longitude * 1e6).rounded()) & 0x7FFFFFFF
//        let neLatBits = Int64((ne.latitude * 1e6).rounded()) & 0x7FFFFFFF
//        let neLngBits = Int64((ne.longitude * 1e6).rounded()) & 0x7FFFFFFF
//    
//        return (swLatBits << 48) | (swLngBits << 32) | (neLatBits << 16) | neLngBits
//    }
  
  var id: Int64 {
      let sw = self.southWest
      let ne = self.northEast

      guard (-90...90).contains(sw.latitude), (-90...90).contains(ne.latitude) else {
          fatalError("Invalid latitude value: must be between -90 and 90")
      }
      guard (-180...180).contains(sw.longitude), (-180...180).contains(ne.longitude) else {
          fatalError("Invalid longitude value: must be between -180 and 180")
      }

      // Round to 5 decimal places to handle tiny precision differences
      let precision = 1e5 // 5 decimal places instead of 6
      
      // Round the values to fixed precision before calculations
      let swLat = (sw.latitude * precision).rounded() / precision
      let swLng = (sw.longitude * precision).rounded() / precision
      let neLat = (ne.latitude * precision).rounded() / precision
      let neLng = (ne.longitude * precision).rounded() / precision
      
      // Calculate width and height with rounded values
      let width = Int64(((neLng - swLng) * 1e6).rounded())
      let height = Int64(((neLat - swLat) * 1e6).rounded())
      
      // Calculate center point with rounded values
      let centerLat = Int64((((swLat + neLat) / 2) * 1e6).rounded())
      let centerLng = Int64((((swLng + neLng) / 2) * 1e6).rounded())
      
      // Prime numbers for better distribution
      let p1: Int64 = 73856093
      let p2: Int64 = 19349663
      let p3: Int64 = 83492791
      
      // Create a spatial hash using the center point and dimensions
      var hash: Int64 = (centerLat * p1) ^ (centerLng * p2) ^ (width * p3) ^ (height * p1)
      
      // Handle negative values
      if hash < 0 {
          hash = abs(hash)
      }
      
      return hash
  }
  
}
	

/// Helper object representing a W3W bounding box
public struct W3WBaseBox: W3WBox {
  public let southWest: CLLocationCoordinate2D
  public let northEast: CLLocationCoordinate2D
  
  public init(southWest: CLLocationCoordinate2D, northEast: CLLocationCoordinate2D) {
    self.southWest = southWest
    self.northEast = northEast
  }
}

