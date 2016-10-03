//
//  MemeTableViewCell.swift
//  MemeMe
//
//  Created by Mahmoud Tawfik on 10/3/16.
//  Copyright © 2016 Mahmoud Tawfik. All rights reserved.
//

import UIKit

class MemeTableViewCell: UITableViewCell {

    @IBOutlet weak var originalImageView: UIImageView!
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var bottomLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    
    private let memeTextAttributes : [String : Any] = [
        NSStrokeColorAttributeName : UIColor.black,
        NSForegroundColorAttributeName : UIColor.white,
        NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 17)!,
        NSStrokeWidthAttributeName : -3.0
    ]
    
    var meme:Meme? {
        didSet{
            originalImageView.image = meme!.originalImage
            topLabel.attributedText = NSAttributedString(string: meme!.topText, attributes: memeTextAttributes)
            bottomLabel.attributedText = NSAttributedString(string: meme!.bottomText, attributes: memeTextAttributes)
            detailLabel.text = "\(meme!.topText)...\(meme!.bottomText)"
            
        }
    }
}
