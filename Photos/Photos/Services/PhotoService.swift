//
//  PhotoService.swift
//  Photos
//
//  Created by Soriyany Keo on 6/12/16.
//  Copyright © 2016 Soriyany. All rights reserved.
//

import Foundation

class PhotoService: NSObject {
    let defaultSession = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
    var dataTask: NSURLSessionDataTask?
    
    var url:String
    
    init(url:String) {
        self.url = url
    }
    
    func getPhotosFeed(completionHandler: (success : Bool, albumList: [Albums]?)->Void){
        if dataTask != nil {
            dataTask?.cancel()
        }
        
        let url = NSURL(string:self.url)
        dataTask = defaultSession.dataTaskWithURL(url!) {
            data, response, error in
            if let error = error {
                print(error.localizedDescription)
                completionHandler(success: false,albumList: [])
            } else if let httpResponse = response as? NSHTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    do {
                        let photoList = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as! NSArray
                        var albumList = [Albums]()
                        
                        for photoDict in photoList {
                            let photo:Photos = Photos()
                            photo.mapJSONPhoto(photoDict as! NSDictionary)
                            
                            let albumID:Int = photoDict.objectForKey("albumId") as! Int
                            if albumList.count == 0{
                                let album:Albums = Albums()
                                album.albumID = albumID
                                album.photoList.append(photo)
                                albumList.append(album)
                            }
                            else{
                                var isFound:Bool = false
                                for albumDict in albumList{
                                    if albumDict.albumID == albumID{
                                        albumDict.photoList.append(photo)
                                        isFound = true
                                        break
                                    }
                                    else{
                                        isFound = false
                                    }
                                }
                                if isFound == false{
                                    let album:Albums = Albums()
                                    album.albumID = albumID
                                    album.photoList.append(photo)
                                    albumList.append(album)
                                }
                            }
                        }
                        completionHandler(success: true,albumList: albumList)
                        
                    }catch{
                        completionHandler(success: false,albumList: [])
                    }
                }
            }
        }
        dataTask?.resume()
    }
}
