//
//  File.swift
//  
//
//  Created by Dave Duprey on 14/09/2023.
//

import Foundation


@available(*, deprecated, message: "use W3WTranslationsProtocol instead")
public class W3WTranslations {
  
  public static let main = W3WTranslations()
  
  
  static var bundles = [Bundle]()
  
  
  public init(bundle: Bundle? = nil) {
    if let b = bundle {
      add(bundle: b)
    }
  }
  
  
  public func add(bundle: Bundle) {
    if !Self.bundles.contains(where: { b in b == bundle }) {
      Self.bundles.insert(bundle, at: 0) // Self.bundles.append(bundle)
      do {
        try bundle.loadAndReturnError()
      } catch {
        print(bundle, error)
      }
    }
  }
  
  
  public func translate(key: String, backup: String? = nil) -> String {
    for bundle in Self.bundles {
      if let translation = translate(bundle: bundle, key: key) {
        return translation
      }
    }
    
    return backup ?? key
  }
  
  
  public func translate(bundle: Bundle, key: String, backup: String = "Missing translation") -> String? {
    var translation = NSLocalizedString(key, bundle: bundle, comment: backup)
    
    // near is a special case, if a translation is not available then we drop 'near' and just return the value, usually 'nearestPlace'
    if translation == "near" {
      translation = "${PARAM}"
      
      // if the translation is missing then use the default
    } else if translation == key {
      return nil
    }
    
    return translation.replacingOccurrences(of: "${PARAM}", with: "%@")
  }
  
}
