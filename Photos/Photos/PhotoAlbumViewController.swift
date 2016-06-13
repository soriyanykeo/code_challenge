//
//  ViewController.swift
//  Photos
//
//  Created by Soriyany Keo on 6/12/16.
//  Copyright © 2016 Soriyany. All rights reserved.
//

import UIKit

class PhotoAlbumViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {
    @IBOutlet weak var photoCollection: UICollectionView!
    var data:NSArray = [Albums]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let photoServices:PhotoService = PhotoService(url: URLSTRING)
        photoServices.getPhotosFeed { (success, albumList) in
            if success == true{
                //                for albumDict in albumList!{
                //                    for photo in albumDict.photoList{
                //                        if photo.id == 1{
                //                            let photosave:PhotoDownLoaded = PhotoDownLoaded(photo: photo, downloadsSession: self.downloadsSession)
                //                            photosave.savePhoto({ (success) in
                //
                //                            })
                //                        }
                //                    }
                //                }
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
                    self.data = albumList!
                    dispatch_async(dispatch_get_main_queue()) {
                        self.photoCollection.reloadData()
                    }
                }
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
                photo.loadThumbnailUrl({ (image) in
                    imageView.image = image
                })
            }
            
            
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


