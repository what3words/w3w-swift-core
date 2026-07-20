//
//  EventSubscriberProtocol.swift
//  TestApp
//
//  Created by Dave Duprey on 13/03/2024.
//

import Foundation
#if canImport(Combine)
import Combine
#endif


@available(iOS 13.0, macOS 10.15, watchOS 6.0, tvOS 13.0, *)
public protocol W3WEventSubscriberProtocol: AnyObject {
  var subscriptions: W3WEventsSubscriptions { get set }
}

@available(iOS 13.0, macOS 10.15, watchOS 6.0, tvOS 13.0, *)
public extension W3WEventSubscriberProtocol {
  @discardableResult
  func subscribe<EventType: Publisher>(
    to: EventType?,
    handler: @escaping (EventType.Output) -> ()
  ) -> AnyCancellable? {
    // Use a fresh CombineIdentifier so each id-less subscription is unique and accumulates
    store(to: to, id: CombineIdentifier(), handler: handler)
  }

  /// Subscribes to a publisher, replacing any previous subscription registered under the same `id`.
  ///
  /// The subscription is delivered on the main queue and retained in `subscriptions`.
  /// If a subscription with the same `id` already exists, it is cancelled and removed
  /// before the new one is stored, so a given `id` only ever has one live subscription.
  ///
  /// - Parameters:
  ///   - to: The publisher to observe. If `nil`, nothing is subscribed and `nil` is returned.
  ///   - id: A value identifying this subscription. Re-subscribing with the same `id` disposes the previous one.
  ///   - handler: Called on the main queue with each value the publisher emits.
  /// - Returns: The created `AnyCancellable`, or `nil` if `to` was `nil`.
  @available(*, deprecated, message: "Use resubscribe(to:handler:) instead; it derives the id from the call site automatically.")
  @discardableResult
  func subscribe<EventType: Publisher, ID: Hashable>(
    to: EventType?,
    id: ID,
    handler: @escaping (EventType.Output) -> ()
  ) -> AnyCancellable? {
    store(to: to, id: id, handler: handler)
  }

  /// Subscribes to a publisher, replacing any previous subscription made from the same call site.
  ///
  /// The call site (file and line) is used as the subscription `id`, so calling this
  /// again from the same place — e.g. on reconfiguration — cancels the previous
  /// subscription before storing the new one. Distinct call sites never affect each other.
  /// The subscription is delivered on the main queue and retained in `subscriptions`.
  ///
  /// Note: repeated calls from the same line (e.g. in a loop) share one `id`, so only
  /// the most recent subscription stays alive. If `to` is `nil`, nothing is subscribed
  /// and any existing subscription from this call site is left untouched.
  ///
  /// - Parameters:
  ///   - to: The publisher to observe. If `nil`, nothing is subscribed and `nil` is returned.
  ///   - fileID: Leave as default; captures the caller's file to build the subscription `id`.
  ///   - line: Leave as default; captures the caller's line to build the subscription `id`.
  ///   - handler: Called on the main queue with each value the publisher emits.
  /// - Returns: The created `AnyCancellable`, or `nil` if `to` was `nil`.
  @discardableResult
  func resubscribe<EventType: Publisher>(
    to: EventType?,
    fileID: String = #fileID,
    line: Int = #line,
    handler: @escaping (EventType.Output) -> ()
  ) -> AnyCancellable? {
    let id = "\(fileID) \(line)"
    return store(to: to, id: id, handler: handler)
  }
  
  func type(for type: Any.Type) -> String {
    return String(describing: type)
  }
}

extension W3WEventSubscriberProtocol {
  func store<EventType: Publisher, ID: Hashable>(
    to: EventType?,
    id: ID,
    handler: @escaping (EventType.Output) -> ()
  ) -> AnyCancellable? {
    let subscription = to?
      .receive(on: DispatchQueue.main)
      .sink(
        receiveCompletion: { _ in },
        receiveValue: { event in handler(event)
        }
      )

    if let subscription {
      let oldSubscription = subscriptions.update(with: .init(subscription, id: id))
      oldSubscription?.cancel()
    }

    return subscription
  }
}
