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
    
    var imageWallpaper:PhotoModel?
    
    @IBOutlet weak var wallpaperImageView: UIImageView!
    
    @IBOutlet weak var shadowVIew: UIStackView!
    
    @IBOutlet weak var cornerView: UIStackView!
    
    @IBOutlet weak var closeBtn: UIView!
    
    @IBOutlet weak var favBtn: UIView!
    
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Link: \(String(describing: imageWallpaper))")
        if let photo = imageWallpaper {
            loadingIndicator.startAnimating()
            let imageUrl = URL(string: photo.urls.full)
            wallpaperImageView.kf.setImage(with: imageUrl){ result in
                print("Image loaded: \(result)")
                self.loadingIndicator.stopAnimating()
                if photo.width > photo.height {
                    self.wallpaperImageView.contentMode = .scaleAspectFit
                }
            }
            
            
        }
        
        cornerView.layer.cornerRadius = 10
        closeBtn.layer.cornerRadius = 20
        favBtn.layer.cornerRadius = 20
        closeBtn.layer.masksToBounds = true
        favBtn.layer.masksToBounds = true
        
        
        shadowVIew.setShadow(radius: 30)
        
        loadingIndicator.setShadow()
        loadingIndicator.layer.cornerRadius = 20
//        loadingIndicator.stopAnimating()
        
        
        
    }
    
    @IBAction func close(_ sender: Any) {
        dismiss(animated: true)
    }
    
    
    @IBAction func addToFav(_ sender: Any) {
    }
    
    
    @IBAction func downloadWallpaper(_ sender: Any) {
        if let photo = imageWallpaper {

            loadingIndicator.startAnimating()
            let downloader = ImageDownloader.default
            let downloadUrl = URL(string: photo.urls.raw)
            downloader.downloadImage(with: downloadUrl!){ result in
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
    
}
