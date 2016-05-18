//
//  Response.swift
//  Fetcher
//
//  Created by Andrew on 5/4/16.
//  Copyright © 2016 Seaview Software LLC. All rights reserved.
//

import Foundation

public class Response {
    
    let type: ResponseType
    let url: NSURL
    let redirected: Bool
    let status: Int
    let statusText: String
    let headers: Headers
    let body: NSData?
    
    var ok: Bool {
        return (200...299).contains(status)
    }
    
    init (_ response: NSHTTPURLResponse, data: NSData?) {
        type = .Default
        url = response.URL!
        status = response.statusCode
        headers = ResponseHeaders(response)
        body = data

        // TODO: This comes from the text after the status code
        statusText = "OK"

        // TODO: Can't tell this just from the response object
        redirected = false
    }
}

enum ResponseType: String {
    case Basic, CORS, Default, Error, Opaque, OpaqueRedirect
}

/**
 * Special implementation which creates an immutable set of headers
 */
class ResponseHeaders : Headers {
    let allHeaderFields: [NSObject : AnyObject]
    
    init(_ response: NSHTTPURLResponse) {
        allHeaderFields = response.allHeaderFields
        super.init()
    }
    
    override func get(name: String) -> String? {
        // TODO: What about mult-value headers?
        return allHeaderFields[name]?.description
    }
    
    override func has(name: String) -> Bool {
        return allHeaderFields[name] != nil
    }
    
    override func append(name: String, _ value: String) {
        // Throw error
    }
    
    override func delete(name: String) {
        // Throw error
    }
    
    override func set(name: String, _ value: String) {
        // Throw error
    }
}

extension Response: Body {
    
    public func arrayBuffer() -> Promise<ContiguousArray<UInt8>> {
        return Promise({ (resolve, reject) in
            if let data = self.body {
                var bytes = ContiguousArray<UInt8>(count: data.length, repeatedValue: 0)
                data.getBytes(&bytes, length: bytes.count)
                resolve(bytes)
            } else {
                reject(NSError(domain: "", code: -100, userInfo: nil))
            }
        })
    }
    public func blob() -> Promise<NSData> {
        return Promise({ (resolve, reject) in
            if let data = self.body {
                resolve(data)
            } else {
                reject(NSError(domain: "", code: -100, userInfo: nil))
            }
        })
    }
    public func formData() -> Promise<FormData> {
        return Promise({ (resolve, reject) in
            if self.body != nil {
                resolve(FormData())
            } else {
                reject(NSError(domain: "", code: -100, userInfo: nil))
            }
        })
    }
    public func json() -> Promise<AnyObject> {
        return Promise({ (resolve, reject) in
            do {
                try resolve(NSJSONSerialization.JSONObjectWithData(
                    self.body!, options: NSJSONReadingOptions(rawValue: 0)))
            } catch {
                reject(error)
            }
        })
    }
    public func text() -> Promise<String> {
        return Promise({ (resolve, reject) in
            if let data = self.body {
                if let text = NSString(data: data, encoding: NSUTF8StringEncoding) {
                    resolve(text as String)
                } else {
                    reject(NSError(domain: "", code: -100, userInfo: nil))
                }
            } else {
                reject(NSError(domain: "", code: -100, userInfo: nil))
            }
        })
    }
}