//
//  SCAddress.swift
//  w3w-swift-address-validators
//
//  Created by Dave Duprey on 08/03/2025.
//

import Foundation


open class W3WStreetAddress: CustomStringConvertible {
  
  var info = [W3WStreetAddressKey: String]()
  
  public var printable: String?
  
  public var displayPrimary: String?
  
  public var displaySecondary: String?
  
  public var displayPrimaryHighlights: [NSRange]?
  
  public var displaySecondaryHighlights: [NSRange]?

  
  public init(address: [W3WStreetAddressKey : String] = [:], primary: String? = nil, secondary: String? = nil, displayPrimaryHighlights: [NSRange]? = nil, displaySecondaryHighlights: [NSRange]? = nil, printable: String? = nil) {
    self.info = address
    self.displayPrimary = primary
    self.displaySecondary = secondary
    self.displayPrimaryHighlights = displayPrimaryHighlights
    self.displaySecondaryHighlights = displaySecondaryHighlights
    self.printable = printable
  }
  
  
//  public init(address: String? = nil, locality: String? = nil, country: String? = nil, printable: String? = nil) {
//    info[.address] = address
//    info[.locality] = locality
//    info[.country] = country
//    self.printable = printable
//  }
  
  
  public subscript(key: W3WStreetAddressKey) -> String? {
    get {
      return info[key]
    }
    set(newValue) {
      info[key] = newValue
    }
  }
  
  public func keys() -> [W3WStreetAddressKey] {
    return Array(info.keys)
  }
  
  
  public var description: String {
    var retval = [String]()

    var firstLine = [String]()
    if let number = info[.number]   { firstLine.append(number) }
    if let street = info[.street]   { firstLine.append(street) }
    if let address = info[.address] { firstLine.append(address) }
    if firstLine.count > 0 {
      retval.append(firstLine.joined(separator: ", "))
    }

    if let locality = info[.locality] { retval.append(locality) }
    if let city = info[.city] { retval.append(city) }
    if let postCode = info[.postCode] { retval.append(postCode) }
    if let country = info[.country] { retval.append(country) }

    if retval.isEmpty {
      if let words   = info[.words] { retval.append(words) }
      if let nearest = info[.nearestPlace] { retval.append(nearest) }
    }
      
    return retval.joined(separator: ", ")
  }
  
  
//  public var words: String? {
//    get { return info[.words] }
//    set { info[.words] = newValue }
//  }
  

}
