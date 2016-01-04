//
//  DetailViewController.swift
//  MemeMe 2.0
//
//  Created by Jorge Plaza on 1/1/16.
//  Copyright © 2016 Jorge Plaza. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var memeImage: UIImageView!
    
    var memeIndex:Int?
    var memes: [Meme] {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).memesList
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated:Bool) {
        super.viewWillAppear(animated)
        let editButton = UIBarButtonItem(title: "Edit", style: .Plain, target: self, action: Selector("editMeme"))
        navigationItem.rightBarButtonItem = editButton
        tabBarController?.tabBar.hidden = true
        
        if let index = memeIndex {
            memeImage.image = memes[index].memedImage
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.hidden = false
    }
    
    func editMeme() {
        let object: AnyObject = storyboard!.instantiateViewControllerWithIdentifier("MemeEditorVC")
        let memeEditorVC = object as! EditMemesViewController
        memeEditorVC.memeIndex = memeIndex!
        
        navigationController!.presentViewController(memeEditorVC, animated: false, completion: nil)
    }

}
