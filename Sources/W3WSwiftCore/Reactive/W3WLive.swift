//
//  W3WLive.swift
//  TestApp
//
//  Created by Dave Duprey on 20/04/2024.
//

#if canImport(Combine)
import Combine
#endif


/// A holder for a value of type `T` that broadcasts every change and never fails.
///
/// Unlike `W3WEvent`, a `W3WLive` always has a current value, readable through
/// `value` and delivered immediately to every new subscriber.
@available(iOS 13.0, macOS 10.15, watchOS 6.0, tvOS 13.0, *)
public typealias W3WLive<T> = CurrentValueSubject<T, Never>


@available(iOS 13.0, macOS 10.15, watchOS 6.0, tvOS 13.0, *)
public extension W3WLive {
  
  /// trigger an event using the current value
  func send() {
    send(value)
  }
  
}

@available(iOS 13.0, macOS 10.15, watchOS 6.0, tvOS 13.0, *)
public extension CurrentValueSubject where Failure == Never {

  /// Wraps this subject in a read-only publisher.
  ///
  /// Use this when exposing an internal `W3WLive` as public API: callers can
  /// subscribe and receive the current value, but cannot `send(_:)` into it or
  /// assign to `value`, so the owning type stays the only writer.
  ///
  /// ```swift
  /// private let selected = W3WLive<W3WSquare?>(nil)
  /// public var onSelected: W3WLiveOutput<W3WSquare?> { selected.asOutputOnly() }
  /// ```
  ///
  /// - Returns: A type-erased publisher that replays the current value to each
  ///            new subscriber and then forwards every change.
  func asOutputOnly() -> W3WLiveOutput<Output> {
    return W3WLiveOutput<Output>(self)
  }
}


/// The read-only, subscribe-only face of a `W3WLive`.
///
/// Returned by `asOutputOnly()`. Note this is the same type as
/// `W3WEventOutput`, so the replay-on-subscribe behaviour comes from the
/// underlying subject, not from the type itself.
@available(iOS 13.0, macOS 10.15, watchOS 6.0, tvOS 13.0, *)
public typealias W3WLiveOutput<T> = AnyPublisher<T, Never>
