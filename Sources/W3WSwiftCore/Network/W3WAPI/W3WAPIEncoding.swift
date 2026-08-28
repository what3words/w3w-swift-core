//
//  W3WAPIEncoding.swift
//  w3w-swift-core
//
//  Created by Hoang Ta on 28/8/26.
//

import Foundation

/// The encoding used to serialise a request body.
public enum W3WAPIEncoding {
  /// Serialise the body as JSON with a `Content-Type: application/json` header.
  case json
  
  /// Serialise the body as percent-encoded key-value pairs with a
  /// `Content-Type: application/x-www-form-urlencoded` header.
  case form
}
