//
//  ViewPhotoDetailViewController.swift
//  Photos
//
//  Created by Soriyany Keo on 6/12/16.
//  Copyright © 2016 Soriyany. All rights reserved.
//

import Foundation
import UIKit

class ViewPhotoDetailViewController: UIViewController{
    @IBOutlet weak var imageView: UIImageView!
    var photo:Photos!
    
    
    lazy var downloadsSession: NSURLSession = {
        let configuration = NSURLSessionConfiguration.backgroundSessionConfigurationWithIdentifier("bgSessionConfiguration")
        let session = NSURLSession(configuration: configuration, delegate: self, delegateQueue: nil)
        return session
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        photo.loadUrl({ (image) in
            self.imageView.image = image
        })
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func saveBttnAction(sender: AnyObject) {
        let photosave:PhotoDownLoaded = PhotoDownLoaded(photo: photo, downloadsSession: self.downloadsSession)
        photosave.savePhoto({ (success) in
            
        })
        
    }
}
extension ViewPhotoDetailViewController: NSURLSessionDelegate {
    func URLSessionDidFinishEventsForBackgroundURLSession(session: NSURLSession) {
        if let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate {
            if let completionHandler = appDelegate.backgroundSessionCompletionHandler {
                appDelegate.backgroundSessionCompletionHandler = nil
                dispatch_async(dispatch_get_main_queue(), {
                    completionHandler()
                })
            }
        }
    }
    func localFilePathForUrl(previewUrl: String) -> NSURL? {
        let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as NSString
        if let url = NSURL(string: previewUrl), lastPathComponent = url.lastPathComponent {
            let fullPath = documentsPath.stringByAppendingPathComponent(lastPathComponent)
            return NSURL(fileURLWithPath:fullPath)
        }
        return nil
    }
}

// MARK: - NSURLSessionDownloadDelegate

extension ViewPhotoDetailViewController: NSURLSessionDownloadDelegate {
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didFinishDownloadingToURL location: NSURL) {
        let data = NSData(contentsOfURL: location)
        let imageToSave: UIImage = UIImage(data: data!)!
        
        
        UIImageWriteToSavedPhotosAlbum(imageToSave, nil, nil, nil)
        // 3
        //        if let url = downloadTask.originalRequest?.URL?.absoluteString {
        //            //                    activeDownloads[url] = nil
        //            // 4
        //            //                    if let trackIndex = trackIndexForDownloadTask(downloadTask) {
        //            //                        dispatch_async(dispatch_get_main_queue(), {
        //            //                            self.tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: trackIndex, inSection: 0)], withRowAnimation: .None)
        //            //                        })
        //            //                    }
        //        }
    }
    
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        
        // 1
        //        if let downloadUrl = downloadTask.originalRequest?.URL?.absoluteString,
        //            download = activeDownloads[downloadUrl] {
        //            // 2
        //            download.progress = Float(totalBytesWritten)/Float(totalBytesExpectedToWrite)
        //            // 3
        //            let totalSize = NSByteCountFormatter.stringFromByteCount(totalBytesExpectedToWrite, countStyle: NSByteCountFormatterCountStyle.Binary)
        //            // 4
        //            if let trackIndex = trackIndexForDownloadTask(downloadTask), let trackCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: trackIndex, inSection: 0)) as? TrackCell {
        //                dispatch_async(dispatch_get_main_queue(), {
        //                    trackCell.progressView.progress = download.progress
        //                    trackCell.progressLabel.text =  String(format: "%.1f%% of %@",  download.progress * 100, totalSize)
        //                })
        //            }
        //        }
    }
}
