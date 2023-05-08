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


extension UserDefaults{
    func setCodableObject<T: Codable>(_ data: T?, forKey defaultName: String) -> T? {
        let encoded = try? JSONEncoder().encode(data)
        set(encoded, forKey: defaultName)
        return data
      }
    
    func codableObject<T : Codable>(dataType: T.Type, key: String) -> T? {
        guard let userDefaultData = data(forKey: key) else {
          return nil
        }
        return try? JSONDecoder().decode(T.self, from: userDefaultData)
      }
}
