//
//  Combine+Extensions.swift
//  w3w-swift-core
//
//  Created by Khai Do on 13/4/26.
//

import Combine

@available(iOS 13.0, macOS 10.15, watchOS 6.0, tvOS 13.0, *)
public extension Publisher {
  func withPreviousValue() -> some Publisher<(Output?, Output), Failure> {
    self
      .scan((nil, nil)) { ($0.1, $1) }
      .compactMap { old, new in new.map { (old, $0) } }
  }
}
