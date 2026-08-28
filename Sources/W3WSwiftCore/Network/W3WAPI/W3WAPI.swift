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
/// Errors are normalised into ``W3WAPIError`` so callers only need to
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
  /// Responses outside this range are decoded as ``W3WAPIError`` and thrown.
  public var acceptingCodes = 200..<300

  /// The cache policy applied to every request built by this client.
  /// Defaults to `.useProtocolCachePolicy`, which honours the server's
  /// cache headers. Set to `.reloadIgnoringLocalCacheData` to always
  /// fetch fresh data.
  public var cachePolicy: URLRequest.CachePolicy = .useProtocolCachePolicy
  
  /// The decoder used for response bodies. Converts snake_case keys to camelCase.
  public let decoder = JSONDecoder.default

  /// An optional hook invoked with the underlying error whenever a request fails,
  /// before the error is thrown. Useful for centralised logging or analytics.
  public var onError: (@Sendable (Error) -> Void)?

  /// An optional hook invoked with the fully-built `URLRequest` just before
  /// it is sent. Useful for centralised logging, analytics or debugging.
  /// Observation only — mutating the request here has no effect.
  public var onRequest: (@Sendable (URLRequest) -> Void)?

  /// An optional hook invoked with the raw response body and `HTTPURLResponse`
  /// as soon as a response is received, before status-code validation and
  /// decoding. Called for both success and error status codes, so it sees
  /// every round trip. Useful for centralised logging, analytics or debugging.
  public var onResponse: (@Sendable (Data, HTTPURLResponse) -> Void)?

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
  /// - Throws: A ``W3WAPIError`` describing the server error, or wrapping
  ///   any underlying networking or decoding failure.
  public func request<T: Decodable>(
    _ method: W3WRequestMethod = .get,
    path: String,
    params: [String: String]? = nil,
    body: [String: Any]? = nil,
    encoding: W3WAPIEncoding = .json,
    for type: T.Type
  ) async throws(W3WAPIError) -> T {
    do {
      let request: URLRequest = try request(method, path: path, params: params ?? [:], body: body, encoding: encoding)
      let data = try await data(for: request)
      return try decoder.decode(T.self, from: data)
    } catch {
      onError?(error)
      switch error {
      case let apiError as W3WAPIError: throw apiError
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
  /// - Throws: A ``W3WAPIError`` describing the server error, or wrapping
  ///   any underlying networking failure.
  public func request(
    _ method: W3WRequestMethod = .post,
    path: String,
    params: [String: String]? = nil,
    body: [String: Any]? = nil,
    encoding: W3WAPIEncoding = .json,
  ) async throws(W3WAPIError) {
    do {
      let request: URLRequest = try request(method, path: path, params: params ?? [:], body: body, encoding: encoding)
      try await data(for: request)
    } catch {
      onError?(error)
      switch error {
      case let apiError as W3WAPIError: throw apiError
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
  /// - Throws: A ``W3WAPIError`` on failure.
  public func get<T: Decodable>(
    _ path: String,
    params: [String: String]? = nil,
    for type: T.Type
  ) async throws(W3WAPIError) -> T {
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
  /// - Throws: A ``W3WAPIError`` on failure.
  public func post<T: Decodable>(
    _ path: String,
    params: [String: String]? = nil,
    body: [String: Any]? = nil,
    encoding: W3WAPIEncoding = .json,
    for type: T.Type
  ) async throws(W3WAPIError) -> T {
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
  /// - Throws: A ``W3WAPIError`` on failure.
  public func post(
    _ path: String,
    params: [String: String]? = nil,
    body: [String: Any]? = nil,
    encoding: W3WAPIEncoding = .json,
  ) async throws(W3WAPIError) {
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
      throw W3WURLError.badURL(url)
    }
    
    let queryItems = self.params.merging(params) { $1 }.map(URLQueryItem.init)
    if !queryItems.isEmpty {
      components.queryItems = queryItems
    }
    guard var request = components.url.map({ URLRequest(url: $0, cachePolicy: cachePolicy) }) else {
      throw W3WURLError.badComponents(components)
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
        
      case .form:
        var components = URLComponents()
        components.queryItems = body.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
        let query = components.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
        request.httpBody = query?.data(using: .utf8)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
      }
    }
    return request
  }
  
  /// Executes the request and validates the HTTP response.
  ///
  /// Status codes outside ``acceptingCodes`` are turned into a ``W3WAPIError``,
  /// decoded from the response body when possible, otherwise built from the
  /// status code's localised description.
  @discardableResult
  func data(for request: URLRequest) async throws -> Data {
    onRequest?(request)
    let (data, response) = try await urlSession.data(for: request)
    guard let response = response as? HTTPURLResponse else {
      throw W3WURLError.badResponse(response)
    }
    onResponse?(data, response)
    guard acceptingCodes.contains(response.statusCode) else {
      if let error = try? decoder.decode(W3WAPIError.self, from: data) {
        // Error code 702 means the server has invalidated the current session.
        // Broadcast `onRequireSessionReset` so observers can clear local
        // session state and re-authenticate; the error is still thrown to the caller.
        if error.code == 702 {
          NotificationCenter.default.post(name: .onRequireSessionReset, object: nil)
        }
        throw error
      }
      throw W3WAPIError(
        title: HTTPURLResponse.localizedString(forStatusCode: response.statusCode),
        code: response.statusCode
      )
    }
    return data
  }
}

public extension Notification.Name {
  /// Posted when the server responds with error code 702, indicating the
  /// current session is no longer valid and must be reset.
  ///
  /// ``W3WAPI`` posts this on `NotificationCenter.default` with no `object`
  /// or `userInfo`, before throwing the ``W3WAPIError`` to the caller.
  /// Observe it to clear cached session state and trigger re-authentication.
  static let onRequireSessionReset = Notification.Name("onRequireSessionReset")
}

private extension JSONDecoder {
  /// A decoder configured for what3words API responses,
  /// converting snake_case keys to camelCase.
  static var `default`: JSONDecoder {
    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    return decoder
  }
}
