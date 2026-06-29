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
    subscribe(to: to, id: CombineIdentifier(), handler: handler)
  }

  /// Subscribes to a publisher, replacing any previous subscription registered under the same `id`.
  ///
  /// The subscription is delivered on the main queue and retained in `subscriptions`.
  /// If a subscription with the same `id` already exists, it is cancelled and removed
  /// before the new one is stored, so a given `id` only ever has one live subscription.
  /// Use this when re-subscribing to the same source (e.g. on reconfiguration) and you
  /// don't want the old stream to keep firing.
  ///
  /// - Parameters:
  ///   - to: The publisher to observe. If `nil`, nothing is subscribed and `nil` is returned.
  ///   - id: A value identifying this subscription. Re-subscribing with the same `id` disposes the previous one.
  ///   - handler: Called on the main queue with each value the publisher emits.
  /// - Returns: The created `AnyCancellable`, or `nil` if `to` was `nil`.
  @discardableResult
  func subscribe<EventType: Publisher, ID: Hashable>(
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

  func type(for type: Any.Type) -> String {
    return String(describing: type)
  }
}

/// Conforms a class to ``W3WEventSubscriberProtocol`` without boilerplate.
///
/// Attach this to a class to synthesise the `subscriptions` storage and the
/// protocol conformance, giving the type access to the `subscribe(to:handler:)`
/// and `subscribe(to:id:handler:)` helpers.
///
/// ```swift
/// @EventSubscriber
/// class MyViewModel {
///   func start(_ publisher: some Publisher<Event, Never>) {
///     subscribe(to: publisher, id: "events") { event in
///       // handle event
///     }
///   }
/// }
/// ```
///
/// The macro expands to:
/// - a `subscriptions` property (the backing ``W3WEventsSubscriptions`` set), and
/// - an extension declaring conformance to ``W3WEventSubscriberProtocol``.
@attached(member, names: named(subscriptions))
@attached(extension, conformances: W3WEventSubscriberProtocol)
public macro EventSubscriber() = #externalMacro(
  module: "W3WSwiftCoreMacros",
  type: "EventSubscriberMacro"
)
