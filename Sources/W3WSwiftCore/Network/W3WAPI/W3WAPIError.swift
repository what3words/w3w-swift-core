//
//  W3WAPIError.swift
//  w3w-swift-core
//
//  Created by Hoang Ta on 28/8/26.
//

import Foundation

/// An error returned by a what3words service, or wrapping a local failure.
///
/// This is the single error type thrown by all ``W3WAPI`` request methods.
/// When the server responds with an error payload it is decoded directly into
/// this type; otherwise the underlying error is wrapped with a code of `0`.
public struct W3WAPIError: Decodable, Error {
  /// A human-readable description of the error.
  public let title: String

  /// The error code — the server's message code, the HTTP status code,
  /// or `0` when wrapping a local error.
  public let code: Int

  /// Maps to the server payload's `message` and `message_code` fields
  /// (the latter via the decoder's snake_case conversion).
  enum CodingKeys: String, CodingKey {
    case title = "message"
    case code = "messageCode"
  }
  
  public init(title: String, code: Int) {
    self.title = title
    self.code = code
  }
  
  /// Decodes an error payload, tolerating a missing `message_code`.
  ///
  /// Some endpoints return an error message without a code, so `code`
  /// falls back to `0` when the field is absent.
  public init(from decoder: any Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    title = try container.decode(String.self, forKey: .title)
    code = try container.decodeIfPresent(Int.self, forKey: .code) ?? 0
  }
}

extension W3WAPIError {
  /// Wraps an arbitrary error, using its localised description as the message.
  ///
  /// - Parameters:
  ///   - error: The underlying error to wrap.
  ///   - code: The error code to report. Defaults to `0`.
  init(_ error: Error, code: Int = 0) {
    self.init(title: error.localizedDescription, code: code)
  }
}

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
