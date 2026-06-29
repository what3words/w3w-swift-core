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
public typealias W3WAppEventSubscription = Set<W3WCancellable>

@available(iOS 13.0, macOS 10.15, watchOS 6.0, tvOS 13.0, *)
public typealias W3WEventsSubscriptions = Set<W3WCancellable>

/// A `Cancellable` wrapper that gives a subscription an explicit identity.
///
/// Identity is derived solely from `id`, so storing one of these in a `Set`
/// lets a new subscription replace an existing one that shares the same `id`
/// (see `Set.update(with:)`). When no `id` is supplied, a unique
/// `CombineIdentifier` is used so each subscription remains distinct.
@available(iOS 13.0, macOS 10.15, watchOS 6.0, tvOS 13.0, *)
public struct W3WCancellable: Cancellable, Hashable {
  /// The value that defines this subscription's identity for `Hashable`/`Equatable`.
  private let id: AnyHashable

  /// The underlying Combine subscription. Cancelled on `cancel()`, and also
  /// when this wrapper is released (`AnyCancellable` cancels on deinit).
  private let cancellable: AnyCancellable

  /// Wraps a cancellable with a caller-provided identity.
  /// - Parameters:
  ///   - cancellable: The Combine subscription to retain.
  ///   - id: A value identifying this subscription. Two instances with equal
  ///     `id`s are considered equal, so the newer one replaces the older when inserted into a `Set`.
  init<ID: Hashable>(_ cancellable: AnyCancellable, id: ID) {
    self.id = id
    self.cancellable = cancellable
  }

  /// Wraps a cancellable with a unique identity.
  /// - Parameter cancellable: The Combine subscription to retain.
  ///
  /// A fresh `CombineIdentifier` is used as the identity, so the wrapper never
  /// collides with another and always accumulates rather than replacing.
  init(_ cancellable: AnyCancellable) {
    self.id = CombineIdentifier()
    self.cancellable = cancellable
  }

  /// Cancels the underlying subscription.
  public func cancel() {
    cancellable.cancel()
  }

  public func hash(into hasher: inout Hasher) {
    hasher.combine(id)
  }

  public static func == (lhs: Self, rhs: Self) -> Bool {
    lhs.id == rhs.id
  }
}

@available(iOS 13.0, macOS 10.15, watchOS 6.0, tvOS 13.0, *)
public extension AnyCancellable {
  /// Stores this cancellable in a set of ``W3WCancellable``.
  ///
  /// `W3WEventsSubscriptions` was previously `Set<AnyCancellable>`. This overload
  /// mirrors Combine's `store(in:)` so existing call sites that do
  /// `.store(in: &subscriptions)` keep compiling now that the set holds
  /// ``W3WCancellable`` instead. The cancellable is wrapped with a unique
  /// identity, so it accumulates rather than replacing any existing entry.
  /// - Parameter set: The set to store the wrapped cancellable in.
  func store(in set: inout Set<W3WCancellable>) {
    set.insert(.init(self))
  }
}
