//
//  W3WEvent.swift
//  TestApp
//
//  Created by Dave Duprey on 30/04/2024.
//

#if canImport(Combine)
import Combine
#endif


/// A broadcaster for one-off events of type `T` that never fails.
///
/// Values sent are delivered only to subscribers attached at the time of the
/// send — there is no current value and nothing is replayed to late
/// subscribers. Use `W3WLive` when subscribers need the latest value on
/// subscription.
@available(iOS 13.0, macOS 10.15, watchOS 6.0, tvOS 13.0, *)
public typealias W3WEvent<T> = PassthroughSubject<T, Never>


/// A type that can broadcast values of a given type to its subscribers.
///
/// This abstracts over the concrete Combine subjects used in this module —
/// `W3WEvent` (a `PassthroughSubject`) and `W3WLive` (a `CurrentValueSubject`) —
/// so code can accept "something to send values into" without caring which
/// subject backs it, e.g. `any W3WEventSender<W3WSquare>`.
@available(iOS 13.0, macOS 10.15, watchOS 6.0, tvOS 13.0, *)
public protocol W3WEventSender<Input>: AnyObject {

  /// The type of value this sender accepts.
  associatedtype Input

  /// Broadcasts a value to all subscribers.
  /// - Parameter input: The value to send.
  func send(_ input: Input)
}


/// `W3WEvent` satisfies `send(_:)` via `PassthroughSubject`.
@available(iOS 13.0, macOS 10.15, watchOS 6.0, tvOS 13.0, *)
extension W3WEvent: W3WEventSender {}

@available(iOS 13.0, macOS 10.15, watchOS 6.0, tvOS 13.0, *)
public extension PassthroughSubject where Failure == Never {

  /// Wraps this subject in a read-only publisher.
  ///
  /// Use this when exposing an internal `W3WEvent` as public API: callers can
  /// subscribe, but cannot `send(_:)` into it, so the owning type stays the
  /// only source of events.
  ///
  /// ```swift
  /// private let tapped = W3WEvent<W3WSquare>()
  /// public var onTapped: W3WEventOutput<W3WSquare> { tapped.asOutputOnly() }
  /// ```
  ///
  /// - Returns: A type-erased publisher that forwards everything this subject sends.
  func asOutputOnly() -> W3WEventOutput<Output> {
    return W3WEventOutput<Output>(self)
  }
}


/// The read-only, subscribe-only face of a `W3WEvent`.
///
/// Returned by `asOutputOnly()`. Like `W3WEvent`, it has no current value —
/// subscribers receive only the events sent after they subscribe.
@available(iOS 13.0, macOS 10.15, watchOS 6.0, tvOS 13.0, *)
public typealias W3WEventOutput<T> = AnyPublisher<T, Never>
