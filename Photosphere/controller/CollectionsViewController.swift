//
//  CollectionsViewController.swift
//  Photosphere
//
//  Created by Moamen Hassaballah on 01/05/2023.
//

import UIKit
import Kingfisher

class CollectionsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, ApiResultDelegate, UICollectionViewDataSource {
   

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    
    
    let apiManager = ApiManager()
    var categoriesList: [CategoryModel] = []
    
    var selectedCategory: CategoryModel?
    
    var page = 1
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.segues.collectionsToPhotos{
            if let destination = segue.destination as? CategoryViewController {
                destination.category = selectedCategory
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.collectionViewLayout = UICollectionViewFlowLayout()
        collectionView.register(UINib(nibName: "CategoryCell", bundle: nil), forCellWithReuseIdentifier: K.cellIdentifier.CATEGORY_CELL)
        
        loadingIndicator.startAnimating()
        apiManager.apiResultDelegate = self
        apiManager.getCategories()
        
    }
    
    @IBAction func goBack(_ sender: Any) {
        dismiss(animated: true)
    }

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        categoriesList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.cellIdentifier.CATEGORY_CELL, for: indexPath) as! CategoryCell
        let category = categoriesList[indexPath.row]
        cell.categoryTitle.text = category.title
        cell.categoryDescription.text = category.description
        
        let imageUrl = URL(string: category.cover_photo.urls.thumb)
        cell.categoryCover.kf.setImage(with: imageUrl){result in
            let queue = DispatchQueue(label: "loadimage")
            queue.async {
                let image = URL(string: category.cover_photo.urls.small)
                KingfisherManager.shared.retrieveImage(with: image!) { result in
                    switch result {
                        case .success(let value):
                            cell.categoryCover.image = value.image
                        case .failure(let error):
                            print(error) // The error happens
                        }
                }
            }
        }
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.size.width
        let height = width / 2
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedCategory = categoriesList[indexPath.row]
        self.performSegue(withIdentifier: K.segues.collectionsToPhotos, sender: self)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let bottomEdge = scrollView.contentOffset.y + scrollView.frame.size.height
        if bottomEdge >= scrollView.contentSize.height && !loadingIndicator.isAnimating{
            loadingIndicator.stopAnimating()
            page += 1
            apiManager.getCategories(page: page)
        }
    }

    
    func onPhotosLoaded(photosList: [PhotoModel]) {
        
    }
    
    func onCategoriesLoaded(categoriesList: [CategoryModel]) {
        DispatchQueue.main.async {
            self.categoriesList.append(contentsOf: categoriesList)
            self.collectionView.reloadData()
            self.loadingIndicator.stopAnimating()
        }
    }
    
    func onSearchPhoto(searchModel: SearchModel) {
        
    }
    
    func onError(errorMessage: String) {
        print("Error: \(errorMessage)")
    }
}
