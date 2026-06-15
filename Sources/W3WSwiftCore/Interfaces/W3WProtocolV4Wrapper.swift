//
//  W3WProtocolV4Wrapper.swift
//  w3w
//
//  Created by Kaley Nguyen on 10/6/26.
//  Copyright © 2026 What3Words. All rights reserved.
//

import Foundation
import W3WSwiftCore
import CoreLocation

public protocol W3WProtocolV4Wrapper: W3WProtocolV4 {
  func availableRfcLanguages(completion: @escaping W3WRfcLanguagesResponse)
  func convertTo3wa(coordinates: CLLocationCoordinate2D, rfcLanguage: any W3WRfcLanguageProtocol, completion: @escaping W3WSquareResponse)
}
