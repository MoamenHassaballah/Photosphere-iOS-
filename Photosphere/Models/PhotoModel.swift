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
    let links: Links
    let user: User
}

struct UrlsList : Codable{
    
    let raw:String
    let full:String
    let small:String
    let thumb:String
    
}

struct Links : Codable {
    let download: String?
    let html: String
}

struct User: Codable {
    let username: String
    let name: String
    let links: Links
}


