//
//  UIImageViewExtension.swift
//  MVCache
//
//  Created by Light Dream on 26/07/2016.
//  Copyright © 2016 mindvalley. All rights reserved.
//

import Foundation
import UIKit
import MVCacheCore

extension UIImageView {
    
    func loadImageFromURL(url: NSURL) {
        let networkEngine = NetworkEngine()
        let producer = networkEngine.imageProducer(.GET, url: url)
        producer.startWithNext { (image: UIImage) in
            self.image = image
            self.setNeedsDisplay()
        }
    }
}