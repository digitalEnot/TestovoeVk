//
//  Movie.swift
//  TestovoeVk
//
//  Created by Evgeni Novik on 02.12.2024.
//

import Foundation


struct ComicsResponse: Decodable {
    let data: data
}


struct data: Decodable {
    let comicBooks: [ComicBook]
    
    enum CodingKeys: String, CodingKey {
        case comicBooks = "results"
    }
}


struct ComicBook: Decodable, Hashable {
    let uniqueID = UUID().uuidString
    let id: Int?
//    let thumbnail: thumbnail
    let title: String?
    let textObjects: [TextObjects]
}

struct TextObjects: Decodable, Hashable {
    let text: String?
}

//
//struct thumbnail: Codable, Hashable {
//    let image_path: String
//    let image_extension: String
//    
//    enum CodingKeys: String, CodingKey {
//        case image_path = "path"
//        case image_extension = "extension"
//    }
//}
