//
//  W3WChatRequest.swift
//  w3w-swift-core
//
//  Created by Henry Ng on 14/6/25.
//

import Foundation

public struct ChatRequest: Codable, Sendable {
    public let user_input: String
    public let history: [ChatMessage]
    public let stream: String
  
    
  public init(user_input: String, history: [ChatMessage], stream: String = "true") {
        self.user_input = user_input
        self.history = history
        self.stream = stream
     
    }
}
