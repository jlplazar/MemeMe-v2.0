//
//  SentMemesGridViewController.swift
//  MemeMe 2.0
//
//  Created by Jorge Plaza on 12/30/15.
//  Copyright © 2015 Jorge Plaza. All rights reserved.
//

import UIKit

class SentMemesGridViewController: UICollectionViewController {
    
    let space:CGFloat = 3.0
    @IBOutlet weak var flowLayout:UICollectionViewFlowLayout!
    
    var memes: [Meme] {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).memesList
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func viewDidAppear(animated: Bool) {
        collectionView?.reloadData()
        
        let dimension = (view.frame.size.width - 2 * space ) / 3.0
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: dimension, height: dimension)
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MemeCell", forIndexPath: indexPath) as! MemeCollectionViewCell
        cell.memeImage.image = memes[indexPath.row].memedImage
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        //Open detail view
        let object: AnyObject = storyboard!.instantiateViewControllerWithIdentifier("memeDetailVC")
        let detailVC = object as! DetailViewController
        
        //Populate view controller with data from the selected item
        detailVC.memeIndex = indexPath.row
        
        //Present the view controller using navigation
        navigationController!.pushViewController(detailVC, animated: true)
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        
        let dimension = (size.width - 2 * space ) / 3.0
        if flowLayout != nil {
            flowLayout.itemSize = CGSize(width: dimension, height: dimension)
        }
    }
    
}

