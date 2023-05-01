//
//  ApiHandler.swift
//  Photosphere
//
//  Created by Moamen Hassaballah on 01/05/2023.
//

import Foundation

protocol ApiResultDelegate{
    func onPhotosLoaded(photosList: [PhotoModel])
    
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
    
}
