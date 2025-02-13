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
  
  @discardableResult func subscribe<EventType: Subject>(to: EventType?, handler: @escaping (EventType.Output) -> ()) -> AnyCancellable? {
    let subscription = to?.sink(
      receiveCompletion: { _ in },
      receiveValue: { event in  handler(event) })
    
    if let s = subscription {
      subscriptions.insert(s)
    }
    
    return subscription
  }
  
  
  func type(for type: Any.Type) -> String {
    return String(describing: type)
  }
  
}
