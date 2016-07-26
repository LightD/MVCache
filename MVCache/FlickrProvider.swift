//
//  FlickrHandler.swift
//  MVCache
//
//  Created by Light Dream on 26/07/2016.
//  Copyright © 2016 mindvalley. All rights reserved.
//

import Foundation
import ReactiveCocoa
import Result
import MVCacheCore

struct FlickrProvider {
    private let networkEngine = NetworkEngine()
    
    func getData() -> SignalProducer<[FlickrData], NSError> {
        let dataProducer = networkEngine.stringProducer(.GET, url: NSURL(string: "https://api.flickr.com/services/feeds/photos_public.gne?tags=cute&format=json&nojsoncallback=1")!)
        
        // Note: this can be replaced with a proper mapping layer
        return dataProducer.attemptMap { (obj: String) -> Result<[FlickrData], NSError> in
            // stupid flickr -_____-
            let validResponse = obj.stringByReplacingOccurrencesOfString("\\\'", withString: "\'", options: NSStringCompareOptions.LiteralSearch, range: nil)
            let data: NSData = validResponse.dataUsingEncoding(NSUTF8StringEncoding)!
            
            do {
                
                let json = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments)
                let feed = json as! [String: AnyObject]
                let items = feed["items"] as! [[String: AnyObject]]
                var flickrs: [FlickrData] = []
                for item in items {
                    let media = item["media"] as! [String: AnyObject]
                    let imageData = FlickrData(title: item["title"] as! String, media: media["m"] as! String)
                    flickrs.append(imageData)
                }
                return .Success(flickrs)
            }
            catch let error as NSError {
                return .Failure(error)
            }
        }
        
    }
}

