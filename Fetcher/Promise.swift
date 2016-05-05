//
//  Promise.swift
//  Fetcher
//
//  Created by Andrew on 5/4/16.
//  Copyright © 2016 Seaview Software LLC. All rights reserved.
//

import Foundation

public class Promise<Value> {
    
    public typealias SuccessFunc = (Value) throws -> AnyObject
    public typealias ErrorFunc = (NSError) throws -> AnyObject
    
    private var successFunc: SuccessFunc?
    private var errorFunc: ErrorFunc?
    
    public func then(onFulfilled: SuccessFunc) -> Promise<Value> {
        self.successFunc = onFulfilled
        
        return Promise()
    }

    public func then(onFulfilled: SuccessFunc, onRejected: ErrorFunc) -> Promise<Value> {
        self.successFunc = onFulfilled
        self.errorFunc = onRejected
        
        return Promise()
    }
    
    public func catch_(onRejected: ErrorFunc) -> Promise<Value> {
        self.errorFunc = onRejected

        return Promise()
    }
}

class Deferred<Value> : Promise<Value> {

    func resolve(value: Value) {
        do {
            try self.successFunc?(value)
        } catch let error as NSError {
            try! self.errorFunc?(error)
        }
    }
    
    func reject(error: NSError) {
        try! self.errorFunc?(error)
    }
    
}