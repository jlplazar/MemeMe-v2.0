//
//  ViewController.swift
//  MemeMe 2.0
//
//  Created by Jorge Plaza on 12/29/15.
//  Copyright © 2015 Jorge Plaza. All rights reserved.
//

import UIKit

class EditMemesViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    let topDefaultText = "TOP"
    let bottomDefaultText = "BOTTOM"
    let memeTextAttributes = [
        NSStrokeColorAttributeName : UIColor.blackColor(),
        NSForegroundColorAttributeName : UIColor.whiteColor(),
        NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName : -5.0
    ]
    var photoSourceViewController: UIImagePickerController!
    var viewMovedUp: Bool = false
    var memedImage: UIImage?
    var memeIndex: Int = -1
    
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var photoSourceToolbar: UIToolbar!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var memeImageView: UIImageView!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if !UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
            cameraButton.enabled = false
        }
        viewMovedUp = false
        photoSourceViewController = UIImagePickerController()
        photoSourceViewController.delegate = self
        configureTextFields(topTextField, defaultText: topDefaultText, tag: 1)
        configureTextFields(bottomTextField, defaultText: bottomDefaultText, tag: 2)
        
        if memeIndex == -1 {
            shareButton.enabled = false
        } else {
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let meme = appDelegate.memesList[memeIndex]
            photoSourceToolbar.hidden = true
            shareButton.enabled = true
            topTextField.text = meme.topText
            bottomTextField.text = meme.bottomText
            memeImageView.image = meme.image
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    
    /**** Actions ****/
    
    @IBAction func loadPhotoFromCamera(sender: AnyObject) {
        photoSourceViewController.sourceType = .Camera
        presentViewController(photoSourceViewController, animated: true, completion: nil)
    }
    
    @IBAction func loadPhotoFromAlbum(sender: AnyObject) {
        photoSourceViewController.sourceType = .PhotoLibrary
        presentViewController(photoSourceViewController, animated: true, completion: nil)
    }
    
    @IBAction func shareMeme(sender: AnyObject) {
        memedImage = renderMeme()
        let activityViewController = UIActivityViewController(activityItems: [memedImage!], applicationActivities: nil)
        activityViewController.completionWithItemsHandler = {
            (activity, success, items, error) in
            if success {
                self.saveMeme()
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
        presentViewController(activityViewController, animated: true, completion: nil)
    }
    
    @IBAction func cancelEditingMeme(sender: AnyObject) {
        memeImageView.image = nil
        photoSourceToolbar.hidden = false
        shareButton.enabled = false
        topTextField.text = topDefaultText
        bottomTextField.text = bottomDefaultText
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    /**** Image management functions ****/
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            memeImageView.image = selectedImage
            memeImageView.contentMode = UIViewContentMode.ScaleAspectFit
            photoSourceToolbar.hidden = true
            shareButton.enabled = true
        }
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func renderMeme() -> UIImage {
        // Render view to an image
        navigationBar.hidden = true
        UIGraphicsBeginImageContext(view.frame.size)
        view.drawViewHierarchyInRect(view.frame, afterScreenUpdates: true)
        let memedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        navigationBar.hidden = false
        
        return memedImage
    }
    
    
    /**** TextField management functions ****/
    
    func configureTextFields(textField: UITextField, defaultText: String, tag: Int) {
        // Set some initial properties for the given 'textField'
        textField.text = defaultText
        textField.tag = tag
        textField.delegate = self
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = .Center
        textField.addTarget(self, action: "textFieldDidChange:", forControlEvents: UIControlEvents.EditingChanged)
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        // Empty the top and bottom text fields if they have the default values
        if ((textField.tag == 1 && textField.text == topDefaultText) || (textField.tag == 2 && textField.text == bottomDefaultText)) {
            textField.text = ""
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        // Hide the keyboard
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidChange(textField: UITextField) {
        // Set all the text to uppercase
        textField.text = textField.text?.uppercaseString
    }
    
    
    /**** Keyboard management functions ****/
    
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillHideNotification, object: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        // Moves the whole view up when editing the bottom text field.
        // Note: The viewMovedUp control variable is required to avoid a wrong behavior when rotating the phone
        if !viewMovedUp && bottomTextField.isFirstResponder() {
            view.frame.origin.y -= getKeyboardHeight(notification)
            viewMovedUp = true
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        // Return the whole view to its original position if it was moved
        if viewMovedUp {
            view.frame.origin.y += getKeyboardHeight(notification)
            viewMovedUp = false
        }
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        // Return the height of the keyboard on the screen
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }
    
    
    /**** Meme functions ****/
    
    func saveMeme() {
        let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, image: memeImageView.image!, memedImage: memedImage!)
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        if memeIndex == -1 {
            appDelegate.memesList.append(meme)
        } else {
            appDelegate.memesList[memeIndex] = meme
        }
    }
    
}
