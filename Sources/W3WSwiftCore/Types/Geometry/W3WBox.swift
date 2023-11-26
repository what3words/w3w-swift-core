//
//  File.swift
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


/// Helper object representing a W3W bounding box
public struct W3WBaseBox: W3WBox {
  public let southWest: CLLocationCoordinate2D
  public let northEast: CLLocationCoordinate2D
  
  public init(southWest: CLLocationCoordinate2D, northEast: CLLocationCoordinate2D) {
    self.southWest = southWest
    self.northEast = northEast
  }
}

