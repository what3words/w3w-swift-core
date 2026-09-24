//
//  File.swift
//  
//
//  Created by Dave Duprey on 07/11/2022.
//

import Foundation


public enum W3WError: Error, CustomStringConvertible, Equatable {
  
  case message(String)
  case other(Error?)
  case code(Int, String)
  case unknown
  
  public static func == (lhs: W3WError, rhs: W3WError) -> Bool {
    return lhs.description == rhs.description
  }
  
  
  public var description: String {
    
    switch self {
    case .message(let message):
      return message
    case .other(let error):
      return String(describing: error)
    case .code(let code, let message):
      return "\(code): \(message)"
    case .unknown:
      return "unknown"
    }
  }
  
  
  /// The error code, when this error carries one, otherwise `nil`.
  public var code: Int? {
    guard case .code(let code, _) = self else { return nil }
    return code
  }
}


// MARK: - Decoding

/// Decodes a what3words error payload, which reports a `message` with an
/// optional `message_code`. Errors with a code decode as ``W3WError/code(_:_:)``,
/// and those without as ``W3WError/message(_:)``.
extension W3WError: Decodable {
  
  /// Maps to the server payload's `message` and `message_code` fields
  /// (the latter via a decoder's snake_case conversion).
  enum CodingKeys: String, CodingKey {
    case message
    case messageCode
  }
  
  public init(from decoder: any Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    let message = try container.decode(String.self, forKey: .message)
    
    if let code = try container.decodeIfPresent(Int.self, forKey: .messageCode) {
      self = .code(code, message)
    } else {
      self = .message(message)
    }
  }
}


