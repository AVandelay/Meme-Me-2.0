//
//  MemeCreatorViewController.swift
//  Meme Me 2.0
//
//  Created by Ken Westdorp on 7/9/17.
//  Copyright © 2017 Ken Westdorp. All rights reserved.
//

import UIKit

class MemeCreatorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    // MARK: Outlets
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var deleteButton: UIBarButtonItem!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var albumButton: UIBarButtonItem!
    @IBOutlet weak var memeImage: UIImageView!

    // MARK: Properties
    let memeTextFieldDelegate = MemeTextFieldDelegate()

    let memeTextAttributes:[String:Any] = [
        NSStrokeColorAttributeName: UIColor.black,
        NSForegroundColorAttributeName: UIColor.white,
        NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName: -3.0]

    //MARK: Life Cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()

        shareButton.isEnabled = !(memeImage.image == nil)
        deleteButton.isEnabled = !(memeImage.image == nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black

        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)

        // text field font and style
        textFieldStyle(textField: topTextField, text: "TOP")
        textFieldStyle(textField: bottomTextField, text: "BOTTOM")
    }

    func textFieldStyle(textField: UITextField, text: String) {
        textField.defaultTextAttributes = memeTextAttributes
        textField.text = text
        textField.textAlignment = .center
        textField.delegate = memeTextFieldDelegate
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }

    // MARK: Methods

    // keyboad dodger
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }

    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }

    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }

    func keyboardWillShow(_ notification:Notification) {
        if bottomTextField.isFirstResponder {
            view.frame.origin.y = 0 - getKeyboardHeight(notification)
        }
    }

    func keyboardWillHide(_ notification:Notification) {
        if bottomTextField.isFirstResponder {
            view.frame.origin.y = 0
        }
    }

    // image picker

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)

    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            memeImage.image = image

            picker.dismiss(animated: true, completion: nil)
        }
    }

    func memeify() -> UIImage {
        configureBars(hidden: true)
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        configureBars(hidden: false)
        return memedImage
    }

    func saveMemedImage(memedImage: UIImage) {
        if memeImage.image != nil && topTextField != nil && bottomTextField != nil {
            let topTF = self.topTextField.text!
            let bottomTF = self.bottomTextField.text!
            let image = self.memeImage.image!

            let meme: Meme = Meme(topText: topTF, bottomText: bottomTF, originalImage: image, memedImage: memedImage)

            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.memes.append(meme)
        }
    }

    func pickImage(from source: UIImagePickerControllerSourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }

    func configureBars(hidden: Bool) {
        toolBar.isHidden = hidden
        self.navigationController?.isNavigationBarHidden = hidden
    }

    // MARK: IBActions

    @IBAction func shareButton(_ sender: Any) {
        let memeToShare = memeify()

        let activityViewController = UIActivityViewController(activityItems: [memeToShare], applicationActivities: nil)
        activityViewController.completionWithItemsHandler = { (_, success, _, _) in
            if success {
                self.saveMemedImage(memedImage: memeToShare)
            }
        }
        self.present(activityViewController, animated: true, completion: nil)
    }

    @IBAction func deleteButton(_ sender: Any) {
        memeImage.image = nil
        textFieldStyle(textField: topTextField, text: "TOP")
        textFieldStyle(textField: bottomTextField, text: "BOTTOM")
    }

    @IBAction func cameraButton(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            pickImage(from: .camera)
        } else {
            print("Camera not available")
        }
    }
    
    @IBAction func albumButton(_ sender: Any) {
        pickImage(from: .photoLibrary)
    }

}
