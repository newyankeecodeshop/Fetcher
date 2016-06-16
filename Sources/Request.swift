//
//  Request.swift
//  Fetcher
//
//  Created by Andrew on 5/4/16.
//  Copyright © 2016 Seaview Software LLC. All rights reserved.
//

import Foundation

public class Request {
    
}

/**
 The structure containing parameters for the request, including HTTP method, headers, and body content.
 */
public struct RequestInit {
    
    var method: RequestMethod
    var headers: Headers?
    var body: BodyInit?
    var referrer: String?
    var referrerPolicy: String?
    var mode: String?
    var credentials: RequestCredentials
    var cache: RequestCache = .Default
    var redirect: RequestRedirect = .Follow
    var integrity: String?
    
    init(method: RequestMethod = .GET, headers: Headers? = nil,
         body: BodyInit? = nil, credentials: RequestCredentials = .Omit,
         cache: RequestCache = .Default, redirect: RequestRedirect = .Follow) {
        self.method = method
        self.headers = headers
        self.body = body
        self.credentials = credentials
        self.cache = cache
        self.redirect = redirect
    }
}

/* Enumerations from the spec. May not all be useful in this library. */

enum RequestMethod : String {
    case HEAD, GET, POST, PUT, DELETE, OPTIONS, TRACE, CONNECT, PATCH
}

enum RequestType : String {
    case Generic, Audio, Font, Image, Script, Style, Track, Video
}

enum RequestCredentials : String {
    case Omit, SameOrigin, Include
}

enum RequestCache : String {
    case Default, NoStore, Reload, NoCache, ForceCache
}

enum RequestRedirect : String {
    case Follow, Error, Manual
}

/**
 * Extension for dealing with the URL Session Subsystem
 */
extension RequestInit {
    
    func makeRequest(url: NSURL) -> NSURLRequest {
        let request = NSMutableURLRequest(URL: url)
        
        request.HTTPMethod = method.rawValue
        request.cachePolicy = makeCachePolicy()
        request.HTTPShouldHandleCookies = (credentials != .Omit)
        
        headers?.populateRequest(request)
        body?.populateRequest(request)
        
        return request
    }
    
    func makeCachePolicy() -> NSURLRequestCachePolicy {
        switch cache {
        case .Default:
            return .UseProtocolCachePolicy
        case .Reload:
            return .ReloadIgnoringLocalCacheData
        case .ForceCache:
            return .ReturnCacheDataElseLoad
        default:
            return .UseProtocolCachePolicy
        }
    }

}
