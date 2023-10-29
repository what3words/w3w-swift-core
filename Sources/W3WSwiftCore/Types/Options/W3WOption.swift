//
//  File.swift
//
//
//  Created by Dave Duprey on 07/11/2022.
//

import CoreLocation


public enum W3WOption {
  case language(W3WLanguage)
  case voiceLanguage(W3WLanguage)
  case numberOfResults(Int)
  case focus(CLLocationCoordinate2D)
  case numberFocusResults(Int)
  case inputType(W3WInputType)
  case clipToCountry(W3WCountry)
  case clipToCountries(W3WCountries)
  case preferLand(Bool)
  case clipToCircle(W3WCircle)
  case clipToBox(W3WBox)
  case clipToPolygon(W3WPolygon)
  
  static public func clip(to: W3WCountry)   -> W3WOption { return W3WOption.clipToCountry(to)   }
  static public func clip(to: W3WCountries) -> W3WOption { return W3WOption.clipToCountries(to) }
  static public func clip(to: W3WCircle)    -> W3WOption { return W3WOption.clipToCircle(to)    }
  static public func clip(to: W3WBox)       -> W3WOption { return W3WOption.clipToBox(to)       }
  static public func clip(to: W3WPolygon)   -> W3WOption { return W3WOption.clipToPolygon(to)   }

  // compatibility for v3
  static public func clipToBox(southWest: CLLocationCoordinate2D, northEast: CLLocationCoordinate2D) -> W3WOption { return W3WOption.clip(to: W3WBaseBox(southWest: southWest, northEast: northEast)) }
  static public func clipToCountries(_ countries: [String]) -> W3WOption { return W3WOption.clip(to: W3WBaseCountries(countries: countries.map { country in return W3WBaseCountry(code: country) })) }
  static public func clipToCircle(center: CLLocationCoordinate2D, radius: Double) -> W3WOption { return W3WOption.clip(to: W3WBaseCircle(center: center, radius: W3WBaseDistance(kilometers: radius))) }
  static public func clipToPolygon(_ polygon: [CLLocationCoordinate2D]) -> W3WOption { return W3WOption.clip(to: W3WBasePolygon(points: polygon)) }
  static public func language(_ language: String) -> W3WOption { return W3WOption.language(W3WBaseLanguage(locale: language)) }

