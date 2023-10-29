//
//  File.swift
//  
//
//  Created by Dave Duprey on 01/11/2022.
//

import MapKit


public protocol W3WPolygon {
  
  var points: [CLLocationCoordinate2D] { get set }
  
  // maybe SDK only?
  //func contains(point: CLLocationCoordinate2D) -> Bool
  
}


public struct W3WBasePolygon: W3WPolygon {
  
  public var points = [CLLocationCoordinate2D]()
  
  // maybe SDK only?
//  public func contains(point: CLLocationCoordinate2D) -> Bool {
//    var pJ=points.last!
//    var contains = false
//
//    for pI in points {
//      if ( ((pI.latitude >= point.latitude) != (pJ.latitude >= point.latitude)) && (point.longitude <= (pJ.longitude - pI.longitude) * (point.latitude - pI.latitude) / (pJ.latitude - pI.latitude) + pI.longitude) ){
//        contains = !contains
//      }
//      pJ=pI
//    }
//
//    return contains
//  }
  
}
