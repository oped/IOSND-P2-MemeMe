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
			NSStrokeColorAttributeName :  UIColor.blackColor(), //TODO: Fill in appropriate UIColor,
			NSForegroundColorAttributeName : UIColor.whiteColor(), //TODO: Fill in UIColor,
			NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
			NSStrokeWidthAttributeName : -3.0 //TODO: Fill in appropriate Float
			//TODO: BOLD ??
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




class Meme {
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
