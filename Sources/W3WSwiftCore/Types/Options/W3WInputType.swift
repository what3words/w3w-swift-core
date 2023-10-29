//
//  W3WSdkInputType.swift
//  what3words
//
//  Created by Dave Duprey on 04/11/2022.
//  Copyright © 2022 what3words. All rights reserved.
//

import Foundation


public enum W3WInputType : CustomStringConvertible {

  case text
  case voconHybrid
  case nmdpAsr
  case genericVoice
  case speechmatics
  case mihup
  case mawdoo3
  case ocrSdk
  case vinBigData
  case other(String)

  public var description: String { get { return rawValue } }
  
  public var rawValue : String {
    switch self {
    case .text:               return "text"
    case .voconHybrid:        return "vocon-hybrid"
    case .nmdpAsr:            return "nmdp-asr"
    case .genericVoice:       return "generic-voice"
    case .speechmatics:       return "speechmatics"
    case .mihup:              return "mihup"
    case .mawdoo3:            return "mawdoo3"
    case .ocrSdk:             return "w3w-ocr-sdk"
    case .vinBigData:         return "vin-big-data"
    case .other(let value):  return value
    }
  }

}

