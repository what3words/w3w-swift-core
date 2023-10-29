//
//  File.swift
//
//
//  Created by Dave Duprey on 02/11/2020.
//  Copyright © 2020 What3Words. All rights reserved.
//

import Foundation
import CoreLocation

#if canImport(UIKit)
import UIKit
#endif
#if os(watchOS)
import WatchKit
#endif


/// closure definition for internal HTTP requests
public typealias W3WRequestResponse = ((_ code: Int?, _ result: Data?, _ error: W3WError?) -> Void)


/// the method for the HTTPS request
public enum W3WRequestMethod: String {
  case get = "GET"
  case post = "POST"
}


/// A base class for making API calls to a service
open class W3WRequest {

  public var baseUrl        = ""
  public var parameters = [String:String]()
  public var headers    = [String:String]()
  
  var task: URLSessionDataTask?
  
  
  // MARK: Constructors
  
  
  /// Initialize the API wrapper
  /// - Parameters:
  ///     - baseUrl: the url to use
  ///     - parameters: dictionary of parameters to use
  ///     - headers: dictionary of headers to use
  public init(baseUrl: String, parameters: [String:String] = [:], headers: [String:String] = [:]) {
    self.baseUrl = baseUrl
    set(parameters: parameters)
    set(headers: headers)
  }
  
  
  // MARK: Accessors
  
  /**
   Sets headers for every subsequent call
   - parameter headers: additional HTTP headers to send on requests - for enterprise customers
   */
  public func set(headers: [String: String]) {
    self.headers = headers
  }
  
  
  /**
   If a header with `key` already exists, it updates the header with `value`
   if a header with key does not exist is adds this header to the custom headers
   - parameter key: key of the header to be updated / added
   - parameter value: value for the header
   */
  public func updateHeader(key: String, value: String) {
    headers[key] = value
  }
  
  
  /**
   Remove a header with `key`
   - parameter key: key of the header to be removed
   */
  public func removeHeader(key: String) {
    headers.removeValue(forKey: key)
  }
  
  
  /**
   Clears all previously set custom headers - for enterprise customers
   */
  public func clearCustomHeaders() {
    headers = [:]
  }
  
  
  
  /**
   Sets parameters for every subsequent call
   - parameter parameters: additional HTTP headers to send on requests - for enterprise customers
   */
  public func set(parameters: [String: String]) {
    self.parameters = parameters
  }
  
  
  // MARK: HTTP Request
  
  
  /**
   Calls w3w URL
   - parameter path: The URL to call
   - parameter params: dictionary of parameters to send on querystring
   - parameter completion: The completion handler
   */
  public func performRequest(path: String, params: [String:String]? = nil, json: [String:Any]? = nil, method: W3WRequestMethod = .get, completion: @escaping W3WRequestResponse) {
    
    // generate the request
    if let request = makeRequest(path: path, params: params, json: json, method: method) {
      
      // make the call
      task = URLSession.shared.dataTask(with: request) { (data, response, error) in
        
        // deal with the results, and complete with the info
        self.processResults(data: data, response: response, error: error, completion: completion)
      }
      
      // start the call
      task?.resume()
      
    // if the request object couldn't be made
    } else {
      completion(nil, nil, W3WError.code(-1, "Could not instantiate URLRequest for " + path))
    }
  }
  
  
  public func cancel() {
    task?.cancel()
  }
  
  
  /**
   given a path and parameters, make a URLRequest object
   - parameter path: The URL to call
   - parameter params: disctionary of parameters to send on querystring
   */
  func makeRequest(path: String, params: [String:String]? = nil, json: [String:Any]? = nil, method: W3WRequestMethod = .get) -> URLRequest? {
    // prepare url components
    var urlComponents = URLComponents(string: baseUrl + path)!
    
    // add the persistant and current querystring variables
    var queryItems = [URLQueryItem]()
    for (name, value) in parameters {
      let item = URLQueryItem(name: name, value: value)
      queryItems.append(item)
    }
    
    // add any querystrng parameters
    if let p = params {
      for (name, value) in p {
        let item = URLQueryItem(name: name, value: value)
        queryItems.append(item)
      }
    }
    urlComponents.queryItems = queryItems
    
    // create the URL
    if let url = urlComponents.url {
      // DEBUG
      //print("calling: ", url)
      
      // create the request
      var request = URLRequest(url: url)
      
      // set the request method ie: GET, POST, etc
      request.httpMethod = method.rawValue

      // add any json
      if let j = json, let jsonData = try? JSONSerialization.data(withJSONObject: j) {
        request.httpBody = jsonData
      }
      

      // set headers
      for (name, value) in headers {
        request.setValue(value, forHTTPHeaderField: name)
      }
      
      return request
    }
    
    return nil
  }
  
  
  /**
   Calls w3w URL
   - parameter data: the returned data from the API
   - parameter error: an error if any
   - parameter completion: The completion handler
   */
  func processResults(data: Data?, response: URLResponse?, error: Error?, completion: @escaping W3WRequestResponse) {

    // get the http code
    let code: Int? = (response as? HTTPURLResponse)?.statusCode

    guard let data = data else {
      completion(code, nil, W3WError.code(code ?? -1, error?.localizedDescription ?? "unknown"))
      task = nil
      return
    }
    
    if data.count == 0 {
      completion(code, nil, nil)
      task = nil
      return
    }
    
    completion(code, data, nil)
    task = nil
  }
  

  
  // MARK: Version Headers
  
  
  func getOsName() -> String {
#if os(macOS)
    let os_name        = "Mac"
#elseif os(watchOS)
    let os_name        = WKInterfaceDevice.current().systemName
#else
    let os_name        = UIDevice.current.systemName
#endif
    
    return os_name
  }
  
  
  func getOsVersion() -> String {
    let osv = ProcessInfo().operatingSystemVersion
    return String(osv.majorVersion) + "."  + String(osv.minorVersion) + "."  + String(osv.patchVersion)
  }
  
  
  func getSwiftVersion() -> String {
    var swift_version  = "x.x"
    
#if swift(>=7)
    swift_version = "7.x"
#elseif swift(>=6)
    swift_version = "6.x"
#elseif swift(>=5)
    swift_version = "5.x"
#elseif swift(>=4)
    swift_version = "4.x"
#elseif swift(>=3)
    swift_version = "3.x"
#elseif swift(>=2)
    swift_version = "2.x"
#else
    swift_version = "1.x"
#endif
    
    return swift_version
  }
  
  
  /// make the value for a header in W3W format to indicate version number and other basic info
  public func getHeaderValue(version: String) -> String {
    return "what3words-Swift/" + version + " (Swift " + getSwiftVersion() + "; " + getOsName() + " "  + getOsVersion() + ")"
  }
  
}
