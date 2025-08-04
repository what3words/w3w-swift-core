//
//  File.swift
//  
//
//  Created by Dave Duprey on 31/10/2022.
//

import MapKit


public protocol W3WDistance: CustomStringConvertible {
  var meters: Double { get set }

  init(meters: Double)
  init(kilometers: Double)
  init(floatLiteral value: Float)
  init(miles: Double)
  init(feet: Double)
  init(nauticalMiles: Double)
  init(yards: Double)
  init(furlongs: Double)
  init(inches: Double)

  var miles:          Double { get }
  var feet:           Double { get }
  var kilometers:     Double { get }
  var nauticalMiles:  Double { get }
  var yards:          Double { get }
  var furlongs:       Double { get }
  var inches:         Double { get }
}


public extension W3WDistance {
  var miles:          Double { get { return convert(to: .miles) } }
  var feet:           Double { get { return convert(to: .feet) } }
  var kilometers:     Double { get { return convert(to: .kilometers) } }
  var nauticalMiles:  Double { get { return convert(to: .nauticalMiles) } }
  var yards:          Double { get { return convert(to: .yards) } }
  var furlongs:       Double { get { return convert(to: .furlongs) } }
  var inches:         Double { get { return convert(to: .inches) } }
  
  
  func convert(to: UnitLength) -> Double {
    return Measurement(value: meters, unit: UnitLength.meters).converted(to: to).value
  }
  
  
  func convert(value: Double, from: UnitLength) -> Double {
    return Measurement(value: value, unit: from).converted(to: .meters).value
  }
  
  
  func distanceInMeters(from: CLLocationCoordinate2D?, to: CLLocationCoordinate2D?) -> Double? {
    if let from = from, let to = to {
      
      let from = CLLocation(latitude: from.latitude, longitude: from.longitude)
      let to = CLLocation(latitude: to.latitude, longitude: to.longitude)
      
      return from.distance(from: to)
    }
    
    return nil
  }
  
  /// 12,000km or 12,000mi, etc...
  var description: String {
    let mileSuffix = "mi"
    let kmSuffix = "km"
    var suffix = ""
    var finalDistance: Double = 0.0
    switch W3WSettings.measurement {
    case .imperial:
      suffix = mileSuffix
      finalDistance = miles
    case .metric:
      suffix = kmSuffix
      finalDistance = kilometers
    case .system:
      suffix = getDefaultMeasurementSystem() == .imperial ? mileSuffix : kmSuffix
      finalDistance = getDefaultMeasurementSystem() == .imperial ? miles : kilometers
    }
    
    if finalDistance < 0.01 {
      return "<" + W3WSettings.separatorType.getFormattedString(for: 0.01) + suffix
    }
    
    if finalDistance >= 1 {
      return W3WSettings.separatorType.getFormattedString(for: finalDistance.rounded()) + suffix
    }
    
    var stringFinalDistance = W3WSettings.separatorType.getFormattedString(for: finalDistance)
    if stringFinalDistance.count > 4 {
      stringFinalDistance = String(stringFinalDistance.prefix(4))
    }
    return stringFinalDistance + suffix
  }
  
  
  func getDefaultMeasurementSystem() -> W3WMeasurementSystem {
    var system = W3WMeasurementSystem.metric
    
    // iOS 10 and later has a default
    if #available(iOS 10.0, *) {
      if NSLocale().usesMetricSystem == true {
        system = .metric
      } else {
        system = .imperial
      }
    }
    
    return system
  }
  
}


// stored as meters
public struct W3WBaseDistance: W3WDistance, ExpressibleByFloatLiteral {

  /// the distance in meters
  public var meters: Double = 0.0

  public init(meters: Double) { self.meters = meters }
  
  public init(floatLiteral value: Float) { self.meters = Double(value) }

  public init(kilometers: Double)     { self.meters = convert(value: kilometers, from: .kilometers)}
  public init(miles: Double)          { self.meters = convert(value: miles, from: .miles) }
  public init(feet: Double)           { self.meters = convert(value: feet, from: .feet) }
  public init(nauticalMiles: Double)  { self.meters = convert(value: nauticalMiles, from: .nauticalMiles) }
  public init(yards: Double)          { self.meters = convert(value: yards, from: .yards) }
  public init(furlongs: Double)       { self.meters = convert(value: furlongs, from: .furlongs) }
  public init(inches: Double)         { self.meters = convert(value: inches, from: .inches) }
  
  public init(from: CLLocationCoordinate2D?, to: CLLocationCoordinate2D?) {
    self.meters = distanceInMeters(from: from, to: to) ?? 0.0
  }

  static public let zero          = 0.0
  static public let circumference = 40075017.0
}
