//
//  W3WURLError.swift
//  w3w-swift-core
//
//  Created by Hoang Ta on 28/8/26.
//

import Foundation

/// Local failures that can occur while constructing or validating a request,
/// before or after it reaches the network.
enum W3WURLError: Error, LocalizedError {
  /// The URL built from the base URL and path could not be parsed into components.
  case badURL(URL)
  /// The URL components could not be recombined into a valid URL.
  case badComponents(URLComponents)
  /// The response was not an HTTP response.
  case badResponse(URLResponse)

  var errorDescription: String? {
    switch self {
    case let .badURL(url): return "Bad URL: \(url)"
    case let .badComponents(components): return "Bad URLComponents: \(components)"
    case let .badResponse(response): return "Bad URLResponse: \(response)"
    }
  }
}
