//
//  File.swift
//  
//
//  Created by Dave Duprey on 01/11/2022.
//

import MapKit


public protocol W3WPolygon {
  
  var points: [CLLocationCoordinate2D] { get set }
  
}


public struct W3WBasePolygon: W3WPolygon {
  
  public var points = [CLLocationCoordinate2D]()
  
}