  public func key() -> String {
    switch self {
    case .language:
      return "language"
    case .voiceLanguage:
      return "voice-language"
    case .numberOfResults:
      return "n-results"
    case .focus:
      return "focus"
    case .numberFocusResults:
      return "n-focus-results"
    case .inputType:
      return "input-type"
    case .clipToCountry:
      return "clip-to-country"
    case .clipToCountries:
      return "clip-to-country"
    case .preferLand:
      return "prefer-land"
    case .clipToCircle:
      return "clip-to-circle"
    case .clipToBox:
      return "clip-to-bounding-box"
    case .clipToPolygon:
      return "clip-to-polygon"
    }
  }
  
  
  public var description : String {
    return key() + ": " + asString()
  }
  
  
  public func forQueryString() -> String {
    switch self {
    case .language(let language):
      return language.code
    case .voiceLanguage(let language):
      return language.code
    case .numberOfResults(let n):
      return String(n)
    case .focus(let c):
      return "\(c.latitude),\(c.longitude)"
    case .numberFocusResults(let n):
      return String(n)
    case .inputType(let t):
      return t.description
    case .clipToCountry(let c):
      return c.code
    case .clipToCountries:
      return asStringArray().joined(separator: ",")
    case .preferLand(let pl):
      return pl ? "true" : "false"
    case .clipToCircle(let c):
      return "\(c.center.latitude),\(c.center.longitude),\(c.radius.kilometers)"
    case .clipToBox(let b):
      return "\(b.southWest.latitude),\(b.southWest.longitude),\(b.northEast.latitude),\(b.northEast.longitude)"
    case .clipToPolygon(let polygon):
      var polyCoords = [String]()
      for coord in polygon.points {
        polyCoords.append("\(coord.latitude),\(coord.longitude)")
      }
      return polyCoords.joined(separator: ",")
    }
  }
  
  
  public func asString() -> String {
    switch self {
    case .language(let language):
      return language.code
    case .voiceLanguage(let language):
      return language.code
    case .numberOfResults(let n):
      return String(n)
    case .focus(let c):
      return "\(c.latitude), \(c.longitude)"
    case .numberFocusResults(let n):
      return String(n)
    case .inputType(let t):
      return t.description
    case .clipToCountry(let c):
      return c.code
    case .clipToCountries:
      return asStringArray().joined(separator: ",")
    case .preferLand(let pl):
      return pl ? "true" : "false"
    case .clipToCircle(let c):
      return "(\(c.center.latitude), \(c.center.longitude)), \(c.radius)"
    case .clipToBox(let b):
      return "(\(b.southWest.latitude), \(b.southWest.longitude)), (\(b.northEast.latitude), \(b.northEast.longitude))"
//    case .clipToPolygon:
//      return "clip-to-polygon"
    case .clipToPolygon(let polygon):
      var polyCoords = [String]()
      for coord in polygon.points {
        polyCoords.append("\(coord.latitude),\(coord.longitude)")
      }
      return polyCoords.joined(separator: ",")
    }
  }
  
  
  public func asStringArray() -> [String] {
    switch self {
    case .language(let language):
      return [language.code]
    case .voiceLanguage(let language):
      return [language.code]
    case .numberOfResults(let n):
      return [String(n)]
    case .focus(let c):
      return ["\(c.latitude)", "\(c.longitude)"]
    case .numberFocusResults(let n):
      return [String(n)]
    case .inputType(let t):
      return [t.description]
    case .clipToCountry(let c):
      return [c.code]
    case .clipToCountries(let c):
      return (c.countries.map( { c in return c.code } ))
    case .preferLand(let pl):
      return pl ? ["true"] : ["false"]
    case .clipToCircle(let c):
      return ["(\(c.center.latitude), \(c.center.longitude))", "\(c.radius)"]
    case .clipToBox(let b):
      return ["(\(b.southWest.latitude)", "\(b.southWest.longitude))", "(\(b.northEast.latitude)", "\(b.northEast.longitude))"]
    case .clipToPolygon(let p):
      return p.points.map({ point in return "(\(point.latitude), \(point.longitude))" })
    }
  }
  
  
  public func asLanguage() -> W3WLanguage? {
    switch self {
    case .language(let language):
      return language
    default:
      return nil
    }
  }
}

