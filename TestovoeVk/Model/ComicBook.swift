//
//  Movie.swift
//  TestovoeVk
//
//  Created by Evgeni Novik on 02.12.2024.
//

import Foundation
import RealmSwift


struct ComicsResponse: Decodable {
    let data: data
}
struct data: Decodable {
    let comicBooks: [DataComicBook]
    
    enum CodingKeys: String, CodingKey {
        case comicBooks = "results"
    }
}
struct DataComicBook: Decodable, Hashable {
    let title: String
    let textObjects: [TextObjects]
}
struct TextObjects: Decodable, Hashable {
    let text: String
}



final class ComicBookObject: Object {
    @Persisted(primaryKey: true) var uniqueID: String
    @Persisted var title: String
    @Persisted var text: String
    
    convenience init( uniqueID: String, title: String, text: String) {
        self.init()
        self.uniqueID = uniqueID
        self.title = title
        self.text = text
    }
    
    convenience init(_ dto: ComicBook) {
        self.init()
        uniqueID = dto.uniqueID
        title = dto.title
        text = dto.description
    }
    
    convenience init(_ comicBook: DataComicBook) {
        self.init()
        uniqueID = UUID().uuidString
        title = comicBook.title
        text = comicBook.textObjects.count > 0 ? comicBook.textObjects[0].text : ""
    }
}


struct ComicBook: Hashable {
    var uniqueID: String
    var title: String
    var description: String
    
    init(object: ComicBookObject) {
        uniqueID = object.uniqueID
        title = object.title
        description = object.text
    }
    
    init(uniqueID: String, title: String, text: String) {
        self.uniqueID = uniqueID
        self.title = title
        self.description = text
    }
}
