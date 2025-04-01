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
  var id: Int64 {
      let sw = self.southWest
     let ne = self.northEast
//
      guard (-90...90).contains(sw.latitude), (-90...90).contains(ne.latitude) else {
          fatalError("Invalid latitude value: must be between -90 and 90")
      }
      guard (-180...180).contains(sw.longitude), (-180...180).contains(ne.longitude) else {
          fatalError("Invalid longitude value: must be between -180 and 180")
      }
//
      let swLatBits = Int64((sw.latitude * 1e6).rounded()) & 0x7FFFFFFF // 31 bits
      let swLngBits = Int64((sw.longitude * 1e6).rounded()) & 0x7FFFFFFF
      let neLatBits = Int64((ne.latitude * 1e6).rounded()) & 0x7FFFFFFF
      let neLngBits = Int64((ne.longitude * 1e6).rounded()) & 0x7FFFFFFF

      return (swLatBits << 48) | (swLngBits << 32) | (neLatBits << 16) | neLngBits
    
    //   let swLatBits = Int64((sw.latitude * 1e6).rounded()) & 0x7FFFF  // 15 bits
   //    let swLngBits = Int64((sw.longitude * 1e6).rounded()) & 0x7FFFF // 15 bits
    //   let neLatBits = Int64((ne.latitude * 1e6).rounded()) & 0x7FFFF  // 15 bits
   //    let neLngBits = Int64((ne.longitude * 1e6).rounded()) & 0x7FFFF // 15 bits

       // Shift by smaller amounts to avoid overflow
   //    return (swLatBits << 42) | (swLngBits << 28) | (neLatBits << 14) | neLngBits
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

