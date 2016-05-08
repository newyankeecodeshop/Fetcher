//
//  Fetcher.swift
//  Fetcher
//
//  Created by Andrew on 5/4/16.
//  Copyright © 2016 Seaview Software LLC. All rights reserved.
//

import Foundation

/**
 The primary entry to the API. This protocol can be adopted at various levels of your app
 to provide network access.
 */
protocol Fetch {
    
    func fetch(url: NSURL, _ requestInit: RequestInit) -> Promise<Response>
}

/**
 Extends Fetch with useful default behaviors and overrides.
 */
extension Fetch {

    func fetch(url: String, _ requestInit: RequestInit = RequestInit()) -> Promise<Response> {
        if let url = NSURL(string: url) {
            return fetch(url, requestInit)
        } else {
            return Promise(NSURLError.BadURL); // return a rejected promise
        }
    }
}

/**
 Default implementation is on NSURLSession
 */
extension NSURLSession: Fetch {
    
    func fetch(url: NSURL, _ requestInit: RequestInit = RequestInit()) -> Promise<Response> {

        return Promise({ (resolve, reject) in
            // Make an NSURLRequest from the url and the init
            let request = requestInit.makeRequest(url)
            
            // We can use a data task for now...
            let task = self.dataTaskWithRequest(request) { (data, response, error) in
                if let e = error {
                    reject(e)
                }
                else if let r = response {
                    resolve(Response(r as! NSHTTPURLResponse, data: data))
                }
            }
            
            task.resume()
        })
    }
}