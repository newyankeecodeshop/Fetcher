//
//  Headers.swift
//  Fetcher
//
//  Created by Andrew on 5/4/16.
//  Copyright © 2016 Seaview Software LLC. All rights reserved.
//

import Foundation

/* https://fetch.spec.whatwg.org/#http-whitespace-bytes */
let HttpWhiteSpaceSet = NSCharacterSet(charactersInString: "\0x09\0x0A\0x0D\0x20")

public class Headers {
    // An ordered list of key-value pairs with potentially duplicate keys.
    var headerList: Array<(String, String)> = []
    
    // TODO: initializers with Headers, Array, Dictionary
    // TODO: support "subscript" operator with get/set

    public func append(name: String, value: String) {
        // Add the name/value pair to the end of the list
        headerList.append((name, value.stringByTrimmingCharactersInSet(HttpWhiteSpaceSet)))
    }
    
    public func delete(name: String) {
        // remove all headers with given name
        headerList = headerList.filter({ (hdrName, hdrValue) -> Bool in
            return hdrName.caseInsensitiveCompare(name) == .OrderedSame
        })
    }
    
    public func get(name: String) -> String? {
        return combinedValue(headerList.filter({ (hdrName, hdrValue) -> Bool in
            return hdrName.caseInsensitiveCompare(name) == .OrderedSame
        }))
    }
    
    public func has(name: String) -> Bool {
        return headerList.contains({ (hdrName, hdrVale) -> Bool in
            return hdrName.caseInsensitiveCompare(name) == .OrderedSame
        })
    }
    
    public func set(name: String, value: String) {
        let normValue = value.stringByTrimmingCharactersInSet(HttpWhiteSpaceSet)
        
        // If value already in list, replace value and remove all others
        let index = headerList.indexOf({ (hdrName, hdrVale) -> Bool in
            return hdrName.caseInsensitiveCompare(name) == .OrderedSame
        })
        
        if let i = index {
            headerList[i] = (name, normValue)
        } else {
            headerList.append((name, normValue))
        }
    }
    
    func combinedValue(headers: Array<(String, String)>) -> String {
        return headers.map({ (hdrName, hdrValue) in return hdrValue }).joinWithSeparator(",")
    }
    
    func populateRequest(request: NSMutableURLRequest) {
        
    }
}