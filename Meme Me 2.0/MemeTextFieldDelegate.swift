//
//  MemeTextFieldDelegate.swift
//  Meme Me 2.0
//
//  Created by Ken Westdorp on 7/9/17.
//  Copyright © 2017 Ken Westdorp. All rights reserved.
//

import UIKit

class MemeTextFieldDelegate: NSObject, UITextFieldDelegate {

    //clears text field when editing
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
