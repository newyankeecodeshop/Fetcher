//
//  Promise.swift
//  Fetcher
//
//  Created by Andrew on 5/4/16.
//  Copyright © 2016 Seaview Software LLC. All rights reserved.
//

import Foundation

enum State<T> {
    case Pending
    case Fulfilled(T)
    case Rejected(ErrorType)
}

/**
 The core Promise class
 */
public class Promise<V> {
    private var state: State<V> = .Pending
    private var resolver: ((state: State<V>) -> Void)?
    
    /**
     The standard initializer
     */
    init (_ executor: (resolve: (V) -> Void, reject: (ErrorType) -> Void) throws -> Void) {
        
        func resolve(value: V) {
            self.become(.Fulfilled(value))
        }
        func reject(error: ErrorType) {
            self.become(.Rejected(error))
        }
        
        // Call the executor right away
        do {
            try executor(resolve: resolve, reject: reject)
        }
        catch {
            reject(error)
        }
    }
    
    init (_ error: ErrorType) {
        self.become(.Rejected(error))
    }
    
    /**
     An initializer when using Cocoa APIs that take a completion handler.
     */
    convenience init (_ executor: (completionHandler: (V?, NSError?) -> Void) -> Void) {
        
        self.init({ resolve, reject in
            func handler(value: V?, error: NSError?) {
                if let error = error {
                    reject(error)
                } else if let value = value {
                    resolve(value)
                } else {
                    //TODO: reject(UnhandledCompletionError)
                }
            }
            executor(completionHandler: handler)
        })
    }
    
    /**
     Return a new promise and provides a function to call during resolution.
     
     - Parameter onFulfilled: The function called when the promise is resolved. It has one argument, the value.
     - Returns: A new promise
     */
    public func then<V2>(onFulfilled: (V) throws -> V2) -> Promise<V2> {
        
        return Promise<V2>({ (resolve, reject) in
            func fulfill(value: V) {
                do {
                    try resolve(onFulfilled(value))
                } catch {
                    reject(error)
                }
            }
            func resolver(newState: State<V>) {
                switch newState {
                case .Fulfilled(let value):
                    fulfill(value)
                case .Rejected(let error):
                    reject(error)
                case .Pending:
                    return
                }
            }
            self.resolver = resolver
        });
    }
    
    public func catch_(onRejected: (ErrorType) throws -> Void) -> Promise<V> {

        return Promise<V>({ (resolve, reject) in
            func invoke(error: ErrorType) {
                do {
                    try onRejected(error)
                } catch {
                    reject(error)
                }
            }
            func resolver(newState: State<V>) {
                switch newState {
                case .Fulfilled(let value):
                    resolve(value)
                case .Rejected(let error):
                    invoke(error)
                case .Pending:
                    return
                }
            }
            self.resolver = resolver
        });
    }
    
    private func become(newState: State<V>) {
        // TODO: Verify the transitions between states
        self.state = newState
        
        dispatch_async(dispatch_get_main_queue()) {
            self.resolver?(state: newState)
        }
    }
}

class Deferred<Value> : Promise<Value> {
    
}