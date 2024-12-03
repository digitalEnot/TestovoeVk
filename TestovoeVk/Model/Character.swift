//
//  Character.swift
//  TestovoeVk
//
//  Created by Evgeni Novik on 03.12.2024.
//

import Foundation


struct Character: Decodable {
    let info: Info
    
    enum CodingKeys: String, CodingKey {
        case info = "data"
    }
}


struct Info: Decodable {
    let characters: [MarvelCharacter]
    
    enum CodingKeys: String, CodingKey {
        case characters = "results"
    }
}


struct MarvelCharacter: Decodable, Hashable {
    let uniqueID = UUID().uuidString
    let id: Int?
    let name: String?
    let description: String?
}


