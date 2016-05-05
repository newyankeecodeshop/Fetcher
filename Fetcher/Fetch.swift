//
//  Fetcher.swift
//  Fetcher
//
//  Created by Andrew on 5/4/16.
//  Copyright © 2016 Seaview Software LLC. All rights reserved.
//

import Foundation

protocol Fetch {
    
    func fetch(url: NSURL, _ request: RequestInit) -> Promise<Response>
}

/**
 * Default implementation is on NSURLSession
 */
extension NSURLSession: Fetch {
    
    func fetch(url: NSURL, _ requestInit: RequestInit = RequestInit()) -> Promise<Response> {
        let deferred = Deferred<Response>()
        
        // Make an NSURLRequest from the url and the init
        let request = requestInit.makeRequest(url)
        
        // TODO: the task
        //
        let task = self.dataTaskWithRequest(request) { (data, response, error) in
            if let e = error {
                deferred.reject(e)
            }
            else if let r = response {
                deferred.resolve(Response(r as! NSHTTPURLResponse, data: data))
            }
        }
        
        task.resume()
        
        return deferred
    }
}