//
//  ViewController.swift
//  MemeMe
//
//  Created by Mahmoud Tawfik on 9/30/16.
//  Copyright © 2016 Mahmoud Tawfik. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //MARK: Constants / Variables
    let textFieldDelegate = TextFieldDelegate()
    let memeTextAttributes : [String : Any] = [
        NSStrokeColorAttributeName : UIColor.black,
        NSForegroundColorAttributeName : UIColor.white,
        NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName : -3.0
    ]

    //MARK: IBOutlets
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var galleryButton: UIBarButtonItem!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var imageAspectRatioConstraint: NSLayoutConstraint!
    
    //MARK: IBActions
    
    @IBAction func pickImage(_ sender: UIBarButtonItem) {
        
        let imagePickerView = UIImagePickerController()
        imagePickerView.delegate = self
        
        // Gallery Button tag = 0 & Camera Button tag = 1
        imagePickerView.sourceType = sender.tag == 0 ? .photoLibrary : .camera
        
        present(imagePickerView, animated: true, completion: nil)
    }
    
    //MARK: UIImagePickerControllerDelegate methods

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
            imageView.image = image
            
            // Update image Aspect Ratio constraint which is used to keep text on the image
            let aspectRatio = image.size.width / image.size.height
            imageView.removeConstraint(imageAspectRatioConstraint)
            imageAspectRatioConstraint = NSLayoutConstraint(item: imageView, attribute: .width, relatedBy: .equal, toItem: imageView, attribute: .height, multiplier: aspectRatio, constant: 0.0)
            imageView.addConstraint(imageAspectRatioConstraint)
        }
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        topTextField.defaultTextAttributes = memeTextAttributes
        topTextField.textAlignment = .center
        topTextField.delegate = textFieldDelegate
        
        bottomTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.textAlignment = .center
        bottomTextField.delegate = textFieldDelegate
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        galleryButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.photoLibrary)
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }

    //MARK: Keyboard methods
    
    func keyboardWillShow(notification: Notification) {
        if bottomTextField.isFirstResponder {
            let keyboardSize = notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
            self.view.frame.origin.y -= keyboardSize.cgRectValue.height
        }
    }

    func keyboardWillHide(notification: Notification) {
        self.view.frame.origin.y = 0
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
}

