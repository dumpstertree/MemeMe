//
//  ViewController.swift
//  MemeMe
//
//  Created by Zachary Collins on 9/3/16.
//  Copyright © 2016 dumpstertree. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var topTextBox: UITextField!
    @IBOutlet weak var bottomTextBox: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var bottomtoolbar: UIToolbar!
    @IBOutlet weak var topToolbar: UIToolbar!
    @IBOutlet weak var actionButton: UIBarButtonItem!
    
    var textDelegates: [MemeTextDelegate] = []
    var viewAdjusted = false
    var memeImage: UIImage?
    
    let memeTextAttributes = [
        NSStrokeColorAttributeName : UIColor.blackColor(),
        NSForegroundColorAttributeName : UIColor.whiteColor(),
        NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName : -4.0,
    ]
    
    // Views
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        subscribeToKeyboardNotifications()
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        actionButton.enabled  = false
        
        setupText( topTextBox )
        setupText( bottomTextBox )
    }
    func setupText(textField : UITextField){
        
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = NSTextAlignment.Center
        
        let delegate = MemeTextDelegate()
        textField.delegate = delegate
        textDelegates.append(delegate)
    }
    
    // Keyboard
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:" , name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:" , name: UIKeyboardWillHideNotification, object: nil)
    }
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    func keyboardWillShow(notification: NSNotification) {
        if bottomTextBox.isFirstResponder() && viewAdjusted == false {
            viewAdjusted = true
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    func keyboardWillHide(notification: NSNotification) {
        if viewAdjusted == true {
            viewAdjusted = false
            view.frame.origin.y += getKeyboardHeight(notification)
        }
    }
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }
    
    // Saving/ Sharing
    @IBAction func shareMeme(sender: AnyObject) {
        
        let newImage = generateMemedImage()
        memeImage = newImage
        let actionController = UIActivityViewController(activityItems: [newImage], applicationActivities: nil )
        presentViewController(actionController, animated: true, completion: nil )
        
        actionController.completionHandler = {(activityType, completed:Bool) in
            if completed {
                self.save()
                self.dismissView()
                return
            }
        }
        
    }
    func generateMemedImage() -> UIImage{
        
        topToolbar.hidden    = true
        bottomtoolbar.hidden = true
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawViewHierarchyInRect(self.view.frame, afterScreenUpdates: true)
        let memedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        bottomtoolbar.hidden = false
        topToolbar.hidden    = false
        navigationController?.setToolbarHidden(false, animated: true)
        
        return memedImage
    }
    func save() {
        
        guard let topText = topTextBox.text, let bottomText = bottomTextBox.text, let originalImage = imageView.image, let memeImage = memeImage else {
            return
        }
        
        let meme = Meme(topText: topText, bottomText: bottomText, originalImage: originalImage, newImage: memeImage)
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
    }

    // Image Picking
    @IBAction func pickAnImage(sender: AnyObject) {
        presentPickerController( UIImagePickerControllerSourceType.PhotoLibrary )

    }
    @IBAction func useCameraToCreateAnImage(sender: AnyObject) {
        presentPickerController( UIImagePickerControllerSourceType.Camera )
    }
    func presentPickerController( sourceType: UIImagePickerControllerSourceType){
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = sourceType
        presentViewController(pickerController, animated: true, completion: nil)
    }
    
    // ImagePickerDelegate
    func imagePickerController( picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]){
       
        guard let image: UIImage = info[ "UIImagePickerControllerOriginalImage" ] as? UIImage else{
            return
        }
        
        imageView.image = image
        actionButton.enabled = true
        view.sendSubviewToBack(imageView)
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // Dismiss ViewController
    @IBAction func dismissView(){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}

struct Meme{
    
    let topText: String
    let bottomText: String
    let originalImage: UIImage
    let newImage: UIImage
    
}

