//
//  File.swift
//  
//
//  Created by Dave Duprey on 01/11/2022.
//

import CoreLocation


/// defines a geograpfical region
public protocol W3WCircle {
  var center: CLLocationCoordinate2D { get }
  var radius: W3WDistance { get }
}



/// defines a geographical region
public struct W3WBaseCircle: W3WCircle {
  public let center: CLLocationCoordinate2D
  public let radius: W3WDistance
  
  public init(center: CLLocationCoordinate2D, radius: W3WDistance) {
    self.center = center
    self.radius = radius
  }
}
