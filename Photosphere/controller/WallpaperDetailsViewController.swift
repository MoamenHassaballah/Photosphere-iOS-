//
//  WallpaperDetailsViewController.swift
//  Photosphere
//
//  Created by Moamen Hassaballah on 27/01/2023.
//

import Foundation
import UIKit
import Kingfisher

class WallpaperDetailsViewController : UIViewController{
    
    var imageWallpaper = ""
    private var  imageUrl = URL(string:  "")
    
    @IBOutlet weak var wallpaperImageView: UIImageView!
    
    @IBOutlet weak var shadowVIew: UIStackView!
    
    @IBOutlet weak var cornerView: UIStackView!
    
    @IBOutlet weak var closeBtn: UIView!
    
    @IBOutlet weak var favBtn: UIView!
    
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Link: \(imageWallpaper)")
        imageUrl = URL(string: imageWallpaper)
        wallpaperImageView.kf.setImage(with: imageUrl)
        
        cornerView.layer.cornerRadius = 10
        closeBtn.layer.cornerRadius = 20
        favBtn.layer.cornerRadius = 20
        closeBtn.layer.masksToBounds = true
        favBtn.layer.masksToBounds = true
        
        
        shadowVIew.setShadow(radius: 30)
        
        loadingIndicator.setShadow()
        loadingIndicator.layer.cornerRadius = 20
        loadingIndicator.stopAnimating()
//        loadingIndicator.startAnimating()
        
        
    }
    
    @IBAction func close(_ sender: Any) {
        dismiss(animated: true)
    }
    
    
    @IBAction func addToFav(_ sender: Any) {
    }
    
    
    @IBAction func downloadWallpaper(_ sender: Any) {
        loadingIndicator.startAnimating()
        let downloader = ImageDownloader.default
        downloader.downloadImage(with: imageUrl!){ result in
            switch result {
            case .success(let value):
                UIImageWriteToSavedPhotosAlbum(value.image, self, nil, nil)
                print(value.image)
                self.loadingIndicator.stopAnimating()
            case .failure(let error):
                print(error)
            }
        }
        
    }
    
}
