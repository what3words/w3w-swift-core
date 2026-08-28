//
//  W3WAPI.swift
//  w3w-swift-core
//
//  Created by Hoang Ta on 27/8/26.
//

import Foundation
import Combine

// Combine-based counterparts to the async request methods on `W3WAPI`,
// for callers that consume results as publishers rather than with async/await.
@available(macOS 13.0, iOS 16.0, tvOS 16.0, watchOS 9.0, *)
extension W3WAPI {
  /// Bridges an async request into a Combine `Future` that emits the decoded
  /// value once, or fails with a ``W3WAPIError``.
  private func future<T: Decodable>(
    _ method: W3WRequestMethod,
    path: String,
    params: [String: String]?,
    body: [String: Any]?,
    for type: T.Type
  ) -> Future<T, W3WAPIError> {
    Future { promise in
      Task {
        do throws(W3WAPIError) {
          let value = try await request(method, path: path, params: params, body: body, for: type)
          promise(.success(value))
        } catch {
          promise(.failure(error))
        }
      }
    }
  }
  
  /// Performs a GET request, delivering the decoded response through a `Future`.
  ///
  /// - Parameters:
  ///   - path: The path appended to ``baseURL``.
  ///   - params: Query parameters for this request, merged over the shared ``params``.
  ///   - type: The `Decodable` type to decode the response into.
  /// - Returns: A future that emits the decoded value or fails with a ``W3WAPIError``.
  public func get<T: Decodable>(
    _ path: String,
    params: [String: String]? = nil,
    for type: T.Type
  ) -> Future<T, W3WAPIError> {
    future(.get, path: path, params: params, body: nil, for: type)
  }

  /// Performs a POST request, delivering the decoded response through a `Future`.
  ///
  /// - Parameters:
  ///   - path: The path appended to ``baseURL``.
  ///   - params: Query parameters for this request, merged over the shared ``params``.
  ///   - body: The request body, serialised as JSON.
  ///   - type: The `Decodable` type to decode the response into.
  /// - Returns: A future that emits the decoded value or fails with a ``W3WAPIError``.
  public func post<T: Decodable>(
    _ path: String,
    params: [String: String]? = nil,
    body: [String: Any]? = nil,
    for type: T.Type
  ) -> Future<T, W3WAPIError> {
    future(.post, path: path, params: params, body: body, for: type)
  }

  /// Performs a POST request where the response body is not needed,
  /// delivering completion through a `Future`.
  ///
  /// - Parameters:
  ///   - path: The path appended to ``baseURL``.
  ///   - params: Query parameters for this request, merged over the shared ``params``.
  ///   - body: The request body, serialised as JSON.
  /// - Returns: A future that emits once on success or fails with a ``W3WAPIError``.
  public func post(
    _ path: String,
    params: [String: String]? = nil,
    body: [String: Any]? = nil
  ) -> Future<Void, W3WAPIError> {
    Future { promise in
      Task {
        do throws(W3WAPIError) {
          try await request(.post, path: path, params: params, body: body)
          promise(.success(()))
        } catch {
          promise(.failure(error))
        }
      }
    }
  }
}
