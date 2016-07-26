//
//  ViewController.swift
//  MVCache
//
//  Created by Light Dream on 23/07/2016.
//  Copyright © 2016 mindvalley. All rights reserved.
//

import UIKit
import MVCacheCore
import ReactiveCocoa

class ViewController: UITableViewController {
    let networkEngine = NetworkEngine()
    var data: [FlickrData] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        // MARK: Demonstrate cancelling request.
        let producer: SignalProducer<UIImage, NSError> = networkEngine.imageProducer(.GET, url: NSURL(string: "http://wallpoper.com/images/00/40/99/05/nature-birds_00409905.jpg")!)
        let disposable = producer.startWithNext { image in
            // this will never be called, coz it's cancelled.. yeeeaaaaaah :3
            debugPrint(image)
        }
        
        disposable.dispose()
        
        
        
        // MARK: Actual work
        let flickrProvider = FlickrProvider()
        let flickrDataProducer = flickrProvider.getData()
        flickrDataProducer.on(failed: { error in
            UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: UIAlertControllerStyle.Alert)
            UIAlertView(title: "Error", message: error.localizedDescription, delegate: nil, cancelButtonTitle: "OK").show()
        }).startWithNext { flickrData in
            self.data = flickrData
            self.tableView.reloadData()
        }
        
        // TODO: take care of error messages..
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

// MARK: UITableView stuff
extension ViewController {
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("flickrImage", forIndexPath: indexPath) as! FlickrImageCell
        let imageData = self.data[indexPath.row]
        cell.configure(imageData)
        return cell
    }
}