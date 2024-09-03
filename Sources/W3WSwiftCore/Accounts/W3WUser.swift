//
//  User.swift
//  TestApp
//
//  Created by Dave Duprey on 02/05/2024.
//

import Foundation

#if canImport(Combine)
import Combine
@available(iOS 13.0, macOS 10.15, watchOS 6.0, tvOS 13.0, *)
extension W3WUser: ObservableObject { }
#endif


public class W3WUser {
  
  public var userId: String?
  public var email: String
  public var password: String
  public var firstName: String
  public var lastName: String
  public var country: W3WCountry?
  public var verified = false
  public var suspended = false
  public var searchHistoryOptout = false
  public var created: Date?
  public var updated: Date?

  
  public init(userId: String? = nil, email: String, password: String, firstName: String, lastName: String, country: W3WCountry? = nil, verified: Bool = false, suspended: Bool = false, searchHistoryOptout: Bool = false, created: Date? = nil, updated: Date? = nil) {
    self.userId = userId
    self.email = email
    self.password = password
    self.firstName = firstName
    self.lastName = lastName
    self.country = country
    self.verified = verified
    self.suspended = suspended
    self.searchHistoryOptout = searchHistoryOptout
    self.created = created
    self.updated = updated
  }
  
}

