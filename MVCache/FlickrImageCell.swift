//
//  FlickrImageCell.swift
//  MVCache
//
//  Created by Light Dream on 26/07/2016.
//  Copyright © 2016 mindvalley. All rights reserved.
//

import Foundation
import UIKit

class FlickrImageCell: UITableViewCell {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var myImageView: UIImageView!
    
    func configure(data: FlickrData) {
        self.myImageView.loadImageFromURL(NSURL(string: data.media)!)
        self.titleLabel.text = data.title
    }
}