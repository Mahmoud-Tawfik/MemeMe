//
//  ViewController.swift
//  MemeMe
//
//  Created by Mahmoud Tawfik on 9/30/16.
//  Copyright © 2016 Mahmoud Tawfik. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    //MARK: IBOutlets
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var galleryButton: UIBarButtonItem!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    
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
        }
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: Lifecycle methods
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        galleryButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.photoLibrary)
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
    }

}

