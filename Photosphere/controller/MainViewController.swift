//
//  ViewController.swift
//  Photosphere
//
//  Created by Moamen Hassaballah on 25/01/2023.
//

import UIKit
import Alamofire
import Kingfisher

class MainViewController: UIViewController, ApiResultDelegate, UITextFieldDelegate {


    @IBOutlet weak var searchTextField: UITextField!
    
    @IBOutlet weak var gridView: UICollectionView!
    
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
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
    private var page = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
//        wallpapersTableView.dataSource = self
//        wallpapersTableView.register(UINib(nibName: "ImageCell", bundle: nil), forCellReuseIdentifier: "imagecell")
//
        
        
        
    
        searchTextField.delegate = self
        
        
        gridView.collectionViewLayout = UICollectionViewFlowLayout()
        gridView.dataSource = self
        gridView.register(UINib(nibName: "ImageCell", bundle: nil), forCellWithReuseIdentifier: K.cellIdentifier.IMAGE_CELL)
        gridView.delegate  = self
        gridView.allowsMultipleSelection = false
        gridView.showsVerticalScrollIndicator = false
        
        
        loadingIndicator.startAnimating()
        apiManager.apiResultDelegate = self
        apiManager.getHomePhotos(page: page)
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
    
    @IBAction func openCollections(_ sender: Any) {
        self.performSegue(withIdentifier: K.segues.mainToCollections, sender: self)
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        let searchText = textField.text
        print("Search: \(searchText!)")
        self.performSegue(withIdentifier: K.segues.mainToSearch, sender: self)
        
        return true
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.segues.mainToWallpaper {
            
            if let distination = segue.destination as? WallpaperDetailsViewController{
                distination.imageWallpaper = selectedWallpaper
            }
            
        }else if segue.identifier == K.segues.mainToSearch {
            if let distination = segue.destination as? SearchViewController{
                distination.query = searchTextField.text!
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
        let tableCell = collectionView.dequeueReusableCell(withReuseIdentifier: K.cellIdentifier.IMAGE_CELL, for: indexPath) as? ImageCell
        if let cell = tableCell {
            let url = URL(string:  wallpapers[indexPath.row].urls.thumb)
//            let processor = RoundCornerImageProcessor(cornerRadius: 100)
//            cell.wallpaper.kf.setImage(with: url, options: [.processor(processor)])
            cell.wallpaper.kf.setImage(with: url){ result in
                let qeue = DispatchQueue(label: "loadimage")
                qeue.async {
                    let smallUrl = URL(string:  self.wallpapers[indexPath.row].urls.small)
                    KingfisherManager.shared.retrieveImage(with: smallUrl!) { result in
                        // Do something with `result`
                        switch result {
                            case .success(let value):
                            tableCell?.wallpaper.image = value.image

                            case .failure(let error):
                                print(error) // The error happens
                            }
                    }
                }
            }
        }
        return tableCell!
    }
    
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

//        let photo = wallpapers[indexPath.row]

        let yourWidth = collectionView.frame.width / 2
        let yourHeight =  yourWidth * 1.5
//        var  yourHeight = 0.0
//        if (photo.width > photo.height){
//            yourHeight =  yourWidth * 0.5
//        } else {
//            yourHeight =  yourWidth * 1.5
//        }

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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let bottomEdge = scrollView.contentOffset.y + scrollView.frame.size.height
        if bottomEdge >= scrollView.contentSize.height {
            if !loadingIndicator.isAnimating {
                loadingIndicator.startAnimating()
                page += 1
                apiManager.getHomePhotos(page: page)
            }
        }
    }
    
    
    func onPhotosLoaded(photosList: [PhotoModel]) {
        wallpapers.append(contentsOf: photosList)
        DispatchQueue.main.async {
            self.gridView.reloadData()
            self.loadingIndicator.stopAnimating()
        }
    }
    
    func onSearchPhoto(searchModel: SearchModel) {
        
    }
    
    func onCategoriesLoaded(categoriesList: [CategoryModel]) {
        
    }
    
    func onError(errorMessage: String) {
        print("An Error occured: \(errorMessage)")

    }
    
}

