//
//  SearchViewController.swift
//  Photosphere
//
//  Created by Moamen Hassaballah on 01/05/2023.
//

import UIKit
import Kingfisher

private let reuseIdentifier = "Cell"

class SearchViewController: UICollectionViewController, ApiResultDelegate, UICollectionViewDelegateFlowLayout {
    
    
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    
    var query = ""
    
    var wallpapers:[PhotoModel] = []
    var selectedWallpaper: PhotoModel?
    
    private let apiManager = ApiManager()
    private var page = 1
    private var maxPage = 1
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.segues.searchToWallpaper {
            
            if let distination = segue.destination as? WallpaperDetailsViewController{
                distination.imageWallpaper = selectedWallpaper
            }
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Query: \(query)")

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView.collectionViewLayout = UICollectionViewFlowLayout()
        self.collectionView!.dataSource = self
        self.collectionView!.register(UINib(nibName: "ImageCell", bundle: nil), forCellWithReuseIdentifier: K.cellIdentifier.IMAGE_CELL)
        self.collectionView!.delegate  = self
        self.collectionView!.layer.masksToBounds = false
        self.collectionView!.allowsMultipleSelection = false
        self.collectionView.showsVerticalScrollIndicator = false
        
        // Do any additional setup after loading the view.
        
        loadingIndicator.startAnimating()
        apiManager.apiResultDelegate = self
        apiManager.searchPhoto(query: query)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return wallpapers.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
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
        let yourWidth = collectionView.frame.width / 2
        let yourHeight =  yourWidth * 1.5
        print("width:\(yourWidth), height: \(yourHeight)")
        return CGSize(width: yourWidth, height: yourHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedWallpaper = wallpapers[indexPath.row]
        self.performSegue(withIdentifier: K.segues.searchToWallpaper, sender: self)
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let bottomEdge = scrollView.contentOffset.y + scrollView.frame.size.height
            if bottomEdge >= scrollView.contentSize.height {
                
                if (!loadingIndicator.isAnimating && page < maxPage){
                    loadingIndicator.startAnimating()
                    page += 1
                    apiManager.searchPhoto(page: page, query: query)
                }
            }
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

    func onPhotosLoaded(photosList: [PhotoModel]) {
        
    }
    
    func onCategoriesLoaded(categoriesList: [CategoryModel]) {
        
    }
    
    func onSearchPhoto(searchModel: SearchModel) {
        print("onSearch")
        maxPage = searchModel.total_pages
        wallpapers.append(contentsOf: searchModel.results)
        DispatchQueue.main.async {
            self.collectionView.reloadData()
            self.loadingIndicator.stopAnimating()
        }
    }
    
    func onError(errorMessage: String) {
        print("An Error occured: \(errorMessage)")
    }
}
