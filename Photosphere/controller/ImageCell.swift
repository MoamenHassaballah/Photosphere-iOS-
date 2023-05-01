//
//  ImageCell.swift
//  Photosphere
//
//  Created by Moamen Hassaballah on 25/01/2023.
//

import UIKit

class ImageCell: UICollectionViewCell {

    @IBOutlet weak var imageFrame: UIView!
    
    @IBOutlet weak var wallpaper: UIImageView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    
        wallpaper.layer.cornerRadius = 10
        wallpaper.layer.masksToBounds = true
//        imageFrame.setShadow(opacity: 0.4)
        
    }
    
    override var isSelected: Bool {
        didSet{
            self.backgroundColor = UIColor.black.withAlphaComponent(0)
        }
    }

    
}
