//
//  W3WEvent.swift
//  TestApp
//
//  Created by Dave Duprey on 30/04/2024.
//

#if canImport(Combine)
import Combine
#endif


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
