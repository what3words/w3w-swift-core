//
//  W3WLive.swift
//  TestApp
//
//  Created by Dave Duprey on 20/04/2024.
//

#if canImport(Combine)
import Combine
#endif


@available(iOS 13.0, macOS 10.15, watchOS 6.0, tvOS 13.0, *)
public typealias W3WLive<T> = CurrentValueSubject<T, Never>
