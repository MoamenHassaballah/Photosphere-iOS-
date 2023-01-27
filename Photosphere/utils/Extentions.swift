//
//  Extentions.swift
//  Photosphere
//
//  Created by Moamen Hassaballah on 27/01/2023.
//

import Foundation
import UIKit


extension UIView{
    func setShadow(opacity:Float = 0.5, radius: CGFloat = 10){
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = opacity
        layer.shadowRadius = radius
    }
}
