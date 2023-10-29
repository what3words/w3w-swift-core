//
//  File.swift
//  
//
//  Created by Dave Duprey on 08/11/2022.
//

import Foundation


public class W3WJson<CodableType: Codable> {
  
  static public func decode(json: Data?) -> CodableType? {
    if let json = json {
      if let obj = try? JSONDecoder().decode(CodableType.self, from: json) {
        return obj
      }
    }
    
    return nil
  }
  
}
