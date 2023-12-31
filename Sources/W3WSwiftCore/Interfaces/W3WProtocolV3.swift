//
//  File.swift
//
//
//  Created by Dave Duprey on 04/11/2022.
//

import CoreLocation


// MARK: what3words interface


public protocol W3WProtocolV3: W3WUtilitiesProtocol {

  
  /**
   Converts a 3 word address to a position, expressed as coordinates of latitude and longitude.
   - parameter words: A 3 word address as a string
   - parameter format: Return data format type; can be one of json (the default) or geojson
   - parameter completion: A W3ResponsePlace completion handler
   */
  func convertToCoordinates(words: String, completion: @escaping W3WSquareResponse)
  
  
  /**
   Returns a three word address from a latitude and longitude
   - parameter coordinates: A CLLocationCoordinate2D object
   - parameter language: A supported 3 word address language as an ISO 639-1 2 letter code. Defaults to en
   - parameter format: Return data format type; can be one of json (the default) or geojson
   - parameter completion: A W3ResponsePlace completion handler
   */
  func convertTo3wa(coordinates: CLLocationCoordinate2D, language: String, completion: @escaping W3WSquareResponse)
  
  
  /**
   Returns a list of 3 word addresses based on user input and other parameters.
   - parameter input: The full or partial 3 word address to obtain suggestions for. At minimum this must be the first two complete words plus at least one character from the third word.
   - options are provided by instantiating W3Option objects in the varidic length parameter list.  Eg:
   */
  func autosuggest(text: String, options: [W3WOptionProtocol], completion: @escaping W3WSuggestionsResponse)
  
  
  /**
   Convenience functions to allow different uses of options
   */
  func autosuggest(text: String, options: W3WOptionProtocol..., completion: @escaping W3WSuggestionsResponse)
  func autosuggest(text: String, completion: @escaping W3WSuggestionsResponse)
  
  
  /**
   Returns a list of 3 word addresses based on user input and other parameters, including coordinates of each suggestion
   - parameter input: The full or partial 3 word address to obtain suggestions for. At minimum this must be the first two complete words plus at least one character from the third word.
   - options are provided by instantiating W3Option objects in the varidic length parameter list.  Eg:
   */
  func autosuggestWithCoordinates(text: String, options: [W3WOptionProtocol], completion: @escaping W3WSuggestionsWithCoordinatesResponse)
  
  
  /**
   Convenience functions to allow different uses of options
   */
  func autosuggestWithCoordinates(text: String, options: W3WOptionProtocol..., completion: @escaping W3WSuggestionsWithCoordinatesResponse)
  func autosuggestWithCoordinates(text: String, completion: @escaping W3WSuggestionsWithCoordinatesResponse)
  
  
  /**
   Returns a section of the 3m x 3m what3words grid for a given area.
   - parameter bounding-box: Bounding box, as a lat,lng,lat,lng, for which the grid should be returned. The requested box must not exceed 4km from corner to corner, or a BadBoundingBoxTooBig error will be returned. Latitudes must be >= -90 and <= 90, but longitudes are allowed to wrap around 180. To specify a bounding-box that crosses the anti-meridian, use longitude greater than 180. Example value: "50.0,179.995,50.01,180.0005" .
   - parameter format: Return data format type; can be one of json (the default) or geojson Example value:format=Format.json
   - parameter completion: A W3wGeocodeResponseHandler completion handler
   */
  func gridSection(south_lat:Double, west_lng:Double, north_lat:Double, east_lng:Double, completion: @escaping W3WGridResponse)
  
  /**
   Returns a section of the 3m x 3m what3words grid for a given area.
   - parameter southWest: The southwest corner of the box
   - parameter northEast: The northeast corner of the box
   - parameter format: Return data format type; can be one of json (the default) or geojson Example value:format=Format.json
   - parameter completion: A W3wGeocodeResponseHandler completion handler
   */
  func gridSection(southWest:CLLocationCoordinate2D, northEast:CLLocationCoordinate2D, completion: @escaping W3WGridResponse)
  
