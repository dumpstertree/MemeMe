//
//  MemeTextDelegate.swift
//  MemeMe
//
//  Created by Zachary Collins on 9/3/16.
//  Copyright © 2016 dumpstertree. All rights reserved.
//

import Foundation
import UIKit

class MemeTextDelegate: NSObject, UITextFieldDelegate {
    
    var firstTime = true
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if firstTime{
            textField.text = ""
            firstTime = false
        }
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
