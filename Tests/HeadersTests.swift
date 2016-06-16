//
//  HeadersTests.swift
//  Fetcher
//
//  Created by Andrew (Seaview) on 5/8/16.
//  Copyright © 2016 Seaview Software LLC. All rights reserved.
//

import XCTest
@testable import Fetcher

class HeadersTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testCopyConstructor() {
        let original = Headers()
        
        original.append("Accept", "application/json")
        original.append("Accept", "text/plain")
        original.append("Content-Type", "text/html")
        
        let headers = Headers(original)
        
        XCTAssertEqual(headers.get("Accept"), "application/json,text/plain")
        XCTAssertEqual(headers.get("Content-Type"), "text/html")
    }
    
    func testCaseInsensitive() {
        let headers = Headers(["Accept": "application/json"])
        
        XCTAssertEqual(headers.get("Accept"), "application/json");
        XCTAssertEqual(headers.get("accept"), "application/json");
        XCTAssertEqual(headers.get("ACCEPT"), "application/json");
    }
    
    func testAppendToExisting() {
        let headers = Headers(["Accept": "application/json"])

        XCTAssertFalse(headers.has("Content-Type"))
        headers.append("Content-Type", "text/html")
        XCTAssertTrue(headers.has("Content-Type"))
        XCTAssertEqual(headers.get("Content-Type"), "text/html")
        
        headers.append("Accept", "application/xml");
        XCTAssertEqual(headers.get("Accept"), "application/json,application/xml")
    }
}
