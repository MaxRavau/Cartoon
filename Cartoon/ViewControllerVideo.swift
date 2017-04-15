//
//  ViewControllerVideo.swift
//  Cartoon
//
//  Created by Maxime Ravau on 27/03/2017.
//  Copyright © 2017 Maxime Ravau. All rights reserved.
//

import UIKit
import Parse
import XCDYouTubeKit

class ViewControllerVideo: UIViewController {
    
    
    @IBOutlet var labelCategorie: UILabel!
    
    var selectedVideo: PFObject?
    
    var listeVideo = [PFObject]()
    
    var currentCategorie: PFObject?
    
    
    
    fileprivate let cellHeight: CGFloat = 210
   
    fileprivate let cellSpacing: CGFloat = 20
    
    @IBOutlet var myCollectionViewVideo: UICollectionView!


    override func viewDidLoad() {
        super.viewDidLoad()

        myCollectionViewVideo.delegate = self
        myCollectionViewVideo.dataSource = self
        
        initUI()
        // Do any additional setup after loading the view.
    }
    
    func initUI(){
        
        getTitle()
        getVideo()
        
        
    }

        
    func getTitle(){
        
        let categorieTitle = currentCategorie?["Titre"]
        
        labelCategorie.text = categorieTitle as! String?
        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        myCollectionViewVideo.reloadData()
        
        
    }
    
}

extension ViewControllerVideo: UICollectionViewDataSource, UICollectionViewDelegate {
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
        
    }

    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listeVideo.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Prototype2", for: indexPath) as! CollectionViewCellVideo
        
        cell.ImageCover.image = UIImage()
        
        let videoObject: PFObject = listeVideo[indexPath.row]
        
        cell.labelTitre.text = videoObject["Titre"] as! String?
        
        if let userPicture = videoObject["image"] as? PFFile {
            print("get user picture")
            userPicture.getDataInBackground(block: { (imageData: Data?, error: Error?) -> Void in
                print("get user picture response")
                if (error == nil) {
                    print("get user picture no error")
                    cell.ImageCover.image = UIImage(data: imageData!)
                    cell.ImageCover.layer.cornerRadius = 20
                    
                    
                }
            })
            
        }

        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width - cellSpacing, height: cellHeight)
    }


    
    func getVideo(){
        
        let query = PFQuery(className:"Video")
        query.whereKey("categorieVideo", equalTo: currentCategorie)
        query.cachePolicy = PFCachePolicy.cacheThenNetwork
        query.findObjectsInBackground { (objects, error) in
            if error == nil {
                print("Successfully retrieved \(objects!.count) scores.")
                self.listeVideo = objects!
                self.myCollectionViewVideo.reloadData()
                if let listeVideo = objects {
                    for video in listeVideo {
                        let title = video["Titre"]
                        let videoId = video["YoutubeVideoID"]
                        
                        
                        print("\(String(describing: title)) ")
                        print("\(String(describing: videoId))")
                        
                    }
                }
            }
            
        }
    }
    
    
    
    
    
    func playVideo(id: PFObject){
        
        let videoID = selectedVideo?["YoutubeVideoID"]
        
        let youtubeId: String = videoID as! String
        
        
        let videoPlayerViewController = XCDYouTubeVideoPlayerViewController(videoIdentifier: youtubeId)
                
                
            presentMoviePlayerViewControllerAnimated(videoPlayerViewController)
                
        
    }
        
        
        
    
    

    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    
        self.selectedVideo = listeVideo[indexPath.row]
        
        playVideo(id: selectedVideo!)
        
        //et newViewController = ViewControllerPlayer()
        //self.present(newViewController, animated: true, completion: nil)
        
        //newViewController.currentVideo = self.currentCategorie!
        
    }
   
    


    
}
