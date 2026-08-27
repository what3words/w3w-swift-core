//
//  W3WAPI.swift
//  w3w-swift-core
//
//  Created by Hoang Ta on 27/8/26.
//

import Foundation

/// A lightweight HTTP client for making REST API calls to what3words services.
///
/// `W3WAPI` wraps `URLSession` and provides typed, async request methods that
/// decode JSON responses into `Decodable` types. All requests are made relative
/// to ``baseURL``, and every request automatically includes the shared
/// ``headers`` and ``params`` configured on the instance.
///
/// Errors are normalised into ``W3WMessageError`` so callers only need to
/// handle a single error type:
///
/// ```swift
/// var api = W3WAPI(baseURL: url, headers: ["X-Api-Key": key])
/// let square = try await api.request(path: "/convert-to-3wa", for: W3WSquare.self)
/// ```
@available(macOS 13.0, iOS 16.0, tvOS 16.0, watchOS 9.0, *)
public struct W3WAPI {
  /// The session used to perform network requests. Defaults to `URLSession.shared`.
  public var urlSession = URLSession.shared

  /// The base URL that all request paths are appended to.
  public var baseURL: URL

  /// HTTP headers sent with every request, e.g. API keys or content negotiation.
  public var headers = [String: String]()

  /// Query parameters appended to every request. Per-request parameters
  /// with the same name take precedence over these.
  public var params = [String: String]()

  /// The range of HTTP status codes treated as success. Defaults to `200..<300`.
  /// Responses outside this range are decoded as ``W3WMessageError`` and thrown.
  public var acceptingCodes = 200..<300

  /// The decoder used for response bodies. Converts snake_case keys to camelCase.
  public let decoder = JSONDecoder.default

  /// An optional hook invoked with the underlying error whenever a request fails,
  /// before the error is thrown. Useful for centralised logging or analytics.
  public var onError: (@Sendable (Error) -> Void)?

  /// Creates an API client rooted at the given base URL.
  ///
  /// - Parameters:
  ///   - baseURL: The base URL that all request paths are appended to.
  ///   - headers: HTTP headers to send with every request. Defaults to empty.
  public init(baseURL: URL, headers: [String: String] = [:]) {
    self.baseURL = baseURL
    self.headers = headers
  }

  /// Performs a request and decodes the JSON response into the given type.
  ///
  /// - Parameters:
  ///   - method: The HTTP method to use. Defaults to `.get`.
  ///   - path: The path appended to ``baseURL``.
  ///   - params: Query parameters for this request, merged over the shared ``params``.
  ///   - body: The request body, serialised according to `encoding`. Ignored for GET requests.
  ///   - encoding: How the body is encoded. Defaults to ``W3WAPIEncoding/json``.
  ///   - type: The `Decodable` type to decode the response into.
  /// - Returns: The decoded response value.
  /// - Throws: A ``W3WMessageError`` describing the server error, or wrapping
  ///   any underlying networking or decoding failure.
  public func request<T: Decodable>(
    _ method: W3WRequestMethod = .get,
    path: String,
    params: [String: String]? = nil,
    body: [String: Any]? = nil,
    encoding: W3WAPIEncoding = .json,
    for type: T.Type
  ) async throws(W3WMessageError) -> T {
    do {
      let request: URLRequest = try request(method, path: path, params: params ?? [:], body: body, encoding: encoding)
      let data = try await data(for: request)
      return try decoder.decode(T.self, from: data)
    } catch {
      onError?(error)
      switch error {
      case let messageError as W3WMessageError: throw messageError
      default: throw .init(error)
      }
    }
  }
  
  /// Performs a request where the response body is not needed.
  ///
  /// Use this for fire-and-forget style calls such as submissions or deletions
  /// where only success or failure matters.
  ///
  /// - Parameters:
  ///   - method: The HTTP method to use. Defaults to `.post`.
  ///   - path: The path appended to ``baseURL``.
  ///   - params: Query parameters for this request, merged over the shared ``params``.
  ///   - body: The request body, serialised according to `encoding`. Ignored for GET requests.
  ///   - encoding: How the body is encoded. Defaults to ``W3WAPIEncoding/json``.
  /// - Throws: A ``W3WMessageError`` describing the server error, or wrapping
  ///   any underlying networking failure.
  public func request(
    _ method: W3WRequestMethod = .post,
    path: String,
    params: [String: String]? = nil,
    body: [String: Any]? = nil,
    encoding: W3WAPIEncoding = .json,
  ) async throws(W3WMessageError) {
    do {
      let request: URLRequest = try request(method, path: path, params: params ?? [:], body: body, encoding: encoding)
      try await data(for: request)
    } catch {
      onError?(error)
      switch error {
      case let messageError as W3WMessageError: throw messageError
      default: throw .init(error)
      }
    }
  }
}

// MARK: Convenient methods
@available(macOS 13.0, iOS 16.0, tvOS 16.0, watchOS 9.0, *)
extension W3WAPI {
  /// Performs a GET request and decodes the JSON response into the given type.
  ///
  /// Shorthand for ``request(_:path:params:body:encoding:for:)`` with `.get`.
  ///
  /// - Parameters:
  ///   - path: The path appended to ``baseURL``.
  ///   - params: Query parameters for this request, merged over the shared ``params``.
  ///   - type: The `Decodable` type to decode the response into.
  /// - Returns: The decoded response value.
  /// - Throws: A ``W3WMessageError`` on failure.
  func get<T: Decodable>(
    _ path: String,
    params: [String: String]? = nil,
    for type: T.Type
  ) async throws(W3WMessageError) -> T {
    try await request(.get, path: path, params: params, for: type)
  }

