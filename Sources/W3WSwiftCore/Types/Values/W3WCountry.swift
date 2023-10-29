//
//  File.swift
//  
//
//  Created by Dave Duprey on 01/11/2022.
//

import Foundation


public protocol W3WCountry {
  
  /// ISO 3166-1 alpha-2 country codes, such as US,CA
  var code: String { get }
  
  /// Makes a W3Wcountry
  /// - Parameter code: ISO 3166-1 alpha-2 country codes, such as US,CA
  init(code: String) throws
}



public struct W3WBaseCountry: W3WCountry, ExpressibleByStringLiteral {
  
  /// ISO 3166-1 alpha-2 country codes, such as US,CA
  public var code: String
  
  /// Makes a W3Wcountry
  /// - Parameter code: ISO 3166-1 alpha-2 country codes, such as US,CA
  public init(stringLiteral value: String) { self.code = value }

  /// Makes a W3Wcountry
  /// - Parameter code: ISO 3166-1 alpha-2 country codes, such as US,CA
  public init(code: String) { self.code = code }

}



public protocol W3WCountries {
  var countries: [any W3WCountry] { get set }
  init(countries: [any W3WCountry])
}


/// Stores a container of W3WSdkCountry
public struct W3WBaseCountries: W3WCountries {
  
  public var countries: [any W3WCountry]
  
  /// init with an array of W3WSdkCountry
  public init(countries: [any W3WCountry]) {
    self.countries = countries
  }
    
}
