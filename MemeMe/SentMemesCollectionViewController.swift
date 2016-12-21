//
//  SentMemesCollectionViewController.swift
//  MemeMe
//
//  Created by Zachary Collins on 9/11/16.
//  Copyright © 2016 dumpstertree. All rights reserved.
//

import UIKit

class SentMemesCollectionViewController: UICollectionViewController {

    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    var clickedMemeIndex: Int?
    var memes: [Meme] {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).memes
    }
    
    // View
    override func viewWillAppear(animated: Bool) {
        collectionView?.reloadData()
    }
    override func viewDidLoad() {
        let space: CGFloat = 3.0
        let width = ((self.view.frame.size.width - (2*space)) / 3.0)
        let height = ((self.view.frame.size.height - (4*space)) / 5.0)
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSizeMake( width, height)
        
        super.viewDidLoad()
    }

    // Collection View Delegate
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.memes.count
    }
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MemeCollectionViewCell", forIndexPath: indexPath) as! MemeCollectionViewCell
        let meme = self.memes[indexPath.row]
        
        cell.memeImageView.image = meme.newImage
        
        return cell
    }
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
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