  /**
   Retrieves a list of the currently loaded and available 3 word address languages.
   - parameter completion: A W3wGeocodeResponseHandler completion handler
   */
  func availableLanguages(completion: @escaping W3WLanguagesResponse)
  
  /**
   Checks to see if the text follows the form of a three word address via regex, that is,
   a word followed by a separator followed by a word followed by a separator followed by
   a word.  A word is defined as series of letters that belong to any writing system.
   This does not validate the address as being a real location on the earth, just that
   it follows the textual form of one.  For example, xx.xx.xx would pass this test eeven
   though it is not a valid address.
   - parameter text: A string holding the potential address to verify
   */
  func isPossible3wa(text: String) -> Bool
  
  /**
   Finds any number of possible three word addresses in a block of text. The term "possible
   three word addresses" refers to text that matches the regex used in isPossible3wa(), that
   is, these are pieces of text that appear to be three word address, but have not been veified
   against the engine as actually representing an actual place on earth.
   - parameter text: The text to search through
   */
  func findPossible3wa(text: String) -> [String]
  
  /**
   Verifies that the text is a valid three word address that successfully represents a square on earth.
   - parameter text: The text to search through
   - parameter completion: returns true if the address is a real three word address
   */
  func isValid3wa(words: String, completion: @escaping (Bool) -> ())
}


/// automatically make any class that confirms accept the different types of Option parameters
extension W3WProtocolV3 {
  public func autosuggest(text: String, options: W3WOptionProtocol..., completion: @escaping W3WSuggestionsResponse) {
    autosuggest(text: text, options: options, completion: completion)
  }
  
  public func autosuggest(text: String, completion: @escaping W3WSuggestionsResponse) {
    autosuggest(text: text, options: [], completion: completion)
  }
  
  public func autosuggest(text: String, options: W3WOptions, completion: @escaping W3WSuggestionsResponse) {
    autosuggest(text: text, options: options.options, completion: completion)
  }
  
  public func autosuggestWithCoordinates(text: String, options: W3WOptionProtocol..., completion: @escaping W3WSuggestionsWithCoordinatesResponse) {
    autosuggestWithCoordinates(text: text, options: options, completion: completion)
  }
  
  public func autosuggestWithCoordinates(text: String, completion: @escaping W3WSuggestionsWithCoordinatesResponse) {
    autosuggestWithCoordinates(text: text, options: [], completion: completion)
  }
  
  public func autosuggestWithCoordinates(text: String, options: W3WOptions, completion: @escaping W3WSuggestionsWithCoordinatesResponse) {
    autosuggestWithCoordinates(text: text, options: options.options, completion: completion)
  }
  
  
}


