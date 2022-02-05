//
//  SearchImageInfo.swift
//  reactorkit-mvvm
//
//  Created by Louis on 2022/02/03.
//

import Foundation

struct SearchResult: Codable, Equatable {
    let total: Int?
    let total_pages: Int?
    let results: [ImageInfo]?
}
 
  
