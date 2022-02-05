//
//  ImageInfo.swift
//  reactorkit-mvvm
//
//  Created by Louis on 2022/02/03.
//

import Foundation

struct ImageInfo: Codable, Equatable {
    let urls: Urls?
    let width: Int?
    let height: Int?    
     
    public struct Urls: Codable, Equatable {
        let small: String?
        let regular: String?
    }
}
 
struct ImageDatas: Decodable {
    let data: [ImageInfo]
}

