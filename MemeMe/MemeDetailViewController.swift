//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by Mahmoud Tawfik on 10/2/16.
//  Copyright © 2016 Mahmoud Tawfik. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {
    var meme: Meme?
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let meme = meme {
            imageView.image = meme.memedImage
        }
    }
    
    @IBAction func EditMeme(_ sender: AnyObject) {
        performSegue(withIdentifier: "EditMeme", sender: self)
        _ = navigationController?.popViewController(animated: true)
    }
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let navigation = segue.destination as? UINavigationController {
            if let destination = navigation.viewControllers[0] as? MemeEditorViewController{
                destination.meme = meme
            }
        }
    }
}
