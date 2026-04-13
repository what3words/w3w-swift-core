//
//  EventSubscriberProtocol.swift
//  TestApp
//
//  Created by Dave Duprey on 13/03/2024.
//

#if canImport(Combine)
import Combine
#endif


@available(iOS 13.0, macOS 10.15, watchOS 6.0, tvOS 13.0, *)
public protocol W3WEventSubscriberProtocol: AnyObject {
  var subscriptions: W3WEventsSubscriptions { get set }
}

@available(iOS 13.0, macOS 10.15, watchOS 6.0, tvOS 13.0, *)
public extension W3WEventSubscriberProtocol {
  
  /// Subscribe function that return New value
  @discardableResult func subscribe<EventType: Publisher>(to: EventType?, handler: @escaping (EventType.Output) -> ()) -> AnyCancellable? {
    let subscription = to?.sink(
      receiveCompletion: { _ in },
      receiveValue: { event in
        W3WThread.runOnMain {
          handler(event)
        }
      })
    
    if let s = subscription {
      subscriptions.insert(s)
    }
    
    return subscription
  }
  
  /// Subscribe function that return Old, New value
  @discardableResult func subscribeWithOldValue<EventType: Publisher>(to: EventType?, handler: @escaping (_ old: EventType.Output?, _ new: EventType.Output) -> ()) -> AnyCancellable? {
    
    let subscription = to?
      .scan((nil, nil)) { ($0.1, $1) }
      .compactMap { old, new -> (EventType.Output?, EventType.Output)? in
        guard let new = new else { return nil }
        return (old, new)
      }
      .sink(
        receiveCompletion: { _ in },
        receiveValue: { old, new in
          W3WThread.runOnMain {
            handler(old, new)
          }
        }
      )
    
    
    if let s = subscription {
      subscriptions.insert(s)
    }
    
    return subscription
  }
  
  func type(for type: Any.Type) -> String {
    return String(describing: type)
  }
  
}
