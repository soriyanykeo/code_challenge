//
//  ViewController.swift
//  Photos
//
//  Created by Soriyany Keo on 6/12/16.
//  Copyright © 2016 Soriyany. All rights reserved.
//

import UIKit

class PhotoAlbumViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var photoCollection: UICollectionView!
    var data:NSArray = [Albums]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        activityIndicator.startAnimating()
        let photoServices:PhotoService = PhotoService(url: URLSTRING)
        photoServices.getPhotosFeed { (success, albumList) in
            if success == true{
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
                    self.data = albumList!
                    dispatch_async(dispatch_get_main_queue()) {
                        self.photoCollection.reloadData()
                    }
                }
            }
            else{
                let alert = UIAlertController(title: "PHOTO ALBUM", message: "There is no photo album.", preferredStyle: UIAlertControllerStyle.Alert)
                // add an action (button)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                // show the alert
                self.presentViewController(alert, animated: true, completion: nil)
            }
            dispatch_async(dispatch_get_main_queue()) {
                self.activityIndicator.stopAnimating()
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let identifier:String = "cell"
        let cell:UICollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier(identifier, forIndexPath: indexPath)
        let imageView:UIImageView = cell.viewWithTag(100) as! UIImageView
        let albumLabel:UILabel = cell.viewWithTag(101) as! UILabel
        if data.count > 0 {
            let album:Albums = data.objectAtIndex(indexPath.row) as! Albums
            let photoArr:NSArray = album.photoList as NSArray
            if photoArr.count > 0 {
                let photo:Photos = photoArr.firstObject as! Photos
                photo.loadThumbnailUrl({ (success, image) in
                    if success == true{
                        imageView.image = image
                    }
                })
            }
            //View Album ID and Sum photo of album
            let albumID:String = String(album.albumID!)
            let photoCounted:String = String(album.photoList.count)
            let albumString:String = "ALBUM " + albumID + " (" +  photoCounted + ")"
            albumLabel.text = albumString
            
        }
        return cell;
    }
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let album:Albums = data.objectAtIndex(indexPath.row) as! Albums
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewPhotoVC:ViewPhotoViewController =  storyboard.instantiateViewControllerWithIdentifier("viewPhotoVC") as! ViewPhotoViewController
        viewPhotoVC.album = album
        self.navigationController?.pushViewController(viewPhotoVC, animated: true)
    }
}


