//
//  File.swift
//
//
//  Created by Dave Duprey on 14/01/2023.
//

import Foundation


#if !IMESSAGE
#if !os(watchOS)
#if canImport(w3w)
import w3w


extension What3Words: @retroactive W3WProtocolV4 {
    
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
      return  .language(try l.locale.count == 0 ? .init(l.code) : .init(l.locale))
    case .voiceLanguage(let l):
      return  .language(try l.locale.count == 0 ? .init(l.code) : .init(l.locale))
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
  
}


// MARK: - Added tool-calling convenience methods (throwing sync) used by tools

extension What3Words {
  
  // Converts words to coordinates via convertToSquare(words:)
  public func convertToCoordinates(words: String) throws -> CLLocationCoordinate2D? {
    let square = try convertToSquare(words: words)
    return square?.coordinates
  }
  
  // Returns words for a coordinate/language via convertToSquare(coordinates:language:)
  public func convertTo3wa(coordinates: CLLocationCoordinate2D, language: w3w.W3WSdkLanguage) throws -> String? {
    let square = try convertToSquare(coordinates: coordinates, language: language)
    return square?.words
  }
  
  // Deprecated convenience that constructs a W3WSdkLanguage and delegates
  @available(*, deprecated, message: "Use convertTo3wa(coordinates: CLLocationCoordinate2D, language: W3WSdkLanguage) instead")
  public func convertTo3wa(coordinates: CLLocationCoordinate2D, language: String) throws -> String? {
    let lang = try w3w.W3WSdkLanguage(language)
    let square = try convertToSquare(coordinates: coordinates, language: lang)
    return square?.words
  }
  
  // Autosuggest overloads that forward to the core throwing API
  public func autosuggest(text: String, options: [w3w.W3WSdkOption]? = nil) throws -> [w3w.W3WSdkSuggestion] {
    try autosuggest(text: text, options: options ?? [])
  }
  
  public func autosuggest(text: String, options: w3w.W3WSdkOptions?) throws -> [w3w.W3WSdkSuggestion] {
    let opts: [w3w.W3WSdkOption] = options?.options ?? []
    return try autosuggest(text: text, options: opts)
  }
  
  public func autosuggest(text: String, options: w3w.W3WSdkOption...) throws -> [w3w.W3WSdkSuggestion] {
    try autosuggest(text: text, options: options)
  }
  
  // Versions: if the SDK exposes version(module:) these simply forward.
  // If not, please share the underlying API and I’ll wire it up.
  public func version(module: w3w.W3WSdkModule = .swiftInterface) -> String {
    // Assumes What3Words already implements version(module:).
    // If not, provide the underlying API and we’ll delegate properly.
    return self.version(module: module)
  }
  
  @available(*, deprecated, message: "Use version(module: .data) instead")
  public func dataVersion() -> String {
    return self.version(module: .data)
  }
  
  // Grid section overloads
  public func gridSection(south: Double, west: Double, north: Double, east: Double) throws -> [w3w.W3WSdkLine]? {
    try gridSection(
      southWest: CLLocationCoordinate2D(latitude: south, longitude: west),
      northEast: CLLocationCoordinate2D(latitude: north, longitude: east)
    )
  }
  
  public func gridSection(bounds: w3w.W3WSdkBox) throws -> [w3w.W3WSdkLine]? {
    try gridSection(southWest: bounds.southWest, northEast: bounds.northEast)
  }
  
  // Languages
  public func availableLanguages() -> [w3w.W3WSdkLanguage] {
    return self.availableLanguages()
  }
  
  public func availableLanguages(voiceSupport: Bool) -> [w3w.W3WSdkLanguage] {
    // If you have a definitive "voice support" property on W3WSdkLanguage,
    // filter here. For now, return all languages.
    // Example when property becomes available:
    // let all = self.availableLanguages()
    // return voiceSupport ? all.filter { $0.supportsGenericVoice } : all
    return self.availableLanguages()
  }
  
  // Deprecated convertToSquare overload that accepts String language
  @available(*, deprecated, message: "Use convertToSquare(coordinates: CLLocationCoordinate2D, language: W3WSdkLanguage) instead")
  public func convertToSquare(coordinates: CLLocationCoordinate2D, language: String) throws -> w3w.W3WSdkSquare? {
    let lang = try w3w.W3WSdkLanguage(language)
    return try convertToSquare(coordinates: coordinates, language: lang)
  }
  
  // Extract 3was passthrough
  public func extract3was(text: String) -> [String] {
    return self.extract3was(text: text)
  }
}

#endif
#endif
#endif
