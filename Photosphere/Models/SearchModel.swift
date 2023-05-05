//
//  SearchModel.swift
//  Photosphere
//
//  Created by Moamen Hassaballah on 01/05/2023.
//

import Foundation

struct SearchModel: Codable{
    
    let total_pages: Int
    let results:[PhotoModel]
    
}
