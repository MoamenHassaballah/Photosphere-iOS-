//
//  PhotoModel.swift
//  Photosphere
//
//  Created by Moamen Hassaballah on 01/05/2023.
//

import Foundation

struct PhotoModel : Codable{
    
    let id:String
    let width: Int
    let height: Int
    let alt_description: String?
    let urls: UrlsList
    let links: DownloadLink
}

struct UrlsList : Codable{
    
    let raw:String
    let full:String
    let thumb:String
    
}

struct DownloadLink : Codable {
    let download: String
}