//public protocol W3WProtocolV3: W3WUtilitiesProtocol {
//
//  /**
//   Converts a 3 word address to a position, expressed as coordinates of latitude and longitude.
//   - parameter words: A 3 word address as a string
//   - parameter format: Return data format type; can be one of json (the default) or geojson
//   - parameter completion: A W3ResponsePlace completion handler
//   */
//  func convertToCoordinates(words: String, completion: @escaping W3WSquareResponse)
//
//
//  /**
//   Returns a three word address from a latitude and longitude
//   - parameter coordinates: A CLLocationCoordinate2D object
//   - parameter language: A supported 3 word address language as an ISO 639-1 2 letter code. Defaults to en
//   - parameter format: Return data format type; can be one of json (the default) or geojson
//   - parameter completion: A W3ResponsePlace completion handler
//   */
//  func convertTo3wa(coordinates: CLLocationCoordinate2D, language: String, completion: @escaping W3WSquareResponse)
//
//
//  /**
//   Returns a list of 3 word addresses based on user input and other parameters.
//   - parameter input: The full or partial 3 word address to obtain suggestions for. At minimum this must be the first two complete words plus at least one character from the third word.
//   - options are provided by instantiating W3Option objects in the varidic length parameter list.  Eg:
//   */
//  func autosuggest(text: String, options: [W3WOption], completion: @escaping W3WSuggestionsResponse)
//
//
//  /**
//   Convenience functions to allow different uses of options
//   */
//  func autosuggest(text: String, options: W3WOption..., completion: @escaping W3WSuggestionsResponse)
//  func autosuggest(text: String, completion: @escaping W3WSuggestionsResponse)
//
//
//  /**
//   Returns a list of 3 word addresses based on user input and other parameters, including coordinates of each suggestion
//   - parameter input: The full or partial 3 word address to obtain suggestions for. At minimum this must be the first two complete words plus at least one character from the third word.
//   - options are provided by instantiating W3Option objects in the varidic length parameter list.  Eg:
//   */
//  func autosuggestWithCoordinates(text: String, options: [W3WOption], completion: @escaping W3WSquaresResponse)
//
//
//  /**
//   Convenience functions to allow different uses of options
//   */
//  func autosuggestWithCoordinates(text: String, options: W3WOption..., completion: @escaping W3WSquaresResponse)
//  func autosuggestWithCoordinates(text: String, completion: @escaping W3WSquaresResponse)
//
//
//  /**
//   Returns a section of the 3m x 3m what3words grid for a given area.
//   - parameter bounding-box: Bounding box, as a lat,lng,lat,lng, for which the grid should be returned. The requested box must not exceed 4km from corner to corner, or a BadBoundingBoxTooBig error will be returned. Latitudes must be >= -90 and <= 90, but longitudes are allowed to wrap around 180. To specify a bounding-box that crosses the anti-meridian, use longitude greater than 180. Example value: "50.0,179.995,50.01,180.0005" .
//   - parameter format: Return data format type; can be one of json (the default) or geojson Example value:format=Format.json
//   - parameter completion: A W3wGeocodeResponseHandler completion handler
//   */
//  func gridSection(south_lat:Double, west_lng:Double, north_lat:Double, east_lng:Double, completion: @escaping W3WGridResponse)
//
//  /**
//   Returns a section of the 3m x 3m what3words grid for a given area.
//   - parameter southWest: The southwest corner of the box
//   - parameter northEast: The northeast corner of the box
//   - parameter format: Return data format type; can be one of json (the default) or geojson Example value:format=Format.json
//   - parameter completion: A W3wGeocodeResponseHandler completion handler
//   */
//  func gridSection(southWest:CLLocationCoordinate2D, northEast:CLLocationCoordinate2D, completion: @escaping W3WGridResponse)
//
//  /**
//   Retrieves a list of the currently loaded and available 3 word address languages.
//   - parameter completion: A W3wGeocodeResponseHandler completion handler
//   */
//  func availableLanguages(completion: @escaping W3WLanguagesResponse)
//
//}
//
//
///// automatically make any class that confirms accept the different types of Option parameters
//extension W3WProtocolV3 {
//  public func autosuggest(text: String, options: W3WOption..., completion: @escaping W3WSuggestionsResponse) {
//    autosuggest(text: text, options: options, completion: completion)
//  }
//
//  public func autosuggest(text: String, completion: @escaping W3WSuggestionsResponse) {
//    autosuggest(text: text, options: [], completion: completion)
//  }
//
//  public func autosuggest(text: String, options: W3WOptions, completion: @escaping W3WSuggestionsResponse) {
//    autosuggest(text: text, options: options.options, completion: completion)
//  }
//
//  public func autosuggestWithCoordinates(text: String, options: W3WOption..., completion: @escaping W3WSquaresResponse) {
//    autosuggestWithCoordinates(text: text, options: options, completion: completion)
//  }
//
//  public func autosuggestWithCoordinates(text: String, completion: @escaping W3WSquaresResponse) {
//    autosuggestWithCoordinates(text: text, options: [], completion: completion)
//  }
//
//  public func autosuggestWithCoordinates(text: String, options: W3WOptions, completion: @escaping W3WSquaresResponse) {
//    autosuggestWithCoordinates(text: text, options: options.options, completion: completion)
//  }
//
//
//
//
//
//}
