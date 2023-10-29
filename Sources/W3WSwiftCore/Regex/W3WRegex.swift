//
//  File.swift
//  
//
//  Created by Dave Duprey on 07/11/2022.
//

import Foundation


public class W3WRegex {
  
  public static let regex_3wa_characters         = "^/*([^0-9`~!@#$%^&*()+\\-_=\\]\\[{\\}\\\\|'<,.>?/\";:£§º©®\\s]|[.｡。･・︒។։။۔።।]){0,}$"
  public static let regex_3wa_separator          = "[.｡。･・︒។։။۔።।]"
  public static let regex_3wa_mistaken_separator = "[ ,\\\\^_/+'&:;|　-]{1,2}"
  public static let regex_3wa_word               = "\\w+"
  public static let regex_exlusionary_word       = "[^0-9`~!@#$%^&*()+\\-_=\\]\\[{\\}\\\\|'<,.>?/\";:£§º©®\\s]{1,}"
  public static let regex_match                  = "^(?:/*\\w+[.｡。･・︒។։။۔።।]\\w+[.｡。･・︒។։။۔።।]\\w+|/*\\w+([\u{20}\u{A0}]\\w+){1,3}[.｡。･・︒។։။۔።।]\\w+([\u{20}\u{A0}]\\w+){1,3}[.｡。･・︒។։။۔።।]\\w+([\u{20}\u{A0}]\\w+){1,3})$"
  public static let regex_loose_match            = "^/*\\w+[.｡。･・︒។։။۔።। ,\\\\^_/+'&:;|　-]{1,2}\\w+[.｡。･・︒។։။۔።। ,\\\\^_/+'&:;|　-]{1,2}\\w+$"
  public static let regex_search                 = "\\w+[.｡。･・︒។։။۔።।]\\w+[.｡。･・︒។։။۔።।]\\w+"


  /// Uses the regex to determine if a String fits the three word address form of three words in any language separated by two separator characters
  public static func isPossible3wa(text: String) -> Bool {
    return Self.regexMatch(text: text, regex: W3WRegex.regex_match)
  }
  
  
  /// checks if input looks like a 3 word address or not
  public static func didYouMean(text: String) -> Bool {
    return Self.regexMatch(text: text, regex: W3WRegex.regex_loose_match)
  }
  
  
  static func regexMatch(text: String, regex: String) -> Bool {
    if let regex = try? NSRegularExpression(pattern:regex, options: []) {
      let count = regex.numberOfMatches(in: text, options: [], range: NSRange(text.startIndex..<text.endIndex, in:text))
      if (count > 0) {
        return true
      } else {
        return false
      }
    } else {
      return false
    }
  }
  
  
  /// searches a string for possible three word address matches
  public static func findPossible3wa(text: String) -> [String] {
    var results = [String]()
    
    if let regex = try? NSRegularExpression(pattern:W3WRegex.regex_search) {
      let matches = regex.matches(in: text, range: NSRange(text.startIndex..., in:text))
      
      for match in matches {
        if let range = Range(match.range, in: text) {
          results.append(String(text[range]))
        }
      }
    }
    
    return results
  }
  
  
  
}
