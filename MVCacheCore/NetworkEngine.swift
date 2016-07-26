//
//  NetworkEngine.swift
//  MVCache
//
//  Created by Light Dream on 26/07/2016.
//  Copyright © 2016 mindvalley. All rights reserved.
//

import Foundation
import Alamofire
import ReactiveCocoa

public struct NetworkEngine {
    
    public init() {
        
    }
    
    public func resourceProducer<T: Serializable>(method: Alamofire.Method, url: NSURL, params: [String: AnyObject]? = nil, serializer: T) -> SignalProducer<T.SerializedObject, T.ErrorObject> {
        
        var encoding: ParameterEncoding
        
        switch method {
        case .GET:
            encoding = ParameterEncoding.URL
        default:
            encoding = ParameterEncoding.JSON
        }
        
        var request: Request!
        
        let signalProducer = SignalProducer<T.SerializedObject, T.ErrorObject> { observer, disposable in
            
            // because I'm not trying to reinvent the wheel.
            request = Alamofire.request(method, url, parameters: params, encoding: encoding, headers: nil)
            
            // even though alamofire uses nsurlcache internally, but that depends on the protocol cache (i.e: HTTP headers (`Cache-Control` and stuff), so this will ensure caching is done on all requests, regardless..
            if let cachedResponse = NSURLCache.sharedURLCache().cachedResponseForRequest(request.request!) {
                let result = serializer.serializeObject(cachedResponse.data)
                switch result {
                case .Failure(let error):
                    observer.sendFailed(error)
                case .Success(let newValue):
                    observer.sendNext(newValue)
                }
            }
            else {
                
                request.responseData(completionHandler: { (response: Response<NSData, NSError>) in
                    
                    switch response.result {
                    case .Failure(let error):
                        let errorObj: T.ErrorObject = error as! T.ErrorObject
                        observer.sendFailed(errorObj)
                    case .Success(let value):
                        
                        let cachedURLResponse = NSCachedURLResponse(response: response.response!, data: value, userInfo: nil, storagePolicy: .AllowedInMemoryOnly)
                        NSURLCache.sharedURLCache().storeCachedResponse(cachedURLResponse, forRequest: response.request!)
                        
                        
                        let result = serializer.serializeObject(value)
                        switch result {
                        case .Failure(let error):
                            observer.sendFailed(error)
                        case .Success(let newValue):
                            observer.sendNext(newValue)
                        }
                    }
                    observer.sendCompleted()
                    
                })
            }
        }
        
        // ability to cancel requests. Disposing the producer would call the interrupted event, best place for cleaning up.
        let interruptedProducer = signalProducer.on(interrupted: {
            request.cancel()
        })
        
        
        return interruptedProducer
    }
    
}

// provide default convenience method for quick image serialized response
public extension NetworkEngine {
    public func imageProducer(method: Alamofire.Method, url: NSURL, params: [String: AnyObject]? = nil) -> SignalProducer<UIImage, NSError> {
        let serializer = ImageSerializer()
        return self.resourceProducer(method, url: url, params: params, serializer: serializer)
    }
}

// provide default convenience method for quick json serialized response
public extension NetworkEngine {
    public func jsonProducer(method: Alamofire.Method, url: NSURL, params: [String: AnyObject]? = nil) -> SignalProducer<AnyObject, NSError> {
        let serializer = JSONSerializer()
        return self.resourceProducer(method, url: url, params: params, serializer: serializer)
    }
}

public extension NetworkEngine {
    public func stringProducer(method: Alamofire.Method, url: NSURL, params: [String: AnyObject]? = nil) -> SignalProducer<String, NSError> {
        let serializer = StringSerializer()
        return self.resourceProducer(method, url: url, params: params, serializer: serializer)
    }
}
