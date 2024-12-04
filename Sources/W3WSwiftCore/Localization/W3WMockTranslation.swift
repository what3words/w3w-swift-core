//
//  W3WMockTranslation.swift
//  
//
//  Created by Khải Toàn Năng on 9/8/24.
//

import Foundation

public class W3WMockTranslation: W3WTranslationsProtocol {
  
  public init() {}

  public func get(id: String) -> String {
    return id
  }
  
  public func get(id: String, language: (any W3WLanguage)?) -> String {
    return id
  }
}
