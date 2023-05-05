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
    
    @IBOutlet weak var usernameLable: UILabel!
    
    @IBOutlet weak var unsplashLable: UILabel!
    
    let referal = "?utm_source=Photosphere&utm_medium=referral"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Link: \(String(describing: imageWallpaper))")
        if let photo = imageWallpaper {
            loadingIndicator.startAnimating()
            let imageUrl = URL(string: photo.urls.small)
            wallpaperImageView.kf.setImage(with: imageUrl){ result in
                print("Image loaded: \(result)")
                self.loadingIndicator.stopAnimating()
                if photo.width > photo.height {
                    self.wallpaperImageView.contentMode = .scaleAspectFit
                }
                
                //update quality
                let qeue = DispatchQueue(label: "loadimage")
                qeue.async {
                    let rawUrl = URL(string: photo.urls.raw)
                    KingfisherManager.shared.retrieveImage(with: rawUrl!) { result in
                        // Do something with `result`
                        switch result {
                            case .success(let value):
                            self.wallpaperImageView.image = value.image

                            case .failure(let error):
                                print(error) // The error happens
                            }
                    }
                }
            }
            
            
        }
        
        
        usernameLable.text = imageWallpaper?.user.name
    
        
        cornerView.layer.cornerRadius = 10
        closeBtn.layer.cornerRadius = 20
        favBtn.layer.cornerRadius = 20
        closeBtn.layer.masksToBounds = true
        favBtn.layer.masksToBounds = true
        
        
        shadowVIew.layer.cornerRadius = 5
        shadowVIew.layer.masksToBounds = true
        
        loadingIndicator.setShadow()
        loadingIndicator.layer.cornerRadius = 20
//        loadingIndicator.stopAnimating()
        
        setTapGestureForLable(lable: usernameLable, function: #selector(onUsernameClicked))
        setTapGestureForLable(lable: unsplashLable, function: #selector(onUnsplashClicked))
        
        
        
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
            let downloadUrl = URL(string: photo.links.download!)
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
    
    func setTapGestureForLable(lable: UILabel, function: Selector){
        let tapGesture = UITapGestureRecognizer(target: self, action: function)
        lable.isUserInteractionEnabled = true
        lable.addGestureRecognizer(tapGesture)
    }
    
    @objc func onUsernameClicked(){
        if let url = URL(string: "\(imageWallpaper?.user.links.html ?? "https://unsplash.com/")\(referal)") {
            UIApplication.shared.open(url)
        }
    }
    
    @objc func onUnsplashClicked(){
        if let url = URL(string: "https://unsplash.com/\(referal)") {
            UIApplication.shared.open(url)
        }
    }
    
}
