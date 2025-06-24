//
//  W3WChatFile.swift
//  w3w-swift-core
//
//  Created by Henry Ng on 8/6/25.
//

import Foundation


public class W3WChatFile: Identifiable, Equatable, Hashable {
  
  public static func == (lhs: W3WChatFile, rhs: W3WChatFile) -> Bool {
    return lhs.id == rhs.id &&
    lhs.fileName == rhs.fileName &&
    lhs.type == rhs.type &&
    lhs.size == rhs.size &&
    lhs.data == rhs.data
  }
  
  public func hash(into hasher: inout Hasher) {
    hasher.combine(id)
    hasher.combine(fileName)
    hasher.combine(url)
    hasher.combine(type)
    hasher.combine(size)
    hasher.combine(data)
  }
  
  public var id = UUID()
  public var text: String?
  public var fileName: String = ""
  public var url: URL?
  public var data: Data?
  public var type: W3WFileType
  public var size: Int64
  
  public init(text: String?, fileName: String, url: URL?, data: Data = Data(), type: W3WFileType = .pdf, size: Int64){
    self.text = text ?? ""
    self.fileName = fileName
    self.url = url
    self.data = Data()
    self.type = type
    self.size = size
  }
  
  public enum W3WFileType {
    case pdf
    case csv
    case txt
    case photo
  }
  
}


extension W3WChatFile: @unchecked Sendable {}
