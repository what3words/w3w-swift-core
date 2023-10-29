//
//  File.swift
//  
//
//  Created by Dave Duprey on 01/11/2022.
//

import CoreLocation


/// represents a W3W grid line
public protocol W3WLine: CustomStringConvertible {
  var start:CLLocationCoordinate2D { get }
  var end:CLLocationCoordinate2D { get }
}


/// Helper object representing a W3W grid line
public struct W3WBaseLine: W3WLine {
  public var start:CLLocationCoordinate2D
  public var end:CLLocationCoordinate2D
  
  public init(start: CLLocationCoordinate2D, end: CLLocationCoordinate2D) {
    self.start = start
    self.end = end
  }
  
}


public extension W3WLine {

  var description: String {
    return "(\(start.latitude),\(start.longitude)) -> (\(end.latitude),\(end.longitude))"
  }
  
}
