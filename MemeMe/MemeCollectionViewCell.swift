//
//  MemeCollectionViewCell.swift
//  MemeMe
//
//  Created by Mahmoud Tawfik on 10/2/16.
//  Copyright © 2016 Mahmoud Tawfik. All rights reserved.
//

import UIKit

class MemeCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var bottomLabel: UILabel!
    
    private let memeTextAttributes : [String : Any] = [
        NSStrokeColorAttributeName : UIColor.black,
        NSForegroundColorAttributeName : UIColor.white,
        NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 17)!,
        NSStrokeWidthAttributeName : -3.0
    ]

    var meme:Meme? {
        didSet{
            imageView.image = meme!.originalImage
            topLabel.attributedText = NSAttributedString(string: meme!.topText, attributes: memeTextAttributes)
            bottomLabel.attributedText = NSAttributedString(string: meme!.bottomText, attributes: memeTextAttributes)

        }
    }
}
