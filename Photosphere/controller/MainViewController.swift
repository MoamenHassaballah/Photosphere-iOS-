//
//  ViewController.swift
//  Photosphere
//
//  Created by Moamen Hassaballah on 25/01/2023.
//

import UIKit
import Alamofire
import Kingfisher

class MainViewController: UIViewController {

    @IBOutlet weak var searchTextField: UITextField!
    
    @IBOutlet weak var gridView: UICollectionView!
    
    
    let wallpapers:[String] = [
        "https://images.unsplash.com/photo-1674380394920-d3625d55d7c8?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=985&q=80",
        
        "https://images.unsplash.com/photo-1611068813580-b07ef920964b?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=987&q=80",
        
        "https://images.unsplash.com/photo-1610987039121-d70917dcc6f6?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=927&q=80",
       "https://images.unsplash.com/photo-1674318012388-141651b08a51?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=3132&q=80"
    ]
    
    private var selectedWallpaper = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
//        wallpapersTableView.dataSource = self
//        wallpapersTableView.register(UINib(nibName: "ImageCell", bundle: nil), forCellReuseIdentifier: "imagecell")
//
        
        gridView.dataSource = self
        gridView.register(UINib(nibName: "ImageCell", bundle: nil), forCellWithReuseIdentifier: "imagecell")
        gridView.delegate  = self
        gridView.layer.masksToBounds = false
        gridView.allowsMultipleSelection = false
        
        let request = AF.request("https://jsonplaceholder.typicode.com/posts", method:  .get)
        request.responseString { response in
            print(response.value!)
            if let value = response.value {
                let jsonData = value.data(using: .utf8)
                if let data = jsonData{
//                    do {
//                        if let jsonArray = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? [Dictionary<String, Any>]
//                        {
//                            print("userId: \(jsonArray[0]["title"])") // use the json here
//                        } else {
//                            print("bad json")
//                        }
//                    } catch let error as NSError {
//                        print(error)
//                    }
                    
                    let posts: [Post] = try! JSONDecoder().decode([Post].self, from: data)
                    print("Posts: \(posts[0])")
                }
            }
        }
        
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
            let url = URL(string:  wallpapers[indexPath.row])
            let processor = RoundCornerImageProcessor(cornerRadius: 100)
            cell.wallpaper.kf.setImage(with: url, options: [.processor(processor)])
        }
        return tableCell!
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let yourWidth = collectionView.bounds.width / 2.1
        let yourHeight = yourWidth * 1.5
        print("Width: \(yourWidth)")
        return CGSize(width: yourWidth, height: yourHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedWallpaper = wallpapers[indexPath.row]
        self.performSegue(withIdentifier: K.segues.mainToWallpaper, sender: self)
    }
    
}

