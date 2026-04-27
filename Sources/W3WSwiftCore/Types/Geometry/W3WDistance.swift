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
  
  
  func asString(format: W3WSeparatorsType? = .firstCommaSecondDot, system: W3WMeasurementSystem?) -> String {
    let theSystem = system ?? getDefaultMeasurementSystem()
    
    if case .metric = theSystem {
      return self.format(number: kilometers, format: format) + "km"
    }
    
    if case .imperial = theSystem {
      return self.format(number: miles, format: format) + "mi"
    }
    
    return self.format(number: kilometers, format: format) + "km"
  }
  
  
  private func format(number: Double, format: W3WSeparatorsType?) -> String {
    switch format {
      case .firstCommaSecondDot:
        return self.format(number: number, thousands: ",", decimal: ".")
      case .firstDotSecondComma:
        return self.format(number: number, thousands: ".", decimal: ",")
      case .firstSpaceSecondDot:
        return self.format(number: number, thousands: " ", decimal: ".")
      case .firstSpaceSecondComma:
        return self.format(number: number, thousands: " ", decimal: ",")
      case .firstWithoutSecondDot:
        return self.format(number: number, thousands: "", decimal: ".")
      case .firstWithoutSecondComma:
        return self.format(number: number, thousands: "", decimal: ",")
      case nil:
        return "MISSING CASE HERE" + #function
    }
  }
  
  
  // AI PRODUCED
  private func format(number: Double, thousands: String, decimal: Character) -> String {
    let n = round(number: number, significantDigits: 3)
    let roundedNumber = (n * 100).rounded() / 100
    let sign = roundedNumber < 0 ? "-" : ""
    let absoluteNumber = abs(Double(roundedNumber))
    let integerPart = Int(absoluteNumber)
    let fractionalPart = Int(((absoluteNumber - Double(integerPart)) * 100).rounded())

    let integerString = String(integerPart)
    var formattedInteger = ""

    for (index, character) in integerString.reversed().enumerated() {
      if !thousands.isEmpty, index > 0, index % 3 == 0 {
        formattedInteger = thousands + formattedInteger
      }
      formattedInteger.insert(character, at: formattedInteger.startIndex)
    }

    guard fractionalPart > 0 else {
      return sign + formattedInteger
    }

    let fractionString = String(format: "%02d", fractionalPart)
      .replacingOccurrences(of: "0+$", with: "", options: .regularExpression)

    return sign + formattedInteger + String(decimal) + fractionString
  }
  
  
  // AI PRODUCED
  private func round(number: Double, significantDigits: Int) -> Double {
    // Handle non-finite values by returning the input
    guard number.isFinite else { return number }

    // Normalize significant digits to at least 1
    let sig = max(1, significantDigits)

    let absNumber = abs(number)

    // Zero is a special case: it has no meaningful magnitude; return 0
    if absNumber == 0 { return 0 }

    // Compute number of digits in the integer part using log10 (for non-zero absNumber)
    // integerDigits = floor(log10(absNumber)) + 1
    let magnitude = floor(log10(absNumber))
    let integerDigits = Int(magnitude) + 1

    // Determine how many fractional digits are needed to satisfy significant digits
    let fractionalDigits = max(0, sig - max(1, integerDigits))

    // Round by scaling with 10^fractionalDigits
    let scale = pow(10.0, Double(fractionalDigits))
    let rounded = (number * scale).rounded() / scale

    return rounded
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
