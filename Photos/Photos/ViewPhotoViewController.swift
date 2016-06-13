//
//  ViewPhotoViewController.swift
//  Photos
//
//  Created by Soriyany Keo on 6/12/16.
//  Copyright © 2016 Soriyany. All rights reserved.
//

import Foundation
import UIKit

class ViewPhotoViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource{
    var album:Albums!
    var data:NSArray = [Albums]()
    
    @IBOutlet weak var photoCollection: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("album list:\(album)")
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            self.data = self.album.photoList
            dispatch_async(dispatch_get_main_queue()) {
                self.photoCollection.reloadData()
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
//        let albumLabel:UILabel = cell.viewWithTag(101) as! UILabel
        if data.count > 0 {
            let photo:Photos = data.objectAtIndex(indexPath.row) as! Photos
                photo.loadThumbnailUrl({ (image) in
                    imageView.image = image
                })
            
//            let albumID:String = String(album.albumID!)
//            let photoCounted:String = String(album.photoList.count)
//            let albumString:String = "ALBUM " + albumID + " (" +  photoCounted + ")"
//            albumLabel.text = albumString
            
        }
        return cell;
    }
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let photo:Photos = data.objectAtIndex(indexPath.row) as! Photos
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewPhotoDetailVC:ViewPhotoDetailViewController =  storyboard.instantiateViewControllerWithIdentifier("viewPhotoDetailVC") as! ViewPhotoDetailViewController
        viewPhotoDetailVC.photo = photo
        self.navigationController?.pushViewController(viewPhotoDetailVC, animated: true)
    }

}