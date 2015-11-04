//
//  ViewController.swift
//  auto resize test
//
//  Created by josh peterson on 11/3/15.
//  Copyright © 2015 Zikursh. All rights reserved.
//

import UIKit

class ViewController:
		UIViewController,
		UIImagePickerControllerDelegate,
		UINavigationControllerDelegate,
		UITextFieldDelegate {

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
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
