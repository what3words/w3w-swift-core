//
//  File.swift
//
//
//  Created by Dave Duprey on 14/01/2023.
//

import Foundation


#if canImport(w3w)
import w3w


extension What3Words: W3WProtocolV4 {
    
  /// Converts a 3 word address to a position, expressed as coordinates of latitude and longitude.
  /// - parameter coordinates: A CLLocationCoordinate2D object
  /// - parameter language: A supported 3 word address language as an [ISO 639-1](https://en.wikipedia.org/wiki/List_of_ISO_639-1_codes) 2 letter code. Defaults to "en"
  /// - parameter completion: code block whose parameters contain a W3WSquare and if any, an error
  public func convertTo3wa(coordinates: CLLocationCoordinate2D, language: String, completion: @escaping W3WSquareResponse) {
    do {
      if let square = try convertToSquare(coordinates: coordinates, language: W3WSdkLanguage(language)), square.words != nil {
        completion(square.asBaseSquare(), nil)
      } else {
        completion(nil, W3WError.message("No such three word address"))
      }
    } catch {
      completion(nil, W3WError.other(error))
    }
  }
  
  
  /// Converts a 3 word address to a position, expressed as coordinates of latitude and longitude.
  /// - parameter words: A 3 word address as a string
  /// - parameter completion: code block whose parameters contain a W3WSquare and if any, an error
  public func convertToCoordinates(words: String, completion: @escaping W3WSquareResponse) {
    do {
      if let square = try convertToSquare(words: words), square.coordinates != nil {
        completion(square.asBaseSquare(), nil)
      } else {
        completion(nil, W3WError.message("No such three word address"))
      }
    } catch {
      completion(nil, W3WError.other(error))
    }
  }
  
  
  /// Converts a 3 word address to a position, expressed as coordinates of latitude and longitude.
  /// - parameter coordinates: A CLLocationCoordinate2D object
  /// - parameter language: A supported 3 word address language as an [ISO 639-1](https://en.wikipedia.org/wiki/List_of_ISO_639-1_codes) 2 letter code. Defaults to "en"
  /// - parameter completion: code block whose parameters contain a W3WSquare and if any, an error
  public func convertTo3wa(coordinates: CLLocationCoordinate2D, language: W3WLanguage, completion: @escaping W3WSquareResponse) {
    do {
      if let square = try convertToSquare(coordinates: coordinates, language: W3WSdkLanguage(language.locale)), square.words != nil {
        completion(square.asBaseSquare(), nil)
      } else {
        completion(nil, W3WError.message("No such three word address"))
      }
    } catch {
      completion(nil, W3WError.other(error))
    }
  }

  
//  public func autosuggest(text: String, options: [W3WOption]?, completion: @escaping W3WSuggestionsResponse) {
//    autosuggest(text: text, options: options ?? [], completion: completion)
//  }
  
  
  /// Returns a list of 3 word addresses suggestions based on user input and other parameters.
  /// - parameter text: The full or partial 3 word address to obtain suggestions for. At minimum this must be the first two complete words plus at least one character from the third word.
  /// - parameter language: A supported 3 word address language as an [ISO 639-1](https://en.wikipedia.org/wiki/List_of_ISO_639-1_codes) 2 letter code. Defaults to "en"
  /// - parameter options: are provided as an array of W3SdkOption objects.
  /// - parameter completion: code block whose parameters contain an array of W3WSuggestions, and, if any, an error
  public func autosuggest(text: String, options: [W3WOption]?, completion: @escaping W3WSuggestionsResponse) {
    do {
      let coreOptions = try convert(from: options)
      let suggestions = try autosuggest(text: text, options: coreOptions)
      
      completion(suggestions.map { suggestion in return suggestion.asBaseSuggestion() }, nil)

    } catch {
      completion(nil, W3WError.other(error))
    }
  }
  
  
  /// Returns a list of 3 word addresses suggestions with lat,long coords based on user input and other parameters.
  /// - parameter text: The full or partial 3 word address to obtain suggestions for. At minimum this must be the first two complete words plus at least one character from the third word.
  /// - parameter language: A supported 3 word address language as an [ISO 639-1](https://en.wikipedia.org/wiki/List_of_ISO_639-1_codes) 2 letter code. Defaults to "en"
  /// - parameter options: are provided as an array of W3SdkOption objects.
  /// - parameter completion: code block whose parameters contain an array of W3WSuggestions, and, if any, an error
  public func autosuggestWithCoordinates(text: String, options: [W3WOption]?, completion: @escaping W3WSquaresResponse) {
    do {
      let coreOptions = try convert(from: options)
      let suggestions = try autosuggest(text: text, options: coreOptions)

      var squares = [W3WSquare]()
      for suggestion in suggestions {
        if let words = suggestion.words, let square = try? convertToSquare(words: words) {
          let square = square.asBaseSquare()
          squares.append(square)
        }
      }
      completion(squares, nil)

    } catch {
      completion(nil, W3WError.other(error))
    }
  }
  
  
  /// Returns a section of the 3m x 3m what3words grid for a given area.
  /// - parameter southWest: The southwest corner of the box
  /// - parameter northEast: The northeast corner of the box
  /// - parameter completion: code block whose parameters contain an array of W3WLines (in lat/long) for drawing the what3words grid over a map, and , if any, an error
  public func gridSection(southWest: CLLocationCoordinate2D, northEast: CLLocationCoordinate2D, completion: @escaping W3WGridResponse) {
    do {
      let grid = try gridSection(southWest: southWest, northEast: northEast)
      //let apiLineArray = grid?.map { line in return line.asW3WLine() }
      //completion(apiLineArray, nil)
      completion(grid, nil)
    } catch {
      completion([], W3WError.other(error))
    }
  }
  
  
  public func gridSection(south_lat: Double, west_lng: Double, north_lat: Double, east_lng: Double, completion: @escaping W3WGridResponse) {
    gridSection(southWest: CLLocationCoordinate2D(latitude: south_lat, longitude: west_lng), northEast: CLLocationCoordinate2D(latitude: north_lat, longitude: east_lng), completion: completion)
  }
  
  
  public func gridSection(bounds: W3WBox, completion: @escaping W3WGridResponse) {
    gridSection(southWest: bounds.southWest, northEast: bounds.northEast, completion: completion)
  }
  
  
  /// Retrieves a list of the currently loaded and available 3 word address languages.
  /// - parameter completion: code block whose parameters contain a list of the currently loaded and available 3 word address languages, and , if any, an error
  public func availableLanguages(completion: @escaping W3WLanguagesResponse) {
    //let list = availableLanguages().map { language in return language.asW3WLanguage() }
    completion(availableLanguages(), nil)
  }
  
                                     
  func convert(from: W3WOption) throws -> W3WSdkOption? {
    switch from {
    case .focus(let f):
      return .focus(f)
    case .language(let l):
      return .language(try .init(l.locale))
    case .voiceLanguage(let l):
      return  .language(try .init(l.locale))
    case .numberOfResults(let n):
      return .numberOfResults(n)
    case .numberFocusResults(let n):
      return .numberFocusResults(n)
    case .clipToCountry(let c):
      return .clip(to: try W3WSdkCountry(code: c.code))
    case .clipToCountries(let countries):
      return .clip(to: try W3WSdkCountries(countries: countries.countries.map( { c in try W3WSdkCountry(code: c.code) })))
    case .preferLand(let b):
      return .preferLand(b)
    case .clipToCircle(let c):
      return .clip(to: try W3WSdkCircle(center: c.center, radius: W3WSdkDistance(meters: c.radius.meters)))
    case .clipToBox(let b):
      return .clip(to: try W3WSdkBox(southWest: b.southWest, northEast: b.northEast))
    case .clipToPolygon(let p):
      return .clip(to: try W3WSdkPolygon(points: p.points))
    case .inputType(let i):
      //return .inputType(convert(from: i))
      return .inputType(.other(i.rawValue))
    }
  }
  
  
//  func convert(from: W3WInputType) -> W3WSdkInputType {
//    switch from {
//    case .text:
//      return .text
//    case .genericVoice:
//      return .genericVoice
//    case .mawdoo3:
//      return .mawdoo3
//    case .mihup:
//      return .mihup
//    case .nmdpAsr:
//      return .nmdpAsr
//    case .ocrSdk:
//      return .ocrSdk
//    case .speechmatics:
//      return .speechmatics
//    case .voconHybrid:
//      return .voconHybrid
//    default:
//      return .text
//    }
//  }
  
  
  func convert(from: [W3WOption]?) throws -> [W3WSdkOption] {
    var coreOptions = [W3WSdkOption]()
    
    do {
      for option in from ?? [] {
        if let o = try convert(from: option) {
          coreOptions.append(o)
        }
      }
      
    }
    
    return coreOptions
  }
  
  
  // MARK: Base options extension for SDK
  
  
#if canImport(W3WSwiftApi)

  
//  /// Returns a list of 3 word addresses based on user input and other parameters.
//  /// - parameter text: The full or partial 3 word address to obtain suggestions for. At minimum this must be the first two complete words plus at least one character from the third word.
//  /// - parameter options: are provided as an array of W3SdkOption objects.
//  /// - returns An array of W3WSuggestions
//  /// - throws W3WSdkError
//  public func autosuggest(text: String, options: [W3WOption]) throws -> [W3WSdkSuggestion] {
//    return try autosuggest(text: text, options: convert(from: options))
//  }
//  
//  /// Returns a list of 3 word addresses based on user input and other parameters.
//  /// - parameter text: The full or partial 3 word address to obtain suggestions for. At minimum this must be the first two complete words plus at least one character from the third word.
//  /// - parameter options: are provided in a W3SdkOptions object.
//  /// - returns An array of W3WSuggestions
//  /// - throws W3WSdkError
//  public func autosuggest(text: String, options: W3WOptions?) throws -> [W3WSdkSuggestion] {
//    return try autosuggest(text: text, options: convert(from: options?.options))
//  }
//
//  /// Returns a list of 3 word addresses based on user input and other parameters.
//  /// - parameter text: The full or partial 3 word address to obtain suggestions for. At minimum this must be the first two complete words plus at least one character from the third word.
//  /// - parameter options: a single W3WOption
//  /// - returns An array of W3WSuggestions
//  /// - throws W3WSdkError
//  public func autosuggest(text: String, options: W3WOption...) throws -> [W3WSdkSuggestion] {
//    return try autosuggest(text: text, options: convert(from: options))
//  }

#endif
  
}


#endif
