//
//  SentMemesViewController.swift
//  MemeMe
//
//  Created by Zachary Collins on 9/10/16.
//  Copyright © 2016 dumpstertree. All rights reserved.
//

import UIKit

class SentMemesTableViewController: UITableViewController {

    @IBOutlet weak var toolbar: UINavigationItem!
    var clickedMemeIndex: Int?
    
    var memes: [Meme] {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).memes
    }
    
    
    // View 
    override func viewWillAppear(animated: Bool) {
        tableView?.reloadData()
    }
    
    // Generate Meme
    @IBAction func newMeme(sender: AnyObject) {
        performSegueWithIdentifier("EditMeme", sender: nil)
    }
    
    // Table View Delegate
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.memes.count
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("MemeCell")!
        let meme = self.memes[indexPath.row]
        
        // Set the name and image
        cell.textLabel?.text = meme.topText
        cell.imageView?.image = meme.newImage
        
        // If the cell has a detail label, we will put the evil scheme in.
        if let detailTextLabel = cell.detailTextLabel {
            detailTextLabel.text = meme.bottomText
        }
        
        return cell
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        clickedMemeIndex = indexPath.row
        performSegueWithIdentifier("ViewMeme", sender: memes[indexPath.row] as? AnyObject )
    }
    
    // Segue 
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "ViewMeme"{
            let nextView = segue.destinationViewController as! ViewMemeViewController
            nextView.meme = memes[clickedMemeIndex!]
        }
    }
}
