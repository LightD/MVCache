//
//  Serializable.swift
//  MVCache
//
//  Created by Light Dream on 26/07/2016.
//  Copyright © 2016 mindvalley. All rights reserved.
//

import Foundation
import Alamofire


/// generic protocol that governs the serialization of objects.
public protocol Serializable {
    associatedtype SerializedObject
    associatedtype ErrorObject: ErrorType
    
    func serializeObject(data: NSData) -> Result<Self.SerializedObject, Self.ErrorObject>
}

/// default support for JSON
public struct JSONSerializer: Serializable {
    public typealias SerializedObject = AnyObject
    public typealias ErrorObject = NSError
    
    public func serializeObject(data: NSData) -> Result<AnyObject, NSError> {
        
        do {
            
            let json = try NSJSONSerialization.JSONObjectWithData(data, options: [])
            return .Success(json)
        }
        catch let error as NSError {
            return .Failure(error)
        }
        
    }
}

public struct StringSerializer: Serializable {
    public typealias SerializedObject = String
    public typealias ErrorObject = NSError
    
    public func serializeObject(data: NSData) -> Result<String, NSError> {
        let string = String(data: data, encoding: NSUTF8StringEncoding)
        if let jsonString = string {
            return .Success(jsonString)
        }
        else {
            return .Failure(NSError(domain: "com.mindvalley.MVCCache.StringSerializable", code: 123, userInfo: [NSLocalizedDescriptionKey: "Error happened while trying to serialize the data: \(data) to String"]))
        }
    }
}

/// default support for UIImage
public struct ImageSerializer: Serializable {
    public typealias SerializedObject = UIImage
    public typealias ErrorObject = NSError
    
    public func serializeObject(data: NSData) -> Result<UIImage, NSError> {
        
        
        guard let image = UIImage(data: data) else {
            return .Failure(NSError(domain: "com.mindvalley.MVCCache.ImageSerializable", code: 123, userInfo: [NSLocalizedDescriptionKey: "Error happened while trying to serialize the data: \(data) to UIIMage"]))
        }
        
        
        return .Success(image)
    }
}

