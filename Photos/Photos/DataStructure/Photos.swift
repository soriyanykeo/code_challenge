//
//  Photos.swift
//  Photos
//
//  Created by Soriyany Keo on 6/12/16.
//  Copyright © 2016 Soriyany. All rights reserved.
//

import Foundation
import UIKit

class Photos: NSObject {
    var id: Int?
    var title: String?
    var url: String?
    var thumbnailUrl: String?
}
extension Photos{
    func mapJSONPhoto(photo:NSDictionary) -> Photos {
        self.id = photo.objectForKey("id") as? Int
        self.title = photo.objectForKey("title") as? String
        self.url = photo.objectForKey("url") as? String
        self.thumbnailUrl = photo.objectForKey("thumbnailUrl") as? String
        return self
    }
    func loadThumbnailUrl(completionHandler: (success:Bool,image:UIImage)->Void){
        NSURLSession.sharedSession().dataTaskWithURL( NSURL(string:self.thumbnailUrl!)!, completionHandler: {
            (data, response, error) -> Void in
            dispatch_async(dispatch_get_main_queue()) {
                var image:UIImage = UIImage()
                if let data = data {
                    image = UIImage(data: data)!
                    completionHandler(success: true,image: image)
                }
                else{
                    completionHandler(success: false,image: image)
                }
            }
        }).resume()
    }
    func loadUrl(completionHandler: (success:Bool,image:UIImage)->Void){
        NSURLSession.sharedSession().dataTaskWithURL( NSURL(string:self.url!)!, completionHandler: {
            (data, response, error) -> Void in
            dispatch_async(dispatch_get_main_queue()) {
                var image:UIImage = UIImage()
                if let data = data {
                    image = UIImage(data: data)!
                    completionHandler(success: true,image: image)
                }
                else{
                    completionHandler(success: false,image: image)
                }
            }
        }).resume()
    }
}
