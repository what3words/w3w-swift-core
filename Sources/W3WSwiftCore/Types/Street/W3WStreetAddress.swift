//
//  SCAddress.swift
//  w3w-swift-address-validators
//
//  Created by Dave Duprey on 08/03/2025.
//


public struct W3WStreetAddress: CustomStringConvertible {
  
  var address: [W3WStreetAddressKey: String]
  
  var formatted: String?
  
  public init(address: [W3WStreetAddressKey : String], formatted: String?) {
    self.address = address
    self.formatted = formatted
  }
  
  public subscript(key: W3WStreetAddressKey) -> String? {
    return address[key]
  }
  
  public func keys() -> [W3WStreetAddressKey] {
    return Array(address.keys)
  }
  
  public var description: String {
    return formatted ?? ""
  }
  

}
