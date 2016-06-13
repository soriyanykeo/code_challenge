//
//  PhotoDownLoaded.swift
//  Photos
//
//  Created by Soriyany Keo on 6/12/16.
//  Copyright © 2016 Soriyany. All rights reserved.
//

import Foundation
class PhotoDownLoaded: NSObject {
//    var activeDownloads = [String: Photos]()
    var photo: Photos
    var downloadsSession: NSURLSession
    
    var isDownloading = false
    var progress: Float = 0.0
    
    var downloadTask: NSURLSessionDownloadTask?
    var resumeData: NSData?
    
    init(photo: Photos,downloadsSession:NSURLSession) {
        self.photo = photo
        self.downloadsSession = downloadsSession
    }
    func savePhoto(completionHandler: (success : Bool)->Void){
        startDownload()
    }
    // Called when the Download button for a track is tapped
    func startDownload() {
        if let urlString = self.photo.url, url =  NSURL(string: urlString) {
            downloadTask = self.downloadsSession.downloadTaskWithURL(url)
            downloadTask!.resume()
            isDownloading = true
        }
    }
}

