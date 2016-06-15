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
        
        fetch("https://api.github.com")
            .then { (response) -> Promise<String> in
                XCTAssertNotNil(response.headers)
                XCTAssertNotNil(response.headers.get("date"))
                XCTAssertNil(response.headers.get("bogus"))
                
                return response.text()
            }
            .then({ (text) -> String in
                XCTAssertFalse(text.isEmpty)
                testResult.fulfill()
                return text
            })
            .catch_ { (error) in print(error) }
        
        waitForExpectationsWithTimeout(2.0, handler: nil)
    }
    
    func testNestedGET() {
        let testResult = self.expectationWithDescription("Fetch with multiple GETs");
        
        fetch("https://api.github.com")
            .then { (response) in response.json() }
            .then({ (json) -> Promise<Response> in
                let nextUrl = json.valueForKey("current_user_url") as! String
                return fetch(nextUrl)
            })
            .then({ (response) in response.json() })
            .then({ (json) -> AnyObject in
                let message = json.valueForKey("message") as! String
                XCTAssertEqual("Requires authentication", message)
                testResult.fulfill()
                return json
            })
            .catch_ { (error) in print(error) }
        
        waitForExpectationsWithTimeout(2.0, handler: nil)
    }
    
    func testMethodParam() {
        let testResult = self.expectationWithDescription("Fetch with HEAD");
        
        fetch("https://api.github.com/feeds", RequestInit(method: .HEAD))
            .then({ (response) -> Response in
                // There should be no body
                XCTAssertTrue(response.body?.length == 0)
                // but definitely headers
                XCTAssertNotNil(response.headers.get("X-GitHub-Request-Id"))
                testResult.fulfill()
                return response
            })
            .catch_ { (error) in print(error) }
        
        waitForExpectationsWithTimeout(2.0, handler: nil)
    }
    
    func testHeaderParam() {
        let testResult = self.expectationWithDescription("Fetch with custom header");
        
        // First try the GET by asking for text/plain, which should fail. Then ask for JSON
        fetch("https://api.github.com", RequestInit(headers: Headers(["Accept": "text/plain"])))
            .then({ (response) -> Promise<Response> in
                XCTAssertEqual(415, response.status)
                return fetch("https://api.github.com", RequestInit(headers: Headers(["Accept": "application/json"])))
            })
            .then({ (response) -> Promise<String> in
                XCTAssertEqual(200, response.status)
                testResult.fulfill()
                return response.text()
            })
            .catch_ { (error) in print(error) }
        
        waitForExpectationsWithTimeout(2.0, handler: nil)
    }
}
