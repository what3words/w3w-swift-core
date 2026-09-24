//
//  W3WSessionEvents.swift
//  w3w-swift-core
//
//  Created by Hoang Ta on 24/9/26.
//

import Foundation

/// Broadcasts session-level events raised while talking to what3words services.
///
/// ``W3WApi`` sends on ``shared``, so app code can react to session changes
/// without holding on to the client that made the request. The only event so
/// far is ``onExpiration``, sent when the server invalidates the session
/// (error code 702), just before the ``W3WError`` is thrown to the caller:
///
/// ```swift
/// W3WSessionEvents.shared.onExpiration
///   .sink { reauthenticate() }
///   .store(in: &subscriptions)
/// ```
///
/// Events are always delivered on the main queue.
@available(iOS 13.0, macOS 10.15, watchOS 6.0, tvOS 13.0, *)
public final class W3WSessionEvents: @unchecked Sendable {
  /// The instance every ``W3WApi`` broadcasts on by default.
  public static let shared = W3WSessionEvents()

  /// The private subject, so only this type can broadcast events.
  /// `@unchecked Sendable` is safe because this is the only stored state,
  /// it never changes, and every send is funnelled through the main queue.
  private let expiration = W3WEvent<Void>()

  /// Fires when the session is no longer valid and must be reset: clear any
  /// cached session state and re-authenticate. Delivered on the main queue.
  public var onExpiration: W3WEventOutput<Void> { expiration.asOutputOnly() }

  /// Creates a broadcaster. Use ``shared`` in app code; a separate instance is
  /// useful to isolate events in tests, via ``W3WApi/sessionEvents``.
  public init() { }

  /// Broadcasts ``onExpiration`` to all subscribers on the main queue.
  func sendExpiration() {
    DispatchQueue.main.async { [expiration] in
      expiration.send()
    }
  }
}