//public struct W3WOption: CustomStringConvertible, Equatable {
//
//  public var key:   W3WOptionKey
//  public var value: W3WOptionValue
//
//
//  /// for Equatable
//  public static func == (lhs: W3WOption, rhs: W3WOption) -> Bool {
//    return lhs.value == rhs.value && lhs.key == rhs.key
//  }
//
//
//  public var description: String {
//    get {
//      return key.description + "=" + value.description
//    }
//  }
//
//
//  public init(key: W3WOptionKey, value: W3WOptionValue) {
//    self.key = key
//    self.value = value
//  }
//
//
//  public static func stringArrayToCountryArray(array: [String]) -> [W3WBaseCountry] {
//    var retval = [W3WBaseCountry]()
//    for a in array {
//      retval.append(W3WBaseCountry(code: a))
//    }
//    return retval
//  }
//
//
//  public static func numberOfResults(_ numberOfResults:Int)   -> W3WOption { return W3WOption(key: .numberOfResults, value: .integer(numberOfResults)) }
//  public static func inputType(_ inputType:W3WInputType)         -> W3WOption { return W3WOption(key: .inputType, value: .input(inputType)) }
//  public static func language(_ language: W3WBaseLanguage)         -> W3WOption { return W3WOption(key: .language, value: .language(language)) }
//  public static func voiceLanguage(_ voiceLanguage:W3WBaseLanguage)  -> W3WOption { return W3WOption(key: .language, value: .language(voiceLanguage)) }
//  public static func preferLand(_ preferLand:Bool)                    -> W3WOption { return W3WOption(key: .preferLand, value: .boolean(preferLand)) }
//  public static func focus(_ focus:CLLocationCoordinate2D)            -> W3WOption { return W3WOption(key: .focus, value: .coordinates(focus)) }
//  public static func numberFocusResults(_ numberFocusResults:Int)    -> W3WOption { return W3WOption(key: .numberFocusResults, value: .integer(numberFocusResults)) }
//  public static func clip(to country: any W3WCountry)               -> W3WOption { return W3WOption(key: .clipToCountry, value: .country(country)) }
//  public static func clip(to countries: [any W3WCountry])        -> W3WOption { return W3WOption(key: .clipToCountries, value: .countries(countries)) }
//  public static func clip(to polygon:W3WPolygon)              -> W3WOption { return W3WOption(key: .clipToPolygon, value: .polygon(polygon)) }
//  public static func clip(to circle: W3WCircle)           -> W3WOption { return W3WOption(key: .clipToCircle, value: .circle(circle)) }
//  public static func clip(to box: W3WBox)               -> W3WOption { return W3WOption(key: .clipToBox, value: .box(box)) }
//}



//public enum W3WOption {
//  case language(String)
//  case voiceLanguage(String)
//  case numberOfResults(Int)
//  case focus(CLLocationCoordinate2D)
//  case numberFocusResults(Int)
//  case inputType(W3WInputType)
//  case clipToCountry(String)
//  case clipToCountries([String])
//  case preferLand(Bool)
//  case clipToCircle(center:CLLocationCoordinate2D, radius: Double)
//  case clipToBox(southWest: CLLocationCoordinate2D, northEast: CLLocationCoordinate2D)
//  case clipToPolygon([CLLocationCoordinate2D])
//  case custom(String, String)
//}


