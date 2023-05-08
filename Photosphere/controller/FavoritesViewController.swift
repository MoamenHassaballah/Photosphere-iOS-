//
//  FavoritesViewController.swift
//  Photosphere
//
//  Created by Moamen Hassaballah on 08/05/2023.
//

import UIKit
import Kingfisher

class FavoritesViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{

    @IBOutlet weak var photosNumber: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var emptyImage: UIImageView!
    
    var favList: [PhotoModel]?
    var selectedPhoto: PhotoModel?
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.segues.favToDetails{
            if let destination = segue.destination as? WallpaperDetailsViewController{
                destination.imageWallpaper = selectedPhoto
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.collectionViewLayout = UICollectionViewFlowLayout()
        collectionView.register(UINib(nibName: "ImageCell", bundle: nil), forCellWithReuseIdentifier: K.cellIdentifier.IMAGE_CELL)
        collectionView.allowsMultipleSelection = false
        
        
        

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let fav = UserDefaults.standard.codableObject(dataType: [PhotoModel].self, key: "fav"){
            favList = fav
            let photosCount = favList?.count ?? 0
            photosNumber.text = "\(photosCount ) Photos"
            emptyImage.isHidden = photosCount != 0
            collectionView.reloadData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        favList?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.cellIdentifier.IMAGE_CELL, for: indexPath) as? ImageCell
        
        let photo = favList![indexPath.row]
        
        cell?.wallpaper.kf.setImage(with: URL(string: photo.urls.thumb)){ _ in
            KingfisherManager.shared.retrieveImage(with: URL(string: photo.urls.small)!) { result in
                switch result{
                    case .success(let value):
                        cell?.wallpaper.image = value.image
                        break
                    case .failure(let error):
                        print("Error: \(error.localizedDescription)")
                        break
                }
            }
        }
        
        return cell!
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let yourWidth = collectionView.frame.width / 2
        let yourHeight =  yourWidth * 1.5
        return CGSize(width: yourWidth, height: yourHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedPhoto = favList![indexPath.row]
        performSegue(withIdentifier: K.segues.favToDetails, sender: self)
    }
    
    
    
    
    @IBAction func goBack(_ sender: Any) {
        dismiss(animated: true)
    }
    

}
