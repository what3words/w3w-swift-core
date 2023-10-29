//
//  File.swift
//
//
//  Created by Dave Duprey on 05/08/2021.
//

import Foundation


public class W3WThread {


  static public func isMain() -> Bool {
    return Thread.current.isMainThread
  }
  
  
  static public func runOnMain(_ block: @escaping () -> ()) {
    if W3WThread.isMain() {
      block()
    } else {
      DispatchQueue.main.async {
        block()
      }
    }
  }

  
  static public func queueOnMain(_ block: @escaping () -> ()) {
    DispatchQueue.main.async {
      block()
    }
  }
  
  
  static public func runIn(duration: W3WDuration, _ block: @escaping () -> ()) {
    DispatchQueue.main.asyncAfter(deadline: .now() + duration.seconds) {
      block()
    }
  }
  
  
//  static public func runIn(seconds: Double, _ block: @escaping () -> ()) {
//    DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
//      block()
//    }
//  }

  
  static public func runInBackground(_ block: @escaping () -> ()) {
    if Thread.current.qualityOfService == .userInitiated {
      block()
    } else {
      DispatchQueue.global(qos: .userInitiated).async {
        block()
      }
    }
  }

  
}