///// conformity provides a way to return the values as the different possible types
//public protocol W3WOptionProtocol {
//  func key()     -> String
//  func asString()   -> String
//  func asBoolean()    -> Bool
//  func asStringArray() -> [String]
//  func asCoordinates()  -> CLLocationCoordinate2D
//  func asBoundingBox()   -> (CLLocationCoordinate2D, CLLocationCoordinate2D)
//  func asBoundingCircle() -> (CLLocationCoordinate2D, Double)
//  func asBoundingPolygon() -> [CLLocationCoordinate2D]
//}
//
//
///// parameter names for API calls
//public struct W3WOptionKey {
//  public static let language = "language"
//  public static let voiceLanguage = "voice-language"
//  public static let numberOfResults = "n-results"
//  public static let focus = "focus"
//  public static let numberFocusResults = "n-focus-results"
//  public static let inputType = "input-type"
//  public static let clipToCountry = "clip-to-country"
//  public static let clipToCountries = "clip-to-country"
//  public static let preferLand = "prefer-land"
//  public static let clipToCircle = "clip-to-circle"
//  public static let clipToBox = "clip-to-bounding-box"
//  public static let clipToPolygon = "clip-to-polygon"
//}
//
//
//public enum W3WOption: W3WOptionProtocol {
//  case language(String)
//  case voiceLanguage(String)
//  case numberOfResults(Int)
//  case focus(CLLocationCoordinate2D)
//  case numberFocusResults(Int)
//  case inputType(W3WInputType)
//  case clipToCountry(String)
//  case clipToCountries([String])
//  case preferLand(Bool)
//  case clipToCircle(center:CLLocationCoordinate2D, radius: Double)
//  case clipToBox(southWest: CLLocationCoordinate2D, northEast: CLLocationCoordinate2D)
//  case clipToPolygon([CLLocationCoordinate2D])
//
//  public func key() -> String {
//    switch self {
//    case .language:
//      return W3WOptionKey.language
//    case .voiceLanguage:
//      return W3WOptionKey.voiceLanguage
//    case .numberOfResults:
//      return W3WOptionKey.numberOfResults
//    case .focus:
//      return W3WOptionKey.focus
//    case .numberFocusResults:
//      return W3WOptionKey.numberFocusResults
//    case .inputType:
//      return W3WOptionKey.inputType
//    case .clipToCountry:
//      return W3WOptionKey.clipToCountry
//    case .clipToCountries:
//      return W3WOptionKey.clipToCountries
//    case .preferLand:
//      return W3WOptionKey.preferLand
//    case .clipToCircle:
//      return W3WOptionKey.clipToCircle
//    case .clipToBox:
//      return W3WOptionKey.clipToBox
//    case .clipToPolygon:
//      return W3WOptionKey.clipToPolygon
//    }
//  }
//
//  public func asString() -> String {
//    switch self {
//    case .language(let language):
//      return language
//    case .voiceLanguage(let voiceLanguage):
//      return voiceLanguage
//    case .numberOfResults(let numberOfResults):
//      return "\(numberOfResults)"
//    case .focus(let focus):
//      return String(format: "%.10f,%.10f", focus.latitude, focus.longitude)
//    case .numberFocusResults(let numberFocusResults):
//      return "\(numberFocusResults)"
//    case .inputType(let inputType):
//      return inputType.description
//    case .clipToCountry(let clipToCountry):
//      return clipToCountry
//    case .clipToCountries(let countries):
//      return countries.joined(separator: ",")
//    case .preferLand(let preferLand):
//      return preferLand ? "true" : "false"
//    case .clipToCircle(let center, let radius):
//      return String(format: "%.10f,%.10f,%.5f", center.latitude, center.longitude, radius)
//    case .clipToBox(let southWest, let northEast):
//      return String(format: "%.10f,%.10f,%.10f,%.10f", southWest.latitude, southWest.longitude, northEast.latitude, northEast.longitude)
//    case .clipToPolygon(let polygon):
//      var polyCoords = [String]()
//      for coord in polygon {
//        polyCoords.append("\(coord.latitude),\(coord.longitude)")
//      }
//      return polyCoords.joined(separator: ",")
//    }
//  }
//
//
//  public func asStringArray() -> [String] {
//    switch self {
//    case .clipToCountries(let countries):
//      return countries
//    default:
//      return [asString()]
//    }
//  }
//
//
//  public func asCoordinates() -> CLLocationCoordinate2D {
//    switch self {
//    case .focus(let focus):
//      return focus
//    case .clipToCircle(let center, _):
//      return center
//    default:
//      return CLLocationCoordinate2D()
//    }
//  }
//
//
//  public func asBoolean() -> Bool {
//    switch self {
//    case .preferLand(let preference):
//      return preference
//    default:
//      return false
//    }
//  }
//
//
//  public func asBoundingBox() -> (CLLocationCoordinate2D, CLLocationCoordinate2D) {
//    switch self {
//    case .clipToBox(let northEast, let southWest):
//      return (northEast, southWest)
//    default:
//      return (CLLocationCoordinate2D(), CLLocationCoordinate2D())
//    }
//  }
//
//
//  public func asBoundingCircle() -> (CLLocationCoordinate2D, Double) {
//    switch self {
//    case .clipToCircle(let center, let radius):
//      return (center, radius)
//    default:
//      return (CLLocationCoordinate2D(), 0.0)
//    }
//  }
//
//
//  public func asBoundingPolygon() -> [CLLocationCoordinate2D] {
//    switch self {
//    case .clipToPolygon(let polygon):
//      return polygon
//    default:
//      return [CLLocationCoordinate2D]()
//    }
//  }
//}
