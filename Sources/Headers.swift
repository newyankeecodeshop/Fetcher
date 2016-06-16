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

/**
 Headers represents an ordered list of key-value pairs with potentially duplicate keys.
 */
public class Headers {
    var headerList: Array<(String, String)>
    
    init () {
        self.headerList = []
    }

    init (_ headerDict: [String : String]) {
        self.headerList = Array(headerDict)
    }

    init (_ headers: Headers) {
        self.headerList = Array(headers.headerList)
    }

    public func append(name: String, _ value: String) {
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
    
    public func set(name: String, _ value: String) {
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
    
    public subscript(name: String) -> String? {
        get {
            return self.get(name)
        }
        set(newValue) {
            if let value = newValue {
                self.set(name, value)
            } else {
                self.delete(name)
            }
        }
    }

    func combinedValue(headers: Array<(String, String)>) -> String {
        if (headers.count == 1) {
            return headers[0].1
        }
        return headers.map({ (hdrName, hdrValue) in return hdrValue }).joinWithSeparator(",")
    }
}

// MARK: NSURLRequest

extension Headers {
    
    func populateRequest(request: NSMutableURLRequest) {
        // Use [addValue:forHTTPHeaderField] so that multiple values are properly encoded.
        for (name, value) in headerList {
            request.addValue(value, forHTTPHeaderField: name)
        }
    }
}