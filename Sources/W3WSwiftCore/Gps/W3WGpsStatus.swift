//
//  File.swift
//  
//
//  Created by Dave Duprey on 20/04/2022.
//

import Foundation


/// status of the W3WGps object
public enum W3WGpsStatus: String {
  case active       // system is recieving GPS coordinates
  case unavailable  // temporary issues getting coordinates
  case error        // no GPS is available
  case unknown      // unknown error occurred
}
