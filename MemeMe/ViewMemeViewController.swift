//
//  ViewMemeViewController.swift
//  MemeMe
//
//  Created by Zachary Collins on 9/11/16.
//  Copyright © 2016 dumpstertree. All rights reserved.
//

import UIKit

class ViewMemeViewController: UIViewController {
    
    var meme: Meme?
    @IBOutlet weak var image: UIImageView!
    
    override func viewWillAppear(animated: Bool) {
        
        guard let meme = self.meme else {
            return
        }
        
        image.image = meme.newImage
    }
}
