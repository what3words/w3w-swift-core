//
//  File.swift
//
//
//  Created by Dave Duprey on 04/11/2022.
//

import CoreLocation


// MARK: what3words interface


public protocol W3WProtocolV4: W3WUtilitiesProtocol {
  
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
  func convertTo3wa(coordinates: CLLocationCoordinate2D, language: W3WLanguage, completion: @escaping W3WSquareResponse)
  
  
  /**
   Returns a list of 3 word addresses based on user input and other parameters.
   - parameter input: The full or partial 3 word address to obtain suggestions for. At minimum this must be the first two complete words plus at least one character from the third word.
   - options are provided by instantiating W3Option objects in the varidic length parameter list.  Eg:
   */
  func autosuggest(text: String, options: [W3WOption]?, completion: @escaping W3WSuggestionsResponse)
  func autosuggest(text: String, options: W3WOptions?, completion: @escaping W3WSuggestionsResponse)
  func autosuggest(text: String, options: W3WOption..., completion: @escaping W3WSuggestionsResponse)
  func autosuggest(text: String, completion: @escaping W3WSuggestionsResponse)
  
  
  /**
   Returns a list of 3 word addresses based on user input and other parameters, including coordinates of each suggestion
   - parameter input: The full or partial 3 word address to obtain suggestions for. At minimum this must be the first two complete words plus at least one character from the third word.
   - options are provided by instantiating W3Option objects in the varidic length parameter list.  Eg:
   */
  func autosuggestWithCoordinates(text: String, options: [W3WOption]?, completion: @escaping W3WSquaresResponse)
  func autosuggestWithCoordinates(text: String, options: W3WOptions?, completion: @escaping W3WSquaresResponse)
  func autosuggestWithCoordinates(text: String, options: W3WOption..., completion: @escaping W3WSquaresResponse)
  func autosuggestWithCoordinates(text: String, completion: @escaping W3WSquaresResponse)
  
  
  /**
   Returns a section of the 3m x 3m what3words grid for a given area.
   - parameter southWest: The southwest corner of the box
   - parameter northEast: The northeast corner of the box
   - parameter format: Return data format type; can be one of json (the default) or geojson Example value:format=Format.json
   - parameter completion: A W3wGeocodeResponseHandler completion handler
   */
  func gridSection(southWest:CLLocationCoordinate2D, northEast:CLLocationCoordinate2D, completion: @escaping W3WGridResponse)
  
  /**
   Returns a section of the 3m x 3m what3words grid for a given area.
   - parameter bounds: The bounds of the box
   - parameter format: Return data format type; can be one of json (the default) or geojson Example value:format=Format.json
   - parameter completion: A W3wGeocodeResponseHandler completion handler
   */
  func gridSection(bounds: W3WBox, completion: @escaping W3WGridResponse)

  /**
   Retrieves a list of the currently loaded and available 3 word address languages.
   - parameter completion: A W3wGeocodeResponseHandler completion handler
   */
  func availableLanguages(completion: @escaping W3WLanguagesResponse)
  
  /**
   Verifies that the text is a valid three word address that successfully represents a square on earth.
   - parameter text: The text to search through
   - parameter completion: returns true if the address is a real three word address
   */
  func isValid3wa(words: String, completion: @escaping (Bool) -> ())

}


/// automatically make any class that confirms accept the different types of Option parameters
extension W3WProtocolV4 {
  public func autosuggest(text: String, options: W3WOptions? = nil, completion: @escaping W3WSuggestionsResponse) {
    autosuggest(text: text, options: options?.options, completion: completion)
  }

  public func autosuggest(text: String, options: W3WOption..., completion: @escaping W3WSuggestionsResponse) {
    autosuggest(text: text, options: options, completion: completion)
  }
  
  public func autosuggest(text: String, completion: @escaping W3WSuggestionsResponse) {
    autosuggest(text: text, options: [], completion: completion)
  }
  
  public func autosuggestWithCoordinates(text: String, options: W3WOptions? = nil, completion: @escaping W3WSquaresResponse) {
    autosuggestWithCoordinates(text: text, options: options?.options, completion: completion)
  }
  
  public func autosuggestWithCoordinates(text: String, options: W3WOption..., completion: @escaping W3WSquaresResponse) {
    autosuggestWithCoordinates(text: text, options: options, completion: completion)
  }
  
  public func autosuggestWithCoordinates(text: String, completion: @escaping W3WSquaresResponse) {
    autosuggestWithCoordinates(text: text, options: [], completion: completion)
  }

}


extension W3WProtocolV4 {
  
  /**
   Verifies that the text is a valid three word address that successfully represents a square on earth.
   - parameter text: The text to search through
   - parameter completion: returns true if the address is a real three word address
   */
@available(*, deprecated, message: "Use isValid3wa(words: String, completion: @escaping (Bool, W3WError) -> ()) instead")
  public func isValid3wa(words: String, completion: @escaping (Bool) -> ()) {
    autosuggest(text: words) { suggestions, error in
      for suggestion in suggestions ?? [] {
        // remove slashes and make lowercase for comparison
        let w1 = suggestion.words?.trimmingCharacters(in: CharacterSet(charactersIn: "/")).lowercased()
        let w2 = words.trimmingCharacters(in: CharacterSet(charactersIn: "/")).lowercased()
        
        if w1 == w2 {
          completion(true)
          return
        }
      }
      
      // no match found
      completion(false)
    }
  }
  
}

extension W3WProtocolV4 {
    
    /**
     Verifies that the text is a valid three word address that successfully represents a square on earth.
     - parameter text: The text to search through
     - Parameter completion: It returns two parameters:
                             - A `Bool` indicating whether the address is valid (`true`) or not (`false`).
                             - A `W3WError` object providing more details about any error that occurred during validation.
     */
    
    public func isValid3wa(words: String, completion: @escaping (Bool, W3WError?) -> ()) {
      autosuggest(text: words) { suggestions, error in
          
          // Handle autosuggest error
          if let error {
              completion(false, W3WError.other(error))
              return
          }
            
          for suggestion in suggestions ?? [] {
          // remove slashes and make lowercase for comparison
          let w1 = suggestion.words?.trimmingCharacters(in: CharacterSet(charactersIn: "/")).lowercased()
          let w2 = words.trimmingCharacters(in: CharacterSet(charactersIn: "/")).lowercased()
          
          if w1 == w2 {
            completion(true, nil)
            return
          }
        }
        
        // no match found
        completion(false, W3WError.message("Not a valid what3words address"))
      }
    }
}



