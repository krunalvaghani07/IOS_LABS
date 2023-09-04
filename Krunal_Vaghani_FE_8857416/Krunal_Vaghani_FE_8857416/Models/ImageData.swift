//
//  ImageData.swift
//  Krunal_Vaghani_FE_8857416
//
//  Created by user228677 on 8/11/23.
//

import Foundation

struct ImageData: Codable {
    let id: String
    let description: String?
    let urls: PhotoURLs
    // Other properties you might want to include
    
    enum CodingKeys: String, CodingKey {
        case id
        case description
        case urls
    }
}

struct PhotoURLs: Codable {
    let regular: String
}

struct UnsplashResponse: Codable {
    let results: [ImageData]
}
