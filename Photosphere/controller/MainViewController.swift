//
//  ViewController.swift
//  Photosphere
//
//  Created by Moamen Hassaballah on 25/01/2023.
//

import UIKit
import Alamofire
import Kingfisher

class MainViewController: UIViewController, ApiResultDelegate {
    
    

    @IBOutlet weak var searchTextField: UITextField!
    
    @IBOutlet weak var gridView: UICollectionView!
    
    
    var wallpapers:[PhotoModel] = [
//        "https://images.unsplash.com/photo-1674380394920-d3625d55d7c8?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=985&q=80",
//
//        "https://images.unsplash.com/photo-1611068813580-b07ef920964b?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=987&q=80",
//
//        "https://images.unsplash.com/photo-1610987039121-d70917dcc6f6?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=927&q=80",
//       "https://images.unsplash.com/photo-1674318012388-141651b08a51?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=3132&q=80"
    ]
    
    private var selectedWallpaper:PhotoModel?
    
    private let apiManager = ApiManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
//        wallpapersTableView.dataSource = self
//        wallpapersTableView.register(UINib(nibName: "ImageCell", bundle: nil), forCellReuseIdentifier: "imagecell")
//
        
        apiManager.apiResultDelegate = self
        apiManager.getHomePhotos(page: 1)
        
        
        gridView.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        gridView.collectionViewLayout = UICollectionViewFlowLayout()
        gridView.dataSource = self
        gridView.register(UINib(nibName: "ImageCell", bundle: nil), forCellWithReuseIdentifier: "imagecell")
        gridView.delegate  = self
        gridView.layer.masksToBounds = false
        gridView.allowsMultipleSelection = false
//        gridView.translatesAutoresizingMaskIntoConstraints = false
//        gridView.layoutIfNeeded()
        
        // Set estimatedItemSize to automatic size
//                if let layout = gridView.collectionViewLayout as? UICollectionViewFlowLayout {
//                    layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
//                    layout.minimumLineSpacing = 0
//                    layout.minimumInteritemSpacing = 0
//                }
        
    }
    

    @IBAction func showSearchBar(_ sender: Any) {
        searchTextField.isHidden = !searchTextField.isHidden
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.segues.mainToWallpaper {
            
            if let distination = segue.destination as? WallpaperDetailsViewController{
                distination.imageWallpaper = selectedWallpaper
            }
            
        }
    }
    
    
}

//extension MainViewController : UITableViewDataSource{
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return wallpapers.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let tableCell = tableView.dequeueReusableCell(withIdentifier: "imagecell", for: indexPath) as? ImageCell
//        if let cell = tableCell {
//            let url = URL(string:  wallpapers[indexPath.row])
//            cell.wallpaper.kf.setImage(with: url)
//        }
//        return tableCell!
//    }
//
//
//}


extension MainViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,
 UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return wallpapers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let tableCell = collectionView.dequeueReusableCell(withReuseIdentifier: "imagecell", for: indexPath) as? ImageCell
        if let cell = tableCell {
            let url = URL(string:  wallpapers[indexPath.row].urls.thumb)
//            let processor = RoundCornerImageProcessor(cornerRadius: 100)
//            cell.wallpaper.kf.setImage(with: url, options: [.processor(processor)])
            cell.wallpaper.kf.setImage(with: url){ result in
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imagecell", for: indexPath)
                print("Size: \(cell.frame.size)")
            }
        }
        return tableCell!
    }
    
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let photo = wallpapers[indexPath.row]

        let yourWidth = collectionView.frame.width / 2
        var  yourHeight = 0.0
        if (photo.width > photo.height){
            yourHeight =  yourWidth * 0.5
        } else {
            yourHeight =  yourWidth * 1.5
        }

//        print("frame: \(collectionView.frame.width), width: \(yourWidth), height:\(yourHeight)")
        return CGSize(width: yourWidth, height: yourHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedWallpaper = wallpapers[indexPath.row]
        self.performSegue(withIdentifier: K.segues.mainToWallpaper, sender: self)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    
    func onPhotosLoaded(photosList: [PhotoModel]) {
        wallpapers.append(contentsOf: photosList)
    }
    
    func onError(errorMessage: String) {
        print("An Error occured: \(errorMessage)")
    }
    
}

