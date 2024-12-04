//
//  ApiExtension.swift
//  
//
//  Created by Dave Duprey on 11/04/2023.
//
//
//  This is designed to allow API calls to accept SDK types for
//  convenience sake.  This will compile only if both the SDK and
//  the API are present at the same time
//

import Foundation

#if !IMESSAGE
#if !os(watchOS)
#if canImport(w3w)
#if canImport(W3WSwiftApi)
import w3w


extension W3WProtocolV4 {
  
  public func autosuggest(text: String, options: [W3WSdkOption]?, completion: @escaping W3WSuggestionsResponse) throws {
    autosuggest(text: text, options: try convert(from: options), completion: completion)
  }
  
  public func autosuggest(text: String, options: W3WSdkOptions?, completion: @escaping W3WSuggestionsResponse) throws {
    autosuggest(text: text, options: try convert(from: options?.options), completion: completion)
  }
  
  public func autosuggest(text: String, options: W3WSdkOption..., completion: @escaping W3WSuggestionsResponse) throws {
    autosuggest(text: text, options: try convert(from: options), completion: completion)
  }
  
  func convert(from: W3WSdkOption) throws -> W3WOption? {
    switch from {
    case .language(let l):
      return .language(W3WBaseLanguage(locale: l.locale))
    case .numberOfResults(let n):
      return .numberOfResults(n)
    case .focus(let c):
      return .focus(c)
    case .numberFocusResults(let n):
      return .numberFocusResults(n)
    case .inputType(let i):
      return .inputType(W3WInputType.other(i.rawValue))
    case .clipToCountry(let c):
      return .clip(to: W3WBaseCountry(code: c.code))
    case .clipToCountries(let countries):
      return .clip(to: W3WBaseCountries(countries: countries.asArray().map( { c in W3WBaseCountry(code: c.code) })))
    case .preferLand(let b):
      return .preferLand(b)
    case .clipToCircle(let c):
      return .clip(to: W3WBaseCircle(center: c.center, radius: c.radius))
    case .clipToBox(let b):
      return .clip(to: W3WBaseBox(southWest: b.southWest, northEast: b.northEast))
    case .clipToPolygon(let p):
      return .clip(to: W3WBasePolygon(points: p.points))
    @unknown default:
      return .none
    }
  }
  
  
  func convert(from: [W3WSdkOption]?) throws -> [W3WOption] {
    var baseOptions = [W3WOption]()
    
    do {
      for option in from ?? [] {
        if let o = try convert(from: option) {
          baseOptions.append(o)
        }
      }
      
    }
    
    return baseOptions
  }
  
  
}


#endif
#endif
#endif
#endif
