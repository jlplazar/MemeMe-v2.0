//
//  SentMemesTableViewController.swift
//  MemeMe 2.0
//
//  Created by Jorge Plaza on 12/30/15.
//  Copyright © 2015 Jorge Plaza. All rights reserved.
//

import UIKit

class SentMemesTableViewController: UITableViewController {
    
    var memes: [Meme] {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).memesList
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MemeCell", forIndexPath: indexPath) as! MemeTableViewCell
        cell.topLabel.text = memes[indexPath.row].topText
        cell.bottomLabel.text = memes[indexPath.row].bottomText
        cell.memeImage.image = memes[indexPath.row].memedImage
        return cell
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            appDelegate.memesList.removeAtIndex(indexPath.row)
            tableView.reloadData()
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        tableView?.reloadData()
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //Open detail view
        let object: AnyObject = storyboard!.instantiateViewControllerWithIdentifier("memeDetailVC")
        let detailVC = object as! DetailViewController
        
        //Populate view controller with data from the selected item
        detailVC.memeIndex = indexPath.row
        
        //Present the view controller using navigation
        navigationController!.pushViewController(detailVC, animated: true)
    }
    

}

