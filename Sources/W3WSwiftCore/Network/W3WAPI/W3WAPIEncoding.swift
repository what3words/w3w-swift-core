//
//  W3WAPIEncoding.swift
//  w3w-swift-core
//
//  Created by Hoang Ta on 28/8/26.
//

import Foundation

/// The encoding used to serialise a request body.
public enum W3WAPIEncoding: Sendable {
  /// Serialise the body as JSON with a `Content-Type: application/json` header.
  case json
  
  /// Serialise the body as percent-encoded key-value pairs with a
  /// `Content-Type: application/x-www-form-urlencoded` header.
  case form
  
  /// Serialise the body as `multipart/form-data`. Each file becomes its own
  /// part, and each entry of the request body becomes a text field, with its
  /// value converted to a string using string interpolation.
  case multipart(files: [W3WAPIFilePart])
}

/// A file to upload as one part of a `multipart/form-data` request body.
public struct W3WAPIFilePart: Sendable {
  /// The form field name of the part, e.g. `"files"`.
  public let name: String
  
  /// The filename reported to the server.
  public let fileName: String
  
  /// The MIME type of the file content, e.g. `"audio/wav"`.
  public let contentType: String
  
  /// The raw file content.
  public let data: Data
  
  public init(name: String, fileName: String, contentType: String, data: Data) {
    self.name = name
    self.fileName = fileName
    self.contentType = contentType
    self.data = data
  }
}
