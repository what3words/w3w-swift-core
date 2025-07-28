//
//  File.swift
//  
//
//  Created by Dave Duprey on 02/02/2023.
//

import Foundation


/// mertic imperial or default from the system
public enum W3WMeasurementSystem {
  case metric
  case imperial
  case system
}

public enum W3WSeparatorsType {
  case firstCommaSecondDot
  case firstDotSecondComma
  case firstSpaceSecondDot
  case firstSpaceSecondComma
  case firstWithoutSecondDot
  case firstWithoutSecondComma
    
  /// 12,000 or 12.000 or 12 000, etc..
  public func getFormattedString(for value: Double) -> String {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    switch self {
    case .firstCommaSecondDot:
      formatter.groupingSeparator = ","
      formatter.decimalSeparator = "."
    case .firstSpaceSecondComma:
      formatter.groupingSeparator = " "
      formatter.decimalSeparator = ","
    case .firstDotSecondComma:
      formatter.groupingSeparator = "."
      formatter.decimalSeparator = ","
    case .firstSpaceSecondDot:
      formatter.groupingSeparator = " "
      formatter.decimalSeparator = "."
    case .firstWithoutSecondDot:
      formatter.groupingSeparator = ""
      formatter.decimalSeparator = "."
    case .firstWithoutSecondComma:
      formatter.groupingSeparator = ""
      formatter.decimalSeparator = ","
    }
    return formatter.string(for: value) ?? String(value)
  }
}