  /// Performs a POST request and decodes the JSON response into the given type.
  ///
  /// Shorthand for ``request(_:path:params:body:encoding:for:)`` with `.post`.
  ///
  /// - Parameters:
  ///   - path: The path appended to ``baseURL``.
  ///   - params: Query parameters for this request, merged over the shared ``params``.
  ///   - body: The request body, serialised according to `encoding`.
  ///   - encoding: How the body is encoded. Defaults to ``W3WAPIEncoding/json``.
  ///   - type: The `Decodable` type to decode the response into.
  /// - Returns: The decoded response value.
  /// - Throws: A ``W3WMessageError`` on failure.
  func post<T: Decodable>(
    _ path: String,
    params: [String: String]? = nil,
    body: [String: Any]? = nil,
    encoding: W3WAPIEncoding = .json,
    for type: T.Type
  ) async throws(W3WMessageError) -> T {
    try await request(.post, path: path, params: params, body: body, encoding: encoding, for: type)
  }

  /// Performs a POST request where the response body is not needed.
  ///
  /// Shorthand for ``request(_:path:params:body:encoding:)`` with `.post`.
  ///
  /// - Parameters:
  ///   - path: The path appended to ``baseURL``.
  ///   - params: Query parameters for this request, merged over the shared ``params``.
  ///   - body: The request body, serialised according to `encoding`.
  ///   - encoding: How the body is encoded. Defaults to ``W3WAPIEncoding/json``.
  /// - Throws: A ``W3WMessageError`` on failure.
  func post(
    _ path: String,
    params: [String: String]? = nil,
    body: [String: Any]? = nil,
    encoding: W3WAPIEncoding = .json,
  ) async throws(W3WMessageError) {
    try await request(.post, path: path, params: params, body: body, encoding: encoding)
  }
}

// MARK: - Helpers
@available(macOS 13.0, iOS 16.0, tvOS 16.0, watchOS 9.0, *)
private extension W3WAPI {
  /// Builds a `URLRequest` from the client configuration and per-request values.
  ///
  /// Merges the shared ``params`` with the per-request ones (per-request wins),
  /// applies ``headers``, and serialises the body for non-GET requests.
  func request(_ method: W3WRequestMethod, path: String, params: [String: String], body: [String: Any]?, encoding: W3WAPIEncoding) throws -> URLRequest {
    let url = baseURL.appending(path: path)
    guard var components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
      throw W3WAPIError.badURL(url)
    }
    
    let queryItems = self.params.merging(params) { $1 }.map(URLQueryItem.init)
    if !queryItems.isEmpty {
      components.queryItems = queryItems
    }
    guard var request = components.url.map({ URLRequest(url: $0) }) else {
      throw W3WAPIError.badComponents(components)
    }
    request.httpMethod = method.rawValue
    for (name, value) in headers {
      request.setValue(value, forHTTPHeaderField: name)
    }
    
    if method != .get, let body {
      switch encoding {
      case .json:
        request.httpBody = try JSONSerialization.data(withJSONObject: body)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
      }
    }
    return request
  }
  
  /// Executes the request and validates the HTTP response.
  ///
  /// Status codes outside ``acceptingCodes`` are turned into a ``W3WMessageError``,
  /// decoded from the response body when possible, otherwise built from the
  /// status code's localised description.
  @discardableResult
  func data(for request: URLRequest) async throws -> Data {
    let (data, response) = try await urlSession.data(for: request)
    guard let response = response as? HTTPURLResponse else {
      throw W3WAPIError.badResponse(response)
    }
    guard acceptingCodes.contains(response.statusCode) else {
      if let error = try? decoder.decode(W3WMessageError.self, from: data) {
        throw error
      }
      throw W3WMessageError(
        message: HTTPURLResponse.localizedString(forStatusCode: response.statusCode),
        messageCode: response.statusCode
      )
    }
    return data
  }
}

/// The encoding used to serialise a request body.
public enum W3WAPIEncoding {
  /// Serialise the body as JSON with a `Content-Type: application/json` header.
  case json
}

/// An error returned by a what3words service, or wrapping a local failure.
///
/// This is the single error type thrown by all ``W3WAPI`` request methods.
/// When the server responds with an error payload it is decoded directly into
/// this type; otherwise the underlying error is wrapped with a code of `0`.
public struct W3WMessageError: Decodable, Error {
  /// A human-readable description of the error.
  let message: String

  /// The error code — the server's message code, the HTTP status code,
  /// or `0` when wrapping a local error.
  let messageCode: Int
}

extension W3WMessageError {
  /// Wraps an arbitrary error, using its localised description as the message.
  ///
  /// - Parameters:
  ///   - error: The underlying error to wrap.
  ///   - code: The message code to report. Defaults to `0`.
  init(_ error: Error, code: Int = 0) {
    self.init(message: error.localizedDescription, messageCode: code)
  }
}

/// Local failures that can occur while constructing or validating a request,
/// before or after it reaches the network.
enum W3WAPIError: Error, LocalizedError {
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

extension JSONDecoder {
  /// A decoder configured for what3words API responses,
  /// converting snake_case keys to camelCase.
  static var `default`: JSONDecoder {
    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    return decoder
  }
}
