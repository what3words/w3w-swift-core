//
//  W3WGpsEvent.swift
//  TestApp
//
//  Created by Dave Duprey on 20/02/2024.
//

import Combine


/// enum of events the GPS can generate
public enum W3WGpsState {
  
  /// the current location and heading
  case location(W3WGpsReading)
  
  /// the current status of the GPS system
  case status(W3WGpsStatus)

  }
