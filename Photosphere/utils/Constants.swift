//
//  Constants.swift
//  Photosphere
//
//  Created by Moamen Hassaballah on 27/01/2023.
//

import Foundation


struct K {
    
    struct segues{
        static let mainToWallpaper = "mainToWallpaper"
        static let mainToSearch = "mainToSearch"
        static let searchToWallpaper = "searchToWallpaper"
        static let mainToCollections = "mainToCollections"
        static let collectionsToPhotos = "collectionsToPhotos"
        static let categoryToWallpaper = "categoryToWallpaper"
        static let mainToFav = "mainToFav"
        static let favToDetails = "favToDetails"
    }
    
    struct api {
        static let API_URL = "https://api.unsplash.com/"
        static let API_ACCESS_TOKEN = "Your API access token here"
    }
    
    struct cellIdentifier {
        static let CATEGORY_CELL = "categoryCell"
        static let IMAGE_CELL = "imageCell"
    }
    
}
