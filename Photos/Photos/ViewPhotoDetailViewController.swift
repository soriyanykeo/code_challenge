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
    var photo:Photos!
    var photosave:PhotoDownLoaded!
    var downloadAnimatingDL:Bool!
    
    @IBOutlet weak var downloadCircleImage: UIImageView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var progressLabel: UILabel!
    lazy var downloadsSession: NSURLSession = {
        let configuration = NSURLSessionConfiguration.backgroundSessionConfigurationWithIdentifier("bgSessionConfiguration")
        let session = NSURLSession(configuration: configuration, delegate: self, delegateQueue: nil)
        return session
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = String(self.photo.title!)
        dispatch_async(dispatch_get_main_queue()) {
            self.photo.loadUrl({ (success, image) in
                if success == true{
                    self.imageView.image = image
                }
                else{
                    let alert = UIAlertController(title: "PHOTO ALBUM", message: "There is an error of loading photo.", preferredStyle: UIAlertControllerStyle.Alert)
                    // add an action (button)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                    // show the alert
                    self.presentViewController(alert, animated: true, completion: nil)
                }
            })
        }
        self.downloadAnimatingDL = false
    }
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        self.downloadsSession.finishTasksAndInvalidate();
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func saveBttnAction(sender: AnyObject) {
        self.downloadAnimatingDL = true
        self.spinDownloadDL(UIViewAnimationOptions.CurveEaseIn)
        photosave = PhotoDownLoaded(photo: photo, downloadsSession: self.downloadsSession)
        photosave.savePhoto()
    }
    
    func spinDownloadDL(options:UIViewAnimationOptions){
        let pi:CGFloat = CGFloat(M_PI/2)
        self.downloadCircleImage.hidden = false
        self.progressLabel.hidden = false
        UIView.animateWithDuration(0.2, delay: 0.0, options:[options], animations: { () -> Void in
            self.downloadCircleImage.transform = CGAffineTransformRotate(self.downloadCircleImage.transform, pi);
            }, completion: {
                finished in
                if self.downloadAnimatingDL == true{
                    self.spinDownloadDL(UIViewAnimationOptions.CurveLinear)
                }
                else if(options != UIViewAnimationOptions.CurveEaseOut){
                    self.spinDownloadDL(UIViewAnimationOptions.CurveEaseOut)
                    self.downloadCircleImage.hidden = true
                    self.progressLabel.hidden = true
                    self.progressLabel.text = ""
                }
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

//NSURLSessionDownloadDelegate
extension ViewPhotoDetailViewController: NSURLSessionDownloadDelegate {
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didFinishDownloadingToURL location: NSURL) {
        let data = NSData(contentsOfURL: location)
        let imageToSave: UIImage = UIImage(data: data!)!
        UIImageWriteToSavedPhotosAlbum(imageToSave, nil, nil, nil)
        self.downloadAnimatingDL = false
        self.spinDownloadDL(UIViewAnimationOptions.CurveEaseIn)
    }
    
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        photosave.progress = Float(totalBytesWritten)/Float(totalBytesExpectedToWrite)
        dispatch_async(dispatch_get_main_queue(), {
            self.progressLabel.text = String(format: "%.0f%%",  self.photosave.progress * 100)
        })
    }
}
