//
//  EventSubscriberMacro.swift
//  w3w-swift-core
//
//  Created by Hoang Ta on 10/6/26.
//

import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public struct EventSubscriberMacro: MemberMacro, ExtensionMacro {
  public static func expansion(
    of node: AttributeSyntax,
    providingMembersOf declaration: some DeclGroupSyntax,
    conformingTo protocols: [TypeSyntax],
    in context: some MacroExpansionContext
  ) throws -> [DeclSyntax] {
    return [
    """
    var subscriptions = W3WEventsSubscriptions()
    """
    ]
  }
  
  public static func expansion(
    of node: AttributeSyntax,
    attachedTo declaration: some DeclGroupSyntax,
    providingExtensionsOf type: some TypeSyntaxProtocol,
    conformingTo protocols: [TypeSyntax],
    in context: some MacroExpansionContext
  ) throws -> [ExtensionDeclSyntax] {
    return [
      try ExtensionDeclSyntax(
      """
      extension \(type): W3WEventSubscriberProtocol {}
      """
      )
    ]
  }
}

import SwiftCompilerPlugin

@main
struct SwiftUIMacros: CompilerPlugin {
  let providingMacros: [Macro.Type] = [
    EventSubscriberMacro.self,
  ]
}
