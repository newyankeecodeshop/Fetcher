//
//  Body.swift
//  Fetcher
//
//  Created by Andrew on 5/5/16.
//  Copyright © 2016 Seaview Software LLC. All rights reserved.
//

import Foundation

/**
 This protocol is implemented by types that contain a body, such as a Response.
 */
public protocol Body {
    
    func arrayBuffer() -> Promise<ContiguousArray<UInt8>>

    func blob() -> Promise<NSData>
    
    func formData() -> Promise<FormData>
    
    func json() -> Promise<AnyObject>
    
    func text() -> Promise<String>
}

/**
 A protocol that can be adopted by types that can serialize or deserialize as entity bodies.
 */
public protocol BodyInit {
 
    /**
     Populate an NSURLRequest with this body.
     
     - Parameter request: The (mutable) URL request
     */
    func populateRequest(request: NSMutableURLRequest)
}

/**
 NSData can be a Body to support JSON, BLOB, etc.
 Since the content type is arbitrary, it must be set using Headers.
 */
extension NSData: BodyInit {
    
    public func populateRequest(request: NSMutableURLRequest) {
        request.HTTPBody = self
    }
}

/**
 NSInputStream can be set as a request body
 Since the content type is arbitrary, it must be set using Headers.
 */
extension NSInputStream: BodyInit {
    
    public func populateRequest(request: NSMutableURLRequest) {
        request.HTTPBodyStream = self
    }
}

/**
 Strings are `text/plain;charset=UTF-8`
 */
extension String: BodyInit {
    
    public func populateRequest(request: NSMutableURLRequest) {
        request.HTTPBody = self.dataUsingEncoding(NSUTF8StringEncoding)
        request.setValue("text/plain;charset=UTF-8", forHTTPHeaderField: "Content-Type")
    }
}

/**
 A dictionary can be a body for `application/x-www-form-urlencoded`
 */
extension Dictionary: BodyInit {
    
    public func populateRequest(request: NSMutableURLRequest) {
        // TODO: convert to form-urlencoded
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
    }
}


