//
//  File.swift
//  
//
//  Created by Dave Duprey on 2022-04-16.
//

import Foundation


public class W3WDebouncer<T> {

  let delay: TimeInterval
  var timer: Timer?

  public var closure: (T) -> Void

  
  public init(delay: TimeInterval, closure: @escaping (T) -> Void) {
    self.delay = delay
    self.closure = closure
  }


  public func execute(_ x: T) {
    timer?.invalidate()
    timer = Timer.scheduledTimer(withTimeInterval: delay, repeats: false, block: { [weak self] _ in  self?.closure(x)})
  }


  public func stop() {
    timer?.invalidate()
    timer = nil
  }

}
