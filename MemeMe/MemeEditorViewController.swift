//
//  MemeEditorViewController.swift
//  MemeMe
//
//  Created by Mahmoud Tawfik on 9/30/16.
//  Copyright © 2016 Mahmoud Tawfik. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //MARK: Constants / Variables
    let textFieldDelegate = TextFieldDelegate()
    let memeTextAttributes : [String : Any] = [
        NSStrokeColorAttributeName : UIColor.black,
        NSForegroundColorAttributeName : UIColor.white,
        NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName : -3.0
    ]
    var memes = [MemeModel]()

    //MARK: IBOutlets
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var galleryButton: UIBarButtonItem!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var imageAspectRatioConstraint: NSLayoutConstraint!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet var imagePickerView: UIImagePickerController!
    
    //MARK: IBActions
    
    @IBAction func pickImage(_ sender: UIBarButtonItem) {
        
        // Gallery Button tag = 0 & Camera Button tag = 1
        imagePickerView.sourceType = sender.tag == 0 ? .photoLibrary : .camera
        
        present(imagePickerView, animated: true, completion: nil)
    }
    
    @IBAction func shareMeme(_ sender: AnyObject) {
        let memedImage = generateMemedImage()
        let activityView = UIActivityViewController.init(activityItems: [memedImage], applicationActivities: nil)
        activityView.completionWithItemsHandler = {(_, completed, _, _) in
            if completed {
                let meme = MemeModel(originalImage: self.imageView.image!,
                                     topText: self.topTextField.text!,
                                     bottomText: self.bottomTextField.text!,
                                     memedImage: memedImage)
                self.memes.append(meme)
            
                self.clearMeme()
            }
        }
        present(activityView, animated: true, completion: nil)
    }

    @IBAction func cancel(_ sender: AnyObject) {
        clearMeme()
    }

    //MARK: Meme Methods
    
    func generateMemedImage() -> UIImage {
        // Render view to an image
        UIGraphicsBeginImageContext(view.bounds.size)
        view.drawHierarchy(in: view.frame, afterScreenUpdates: true)
        let memedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        print(memedImage.size)
        let croppedImage = UIImage(cgImage: memedImage.cgImage!.cropping(to: imageView.frame)!)
        return croppedImage
    }
    
    func clearMeme() {
        UIView.animate(withDuration: 0.25,
                       animations: {
                            self.imageView.alpha = 0
                            self.topTextField.alpha = 0
                            self.bottomTextField.alpha = 0 },
                       completion: { completed in
                            self.imageView.image = nil
                            let aspectRatio = self.view.frame.size.width / self.view.frame.size.height
                            self.updateConstarintMultiplier(constarint: self.imageAspectRatioConstraint, multiplier: aspectRatio)
                            self.prepareMemeTextField(textField: self.topTextField, string: "TOP")
                            self.prepareMemeTextField(textField: self.bottomTextField, string: "BOTTOM")
                        UIView.animate(withDuration: 0.25, animations: {
                            self.imageView.alpha = 1
                            self.topTextField.alpha = 1
                            self.bottomTextField.alpha = 1 })})
        
        shareButton.isEnabled = false
    }
    
    func updateConstarintMultiplier(constarint: NSLayoutConstraint, multiplier: CGFloat) {
        let newConstraint = NSLayoutConstraint(item: constarint.firstItem,
                                               attribute: constarint.firstAttribute,
                                               relatedBy: constarint.relation,
                                               toItem: constarint.secondItem,
                                               attribute: constarint.secondAttribute,
                                               multiplier: multiplier,
                                               constant: constarint.constant)
        imageView.removeConstraint(constarint)
        imageAspectRatioConstraint = newConstraint
        imageView.addConstraint(imageAspectRatioConstraint)
    }

    func prepareMemeTextField(textField: UITextField, string: String) {
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = .center
        textField.delegate = textFieldDelegate
        textField.text = string
    }

    //MARK: UIImagePickerControllerDelegate methods

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
            imageView.image = image
            
            // Update image Aspect Ratio constraint which is used to keep text on the image
            let imageAspectRatio = image.size.width / image.size.height
            updateConstarintMultiplier(constarint: imageAspectRatioConstraint, multiplier: imageAspectRatio)

            shareButton.isEnabled = true
        }
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareMemeTextField(textField: topTextField, string: "TOP")
        prepareMemeTextField(textField: bottomTextField, string: "BOTTOM")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        galleryButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.photoLibrary)
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: .UIKeyboardWillHide, object: nil)
        shareButton.isEnabled = (imageView.image != nil)
        
        if imageView.image == nil{
            let aspectRatio = view.frame.size.width / view.frame.size.height
            updateConstarintMultiplier(constarint: imageAspectRatioConstraint, multiplier: aspectRatio)
        }
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
            view.frame.origin.y = -keyboardSize.cgRectValue.height // using -= operator causes problem when rotating the device while keyboard already shown
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

