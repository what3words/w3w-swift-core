//
//  File.swift
//  
//
//  Created by Dave Duprey on 24/02/2024.
//

#if canImport(Combine)
import Combine
#endif


@available(iOS 13.0, macOS 10.15, watchOS 6.0, tvOS 13.0, *)
@available(*, deprecated, renamed: "W3WEventsSubscriptions")
public typealias W3WAppEventSubscription = Set<AnyCancellable>

@available(iOS 13.0, macOS 10.15, watchOS 6.0, tvOS 13.0, *)
public typealias W3WEventsSubscriptions = Set<AnyCancellable>
