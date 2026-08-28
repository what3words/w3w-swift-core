//
//  W3WAPI+Notification.swift
//  w3w-swift-core
//
//  Created by Hoang Ta on 28/8/26.
//

import Foundation

public extension Notification.Name {
  /// Posted when the server responds with error code 702, indicating the
  /// current session is no longer valid and must be reset.
  ///
  /// ``W3WAPI`` posts this on `NotificationCenter.default` with no `object`
  /// or `userInfo`, before throwing the ``W3WAPIError`` to the caller.
  /// Observe it to clear cached session state and trigger re-authentication.
  static let w3wOnRequireSessionReset = Notification.Name("w3w.onRequireSessionReset")
}
