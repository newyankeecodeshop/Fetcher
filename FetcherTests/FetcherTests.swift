//
//  FetcherTests.swift
//  FetcherTests
//
//  Created by Andrew on 5/4/16.
//  Copyright © 2016 Seaview Software LLC. All rights reserved.
//

import XCTest
@testable import Fetcher

class FetcherTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testBasicGET() {
        let testResult = self.expectationWithDescription("Fetch with GET");

        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let session = NSURLSession.sharedSession()
        
        session.fetch("https://api.github.com")
            .then { (response) -> Promise<String> in
                XCTAssertNotNil(response.headers)
                XCTAssertNotNil(response.headers.get("date"))
                XCTAssertNil(response.headers.get("bogus"))
                
                return response.text()
            }
            .then({ (text) -> String in
                print(text)
                testResult.fulfill()
                return text
            })
            .catch_ { (error) in
                print(error);
            }
        
        waitForExpectationsWithTimeout(2.0, handler: nil)
    }
    
    func testCustomHeaderGET() {
        let testResult = self.expectationWithDescription("Fetch with custom headers GET");
        
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let session = NSURLSession.sharedSession()
        let headers = Headers(["Custom-1": "Value-1"])
        
        headers.append("Custom-2", "Value-2")
        
        session.fetch("https://api.github.com", RequestInit(headers: headers))
            .then { (response) -> Headers in
                testResult.fulfill()
                return response.headers
            }
            .catch_ { (error) in
                print(error);
        }
        
        waitForExpectationsWithTimeout(2.0, handler: nil)
    }
    
}
