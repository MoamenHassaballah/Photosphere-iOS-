//
//  CategoryModel.swift
//  Photosphere
//
//  Created by Moamen Hassaballah on 02/05/2023.
//

import Foundation

class CategoryModel: Codable {
    let id: String
    let title: String
    let description: String
    let cover_photo: CoverPhoto
    let total_photos: Int
}

struct CoverPhoto: Codable {
    let urls: UrlsList
}
