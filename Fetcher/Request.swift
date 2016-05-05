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

public struct RequestInit {
    
    var method: String = "GET"
    var headers: Headers?
    var body: Body?
    var referrer: String?
    var referrerPolicy: String?
    var mode: String?
    var credentials: RequestCredentials = .Omit
    var cache: RequestCache = .Default
    var redirect: RequestRedirect = .Follow
    var integrity: String?
}

/* Enumerations from the spec. May not all be useful in this library. */

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
        
        request.HTTPMethod = method
        request.cachePolicy = makeCachePolicy()
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
