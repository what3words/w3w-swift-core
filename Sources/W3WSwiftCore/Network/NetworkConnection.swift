//
//  NetworkConnection.swift
//  TestApp
//
//  Created by Dave Duprey on 02/08/2024.
//



public enum W3WNetworkConnnection {
  case wifi
  case cellular
  case unreachable
  case wiredEthernet
  case loopback
  case unknown
  
  public func isOnline() -> Bool {
    return (self == .wifi) || (self == .cellular) || (self == .wiredEthernet)
  }
}

