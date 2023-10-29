//
//  File.swift
//  
//
//  Created by Dave Duprey on 27/07/2023.
//

import Foundation


// Would use Duration: https://developer.apple.com/documentation/swift/duration
// but it's only iOS 16+.  Replace this thourought the code with Duration
// when our minimal target is iOS 16


public struct W3WDuration: Equatable {

  let hourMultiplier = 60.0
  let dayMultiplier  = 60.0 * 24.0
  let weekMultiplier = 60.0 * 24.0 * 7.0
  
  public var hours: Double {
    get { seconds / hourMultiplier }
    set { seconds = newValue * hourMultiplier }
  }
  
  public var days: Double {
    get { seconds / dayMultiplier }
    set { seconds = newValue * dayMultiplier }
  }
  
  public var weeks: Double {
    get { seconds / weekMultiplier }
    set { seconds = newValue * weekMultiplier }
  }
  
  public var seconds: Double

  public init(seconds: Double) { self.seconds = seconds }
  public init(hours: Double)   { self.seconds = hours * hourMultiplier }
  public init(days: Double)    { self.seconds = days  * dayMultiplier }
  public init(weeks: Double)   { self.seconds = weeks * weekMultiplier }

  static public func seconds(_ seconds: Double) -> W3WDuration { return W3WDuration(seconds: seconds) }

}


/// padding values that correspond to most what3words design standards
//public struct W3WPadding: Equatable, ExpressibleByFloatLiteral {
//
//  public let value: CGFloat
//
//  public init(value: CGFloat) { self.value = value }
//  public init(floatLiteral value: Float) { self.value = CGFloat(value) }
//
//  static public let none:   W3WPadding =  0.0
//  static public let single: W3WPadding =  1.0
//  static public let fine:   W3WPadding =  2.0
//  static public let thin:   W3WPadding =  4.0
//  static public let light:  W3WPadding =  8.0
//  static public let medium: W3WPadding = 12.0
//  static public let bold:   W3WPadding = 16.0
//  static public let heavy:  W3WPadding = 24.0
//}

