//
//  IsValid3waTests.swift
//  w3w-swift-core
//
//  Created by Henry Ng on 25/9/24.
//

import XCTest
@testable import W3WSwiftCore

class MockW3WProtocolV4 {
    
    var autosuggestClosure: (String, [W3WOption]?, W3WSuggestionsResponse) -> Void = { _, _, _ in }
        
        public func autosuggest(text: String, completion: @escaping W3WSuggestionsResponse) {
            autosuggest(text: text, options: nil, completion: completion)
        }
        
        public func autosuggest(text: String, options: [W3WOption]?, completion: @escaping W3WSuggestionsResponse) {
            autosuggestClosure(text, options, completion)
        }
        
        public func isValid3wa(words: String, completion: @escaping (Bool, W3WError?) -> ()) {
            autosuggest(text: words) { suggestions, error in
                if let error = error {
                    completion(false, W3WError.other(error))
                    return
                }
                
                for suggestion in suggestions ?? [] {
                    let w1 = suggestion.words?.trimmingCharacters(in: CharacterSet(charactersIn: "/")).lowercased()
                    let w2 = words.trimmingCharacters(in: CharacterSet(charactersIn: "/")).lowercased()
                    
                    if w1 == w2 {
                        completion(true, nil)
                        return
                    }
                }
                
                completion(false, W3WError.message("Not a valid what3words address"))
            }
        }
}



final class W3WProtocolV4Tests: XCTestCase {
    
    var sut: MockW3WProtocolV4! // System Under Test
    
    override func setUp() {
        super.setUp()
        sut = MockW3WProtocolV4() // Initialize W3WProtocolV4 instance
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func testIsValid3wa_AutosuggestError_ReturnsError() {
        // Given
        let expectation = self.expectation(description: "isValid3wa completion handler called")
        let testWords = "invalid.words.here"
        let expectedError = W3WError.message("Test error message")
        
        // Mock the autosuggest function to return an error
        sut.autosuggestClosure = { _, _, completion in
                   completion(nil, expectedError)
        }
        
        // When
        sut.isValid3wa(words: testWords) { isValid, error in
            // Then
            XCTAssertFalse(isValid, "isValid should be false when autosuggest returns an error")
            XCTAssertNotNil(error, "Error should not be nil")
            
            if case .other(let returnedError) = error {
                XCTAssertEqual(returnedError as? W3WError, expectedError, "Returned error should match the expected error")
            } else {
                XCTFail("Error should be of type .other")
            }
            
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
}
