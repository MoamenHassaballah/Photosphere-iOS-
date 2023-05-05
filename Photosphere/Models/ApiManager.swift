//
//  ApiHandler.swift
//  Photosphere
//
//  Created by Moamen Hassaballah on 01/05/2023.
//

import Foundation

protocol ApiResultDelegate{
    func onPhotosLoaded(photosList: [PhotoModel])
    
    func onCategoriesLoaded(categoriesList: [CategoryModel])
    
    func onSearchPhoto(searchModel: SearchModel)
    
    func onError(errorMessage: String)
}

class ApiManager {
    
    var apiResultDelegate: ApiResultDelegate?
    
    func getHomePhotos(page: Int = 1){
        if let url = URL(string: "\(K.api.API_URL)photos?page=\(page)&client_id=\(K.api.API_ACCESS_TOKEN)") {
            
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url){ (data, response, apiError) in
                if apiError == nil {
                    if let photosData = data {
                        print("Data: \(String(describing: data))")
                        let jsonDecoder = JSONDecoder()
                        do {
                            let photosList = try jsonDecoder.decode([PhotoModel].self, from: photosData)
                            self.apiResultDelegate?.onPhotosLoaded(photosList: photosList)
                        }catch {
                            self.apiResultDelegate?.onError(errorMessage: error.localizedDescription)
                            print("Error decoding data: \(error)")
                        }
                    }else {
                        self.apiResultDelegate?.onError(errorMessage: "Data not found")
                        print("Data: \(String(describing: data))")
                    }
                }else {
                    self.apiResultDelegate?.onError(errorMessage: String(describing: apiError))
                    print("ERROR: \(String(describing: apiError))")
                }
            }
            
            task.resume()
            
        }
        
    }
    
    func searchPhoto(page: Int = 1, query: String){
        let searchUrl = "\(K.api.API_URL)search/photos?page=\(page)&query=\(query)&client_id=\(K.api.API_ACCESS_TOKEN)&per_page=30"
        let fixedUrl = searchUrl.replacingOccurrences(of: " ", with: "%20")
        print("Search: \(fixedUrl)")
        
        if let url = URL(string: fixedUrl) {
            
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url){ (data, response, apiError) in
                if apiError == nil {
                    if let photosData = data {
                        print("Data: \(String(describing: data))")
                        let jsonDecoder = JSONDecoder()
                        do {
                            let searchModel = try jsonDecoder.decode(SearchModel.self, from: photosData)
                            self.apiResultDelegate?.onSearchPhoto(searchModel: searchModel)
                        }catch {
                            self.apiResultDelegate?.onError(errorMessage: error.localizedDescription)
                            print("Error decoding data: \(error)")
                        }
                    }else {
                        self.apiResultDelegate?.onError(errorMessage: "Data not found")
                        print("Data: \(String(describing: data))")
                    }
                }else {
                    self.apiResultDelegate?.onError(errorMessage: String(describing: apiError))
                    print("ERROR: \(String(describing: apiError))")
                }
            }
            
            task.resume()
            
        }
    }
    
    
    func getCategories(page: Int = 1){
        if let url = URL(string: "\(K.api.API_URL)topics?page=\(page)&client_id=\(K.api.API_ACCESS_TOKEN)"){
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url, completionHandler: { (data, response, apiError) in
                if apiError == nil{
                    if let categoriesData = data {
                        let jsonDecoder = JSONDecoder()
                        do{
                            let categoriesList = try jsonDecoder.decode([CategoryModel].self, from: categoriesData)
                            self.apiResultDelegate?.onCategoriesLoaded(categoriesList: categoriesList)
                        }catch {
                            self.apiResultDelegate?.onError(errorMessage: error.localizedDescription)
                        }
                    }
                }else {
                    self.apiResultDelegate?.onError(errorMessage: apiError!.localizedDescription)
                }
            })
            
            task.resume()
        }
    }
    
    
    func getCategoryPhotos(topicId: String, page: Int = 1){
        if let url = URL(string: "\(K.api.API_URL)topics/\(topicId)/photos?page=\(page)&client_id=\(K.api.API_ACCESS_TOKEN)") {
            
            print("Category: \(url)")
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url){ (data, response, apiError) in
                if apiError == nil {
                    if let photosData = data {
                        print("Data: \(String(describing: data))")
                        let jsonDecoder = JSONDecoder()
                        do {
                            let photosList = try jsonDecoder.decode([PhotoModel].self, from: photosData)
                            self.apiResultDelegate?.onPhotosLoaded(photosList: photosList)
                        }catch {
                            self.apiResultDelegate?.onError(errorMessage: error.localizedDescription)
                            print("Error decoding data: \(error)")
                        }
                    }else {
                        self.apiResultDelegate?.onError(errorMessage: "Data not found")
                        print("Data: \(String(describing: data))")
                    }
                }else {
                    self.apiResultDelegate?.onError(errorMessage: String(describing: apiError))
                    print("ERROR: \(String(describing: apiError))")
                }
            }
            
            task.resume()
            
        }
        
    }
    
}
