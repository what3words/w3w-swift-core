//
//  W3WSdkOptions.swift
//  what3words
//
//  Created by Dave Duprey on 04/11/2022.
//  Copyright © 2022 what3words. All rights reserved.
//

import CoreLocation


public class W3WOptions {
  
  public var options = [W3WOption]()
  
  public init() {}
  
  public init(options: [W3WOption]) {
    self.options = options
  }
  
  public func numberOfResults(_ numberOfResults:Int)    -> W3WOptions { options.append(W3WOption.numberOfResults(numberOfResults)); return self }
  public func inputType(_ inputType:W3WInputType)          -> W3WOptions { options.append(W3WOption.inputType(inputType)); return self }
  public func language(_ language:W3WBaseLanguage)           -> W3WOptions { options.append(W3WOption.language(language)); return self }
  public func voiceLanguage(_ voiceLanguage:W3WBaseLanguage)  -> W3WOptions { options.append(W3WOption.voiceLanguage(voiceLanguage)); return self }
  public func preferLand(_ preferLand:Bool)                  -> W3WOptions { options.append(W3WOption.preferLand(preferLand)); return self }
  public func focus(_ focus:CLLocationCoordinate2D)         -> W3WOptions { options.append(W3WOption.focus(focus)); return self }
  public func numberFocusResults(_ numberFocusResults:Int) -> W3WOptions { options.append(W3WOption.numberFocusResults(numberFocusResults)); return self }
  public func clip(to country: W3WBaseCountry)             -> W3WOptions { options.append(W3WOption.clip(to: country)); return self }
  public func clip(to countries: W3WBaseCountries)        -> W3WOptions { options.append(W3WOption.clip(to: countries)); return self }
  public func clip(to polygon: W3WBasePolygon)          -> W3WOptions { options.append(W3WOption.clip(to: polygon)); return self }
  public func clip(to circle: W3WBaseCircle)          -> W3WOptions { options.append(W3WOption.clip(to: circle)); return self }
  public func clip(to box: W3WBaseBox)             -> W3WOptions { options.append(W3WOption.clip(to: box)); return self }
  
  static public func numberOfResults(_ numberOfResults:Int)    -> W3WOptions { return W3WOptions().numberOfResults(numberOfResults) }
  static public func inputType(_ inputType:W3WInputType)          -> W3WOptions { return W3WOptions().inputType(inputType) }
  static public func language(_ language:W3WBaseLanguage)           -> W3WOptions { return W3WOptions().language(language) }
  static public func voiceLanguage(_ voiceLanguage:W3WBaseLanguage)  -> W3WOptions { return W3WOptions().voiceLanguage(voiceLanguage) }
  static public func preferLand(_ preferLand:Bool)                  -> W3WOptions { return W3WOptions().preferLand(preferLand) }
  static public func focus(_ focus:CLLocationCoordinate2D)         -> W3WOptions { return W3WOptions().focus(focus) }
  static public func numberFocusResults(_ numberFocusResults:Int) -> W3WOptions { return W3WOptions().numberFocusResults(numberFocusResults) }
  static public func clip(to country: W3WBaseCountry)             -> W3WOptions { return W3WOptions().clip(to: country) }
  static public func clip(to countries: W3WBaseCountries)        -> W3WOptions { return W3WOptions().clip(to: countries) }
  static public func clip(to polygon: W3WBasePolygon)          -> W3WOptions { return W3WOptions().clip(to: polygon) }
  static public func clip(to circle: W3WBaseCircle)          -> W3WOptions { return W3WOptions().clip(to: circle) }
  static public func clip(to box: W3WBaseBox)             -> W3WOptions { return W3WOptions().clip(to: box) }
}



//public struct W3WSdkOptionKey {
//  public static let language = "language"
//  public static let voiceLanguage = "voice-language"
//  public static let numberOfResults = "n-results"
//  public static let focus = "focus"
//  public static let numberFocusResults = "n-focus-results"
//  public static let inputType = "input-type"
//  public static let clipToCountry = "clip-to-country"
//  public static let preferLand = "prefer-land"
//  public static let clipToCircle = "clip-to-circle"
//  public static let clipToBox = "clip-to-bounding-box"
//  public static let clipToPolygon = "clip-to-polygon"
//}
//
//
//public enum W3WSdkOption {
//  case language(String)
//  case voiceLanguage(String)
//  case numberOfResults(Int)
//  case focus(CLLocationCoordinate2D)
//  case numberFocusResults(Int)
//  case inputType(W3WSdkInputType)
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
//      return W3WSdkOptionKey.language
//    case .voiceLanguage:
//      return W3WSdkOptionKey.voiceLanguage
//    case .numberOfResults:
//      return W3WSdkOptionKey.numberOfResults
//    case .focus:
//      return W3WSdkOptionKey.focus
//    case .numberFocusResults:
//      return W3WSdkOptionKey.numberFocusResults
//    case .inputType:
//      return W3WSdkOptionKey.inputType
//    case .clipToCountry:
//      return W3WSdkOptionKey.clipToCountry
//    case .clipToCountries:
//      return W3WSdkOptionKey.clipToCountry
//    case .preferLand:
//      return W3WSdkOptionKey.preferLand
//    case .clipToCircle:
//      return W3WSdkOptionKey.clipToCircle
//    case .clipToBox:
//      return W3WSdkOptionKey.clipToBox
//    case .clipToPolygon:
//      return W3WSdkOptionKey.clipToPolygon
//    }
//  }
//
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
//      return inputType.rawValue
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
//
//
//}
//
//
//
//public class W3WSdkOptions {
//
//  public var options = [W3WSdkOption]()
//
//  public init() {}
//
//  public func language(_ language:String)            -> W3WSdkOptions { options.append(W3WSdkOption.language(language)); return self }
//  public func voiceLangauge(_ voiceLangauge:String)  -> W3WSdkOptions { options.append(W3WSdkOption.voiceLanguage(voiceLangauge)); return self }
//  public func numberOfResults(_ numberOfResults:Int)  -> W3WSdkOptions { options.append(W3WSdkOption.numberOfResults(numberOfResults)); return self }
//  public func inputType(_ inputType:W3WSdkInputType)    -> W3WSdkOptions { options.append(W3WSdkOption.inputType(inputType)); return self }
//  public func clipToCountry(_ clipToCountry:String)        -> W3WSdkOptions { options.append(W3WSdkOption.clipToCountry(clipToCountry)); return self }
//  public func preferLand(_ preferLand:Bool)                      -> W3WSdkOptions { options.append(W3WSdkOption.preferLand(preferLand)); return self }
//  public func focus(_ focus:CLLocationCoordinate2D)                      -> W3WSdkOptions { options.append(W3WSdkOption.focus(focus)); return self }
//  public func numberFocusResults(_ numberFocusResults:Int)                      -> W3WSdkOptions { options.append(W3WSdkOption.numberFocusResults(numberFocusResults)); return self }
//  public func clipToPolygon(_ clipToPolygon:[CLLocationCoordinate2D])                 -> W3WSdkOptions { options.append(W3WSdkOption.clipToPolygon(clipToPolygon)); return self }
//  public func clipToCircle(center: CLLocationCoordinate2D, radius: Double)                -> W3WSdkOptions { options.append(W3WSdkOption.clipToCircle(center: center, radius: radius)); return self }
//  public func clipToBox(southWest:CLLocationCoordinate2D, northEast:CLLocationCoordinate2D) -> W3WSdkOptions { options.append(W3WSdkOption.clipToBox(southWest: southWest, northEast: northEast)); return self }
//}
//
