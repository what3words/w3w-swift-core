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
}


