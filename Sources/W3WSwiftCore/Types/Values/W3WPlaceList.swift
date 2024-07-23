//
//  File.swift
//
//
//  Created by Khải Toàn Năng on 23/7/24.
//

import Foundation

public enum W3WListType: Int {
  case favorite
  case other
}

public enum W3WListShareType: String {
  case off
  case invite
  case `public`
  case copy
  
  public var intValue: Int {
    switch self {
    case .off: return 0
    case .invite: return 1
    case .public: return 2
    case .copy: return 3
    }
  }
}

public enum W3WSortingType: Int {
  case oldest = 0
  case newest = 1
  case alphabetical = 2
}

public protocol W3WAppPlaceListProtocol {
  var primaryKey: String { get }
  var listId: String? { get }
  var listLabel: String? { get }
  var listType: W3WListType { get }
  var count: String { get }
  var sorting: W3WSortingType { get }
  var markerColorHex: String? { get }
  var shareType: W3WListShareType? { get }
  var shareListId: String? { get }
  var shareCollaboratorCount: Int { get }
  var shareFollowerCount: Int { get }
  var isShared: Bool { get }
  var updatedAt: Date { get }
  var createdBy: String { get }
}

public struct W3WAppPlaceList: W3WAppPlaceListProtocol {
  public var primaryKey: String
  
  public var listId: String?
  
  public var listLabel: String?
  
  public var listType: W3WListType
  
  public var count: String
  
  public var sorting: W3WSortingType
  
  public var markerColorHex: String?
  
  public var shareType: W3WListShareType?
  
  public var shareListId: String?
  
  public var shareCollaboratorCount: Int
  
  public var shareFollowerCount: Int
  
  public var isShared: Bool
  
  public var updatedAt: Date
  
  public var createdBy: String
  
  public init(primaryKey: String, listId: String? = nil, listLabel: String? = nil, listType: W3WListType, count: String, sorting: W3WSortingType, markerColorHex: String? = nil, shareType: W3WListShareType? = nil, shareListId: String? = nil, shareCollaboratorCount: Int, shareFollowerCount: Int, isShared: Bool, updatedAt: Date, createdBy: String) {
    self.primaryKey = primaryKey
    self.listId = listId
    self.listLabel = listLabel
    self.listType = listType
    self.count = count
    self.sorting = sorting
    self.markerColorHex = markerColorHex
    self.shareType = shareType
    self.shareListId = shareListId
    self.shareCollaboratorCount = shareCollaboratorCount
    self.shareFollowerCount = shareFollowerCount
    self.isShared = isShared
    self.updatedAt = updatedAt
    self.createdBy = createdBy
  }
  
  public var hasItems: Bool {
    return self.count != "0" && !self.count.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty
  }
  
  public var listIdOrPrimaryKey: String {
    return self.listId != nil ? self.listId! : self.primaryKey
  }
}
