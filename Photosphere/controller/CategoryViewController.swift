//
//  CategoryViewController.swift
//  Photosphere
//
//  Created by Moamen Hassaballah on 05/05/2023.
//

import UIKit
import Kingfisher

class CategoryViewController: UIViewController, UICollectionViewDelegateFlowLayout, ApiResultDelegate, UICollectionViewDataSource {
    
    
    

    @IBOutlet weak var categoryTitle: UILabel!
    @IBOutlet weak var photosNumber: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    private var selectedWallpaper:PhotoModel?
    
    let apiManager = ApiManager()
    
    var page = 1
    var category: CategoryModel?
    var photosList:[PhotoModel] = []
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.segues.categoryToWallpaper {
            
            if let distination = segue.destination as? WallpaperDetailsViewController{
                distination.imageWallpaper = selectedWallpaper
            }
            
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        collectionView.dataSource = self
        collectionView.collectionViewLayout = UICollectionViewFlowLayout()
        collectionView.register(UINib(nibName: "ImageCell", bundle: nil), forCellWithReuseIdentifier: K.cellIdentifier.IMAGE_CELL)
        collectionView.allowsMultipleSelection = false
        collectionView.delegate = self
        
        categoryTitle.text = category?.title
        photosNumber.text = "\(category?.total_photos ?? 0) Photos"
        
        
        apiManager.apiResultDelegate = self
        loadingIndicator.startAnimating()
        apiManager.getCategoryPhotos(topicId: category!.id)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photosList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.cellIdentifier.IMAGE_CELL, for: indexPath) as? ImageCell
        let photo = photosList[indexPath.row]
        cell?.wallpaper.kf.setImage(with: URL(string: photo.urls.thumb)){ res in
            KingfisherManager.shared.retrieveImage(with: URL(string: photo.urls.small)!) { result in
                switch(result){
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedWallpaper = photosList[indexPath.row]
        self.performSegue(withIdentifier: K.segues.categoryToWallpaper, sender: self)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let yourWidth = collectionView.frame.width / 2
        let yourHeight =  yourWidth * 1.5
        return CGSize(width: yourWidth, height: yourHeight)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let bottomEdge = scrollView.contentOffset.y + scrollView.frame.size.height
        if bottomEdge >= scrollView.contentSize.height && !loadingIndicator.isAnimating{
            loadingIndicator.stopAnimating()
            page += 1
            apiManager.getCategoryPhotos(topicId: category!.id, page: page)
        }
    }
    

    @IBAction func goBack(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    
    func onPhotosLoaded(photosList: [PhotoModel]) {
        self.photosList.append(contentsOf: photosList)
        DispatchQueue.main.async {
            self.collectionView.reloadData()
            self.loadingIndicator.stopAnimating()
        }
    }
    
    func onCategoriesLoaded(categoriesList: [CategoryModel]) {
        
    }
    
    func onSearchPhoto(searchModel: SearchModel) {
        
    }
    
    func onError(errorMessage: String) {
        print("Error: \(errorMessage)")
    }
}
