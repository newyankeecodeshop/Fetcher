//
//  Body.swift
//  Fetcher
//
//  Created by Andrew on 5/5/16.
//  Copyright © 2016 Seaview Software LLC. All rights reserved.
//

import Foundation

/**
 * A protocol that can be adopted by types that can serialize or deserialize as entity bodies.
 */
public protocol Body {
 
    /* Depending on the type of body, will use NSData or Stream */
    func populateRequest(request: NSMutableURLRequest)
}

/**
 * NSData can be a Body to support JSON, BLOB, etc.
 */
extension NSData: Body {
    
    public func populateRequest(request: NSMutableURLRequest) {
        request.HTTPBody = self
    }
}

/**
 * Strings are `text/plain;charset=UTF-8`
 */
extension String: Body {
    
    public func populateRequest(request: NSMutableURLRequest) {
        request.HTTPBody = self.dataUsingEncoding(NSUTF8StringEncoding)
        request.setValue("text/plain;charset=UTF-8", forHTTPHeaderField: "Content-Type")
    }
}


