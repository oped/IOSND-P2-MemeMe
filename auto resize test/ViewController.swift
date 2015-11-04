//
//  ViewController.swift
//  auto resize test
//
//  Created by josh peterson on 11/3/15.
//  Copyright © 2015 Zikursh. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

	@IBOutlet weak var imageView: UIImageView!
	@IBOutlet weak var cameraButton: UIBarButtonItem!
	@IBOutlet weak var shareButton: UIBarButtonItem!
	@IBOutlet weak var topTextField: UITextField!
	@IBOutlet weak var bottomTextField: UITextField!
	@IBOutlet weak var topNavigationBar: UINavigationBar!
	@IBOutlet weak var bottomToolBar: UIToolbar!
	
	@IBAction func getImageFromAlbum(sender: AnyObject) {
		let imagePicker = UIImagePickerController()
		imagePicker.delegate = self
		imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
		self.presentViewController(imagePicker, animated: true, completion: nil)
	}
	@IBAction func getImageFromCamera(sender: AnyObject) {
		let imagePicker = UIImagePickerController()
		imagePicker.delegate = self
		imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
		self.presentViewController(imagePicker, animated: true, completion: nil)
	}
	@IBAction func shareMeme(sender: AnyObject) {
		let image: UIImage = generateMemedImage()
		let objectsToShare = [image]
		let meme = Meme( topText: self.topTextField.text!, bottomText: self.bottomTextField.text!, originalImage: self.imageView.image!, memedImage: image)
		(UIApplication.sharedApplication().delegate as! AppDelegate).memes.append(meme)
		let activityViewController = UIActivityViewController(activityItems: objectsToShare as [AnyObject], applicationActivities: nil )
		self.presentViewController(activityViewController, animated: true, completion: nil )
	}
	
	func generateMemedImage() -> UIImage {
		topNavigationBar.hidden = true
		bottomToolBar.hidden = true
		// render view to an image
		UIGraphicsBeginImageContext(self.view.frame.size)
		self.view.drawViewHierarchyInRect(self.view.frame, afterScreenUpdates: true)
		let memedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		topNavigationBar.hidden = false
		bottomToolBar.hidden = false
		return memedImage
	}
	func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
		if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
			self.imageView.image = image
			dismissViewControllerAnimated(true, completion: nil)
		}
	}
	override func viewDidLoad() {
		super.viewDidLoad()
		setTextFieldProprties(self.topTextField, text: "TOP")
		setTextFieldProprties(self.bottomTextField, text: "BOTTOM")
	}
	override func viewWillDisappear(animated: Bool) {
		super.viewWillDisappear(animated)
		self.unsubscribeFromKeyboardNotifications()
	}
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated);
		cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
		shareButton.enabled = self.imageView.image != nil
		self.subscribeToKeyboardNotifications()
	}
	func setTextFieldProprties(textField: UITextField, text: String) {
		let memeTextAttributes = [
			NSStrokeColorAttributeName :  UIColor.blackColor(),
			NSForegroundColorAttributeName : UIColor.whiteColor(),
			NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
			NSStrokeWidthAttributeName : -5.0 //TODO: Fill in appropriate Float
		]
		textField.delegate = self
		textField.defaultTextAttributes = memeTextAttributes
		textField.textAlignment = NSTextAlignment.Center
		textField.text = text
		textField.clearsOnBeginEditing = true
	}
	func subscribeToKeyboardNotifications() {
		NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
		NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
	}
	func unsubscribeFromKeyboardNotifications() {
		NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
		NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
	}
	func keyboardWillHide(notification: NSNotification) {
		self.view.frame.origin.y = 0
	}
	func keyboardWillShow(notification: NSNotification) {
		if self.bottomTextField.isFirstResponder() {
			self.view.frame.origin.y -= getKeyboardHeight(notification)
		}
	}
	func getKeyboardHeight(notification: NSNotification) -> CGFloat {
		let userInfo = notification.userInfo
		let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
		return keyboardSize.CGRectValue().height
	}
	func textFieldDidBeginEditing(textField: UITextField) {
		textField.clearsOnBeginEditing = false
	}
	func textFieldShouldReturn(textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		return true
	}
}
struct Meme {
	var topText : String!
	var bottomText : String!
	var originalImage : UIImage!
	var memedImage : UIImage!
	
	init( topText: String, bottomText: String, originalImage: UIImage, memedImage: UIImage) {
		self.topText = topText
		self.bottomText = bottomText
		self.originalImage = originalImage
		self.memedImage = memedImage
	}
}
