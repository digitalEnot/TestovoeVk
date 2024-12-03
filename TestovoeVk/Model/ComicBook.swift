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
    let comicBooks: [ComicBook]
    
    enum CodingKeys: String, CodingKey {
        case comicBooks = "results"
    }
}
struct ComicBook: Decodable, Hashable {
    let uniqueID = UUID().uuidString
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
    
    convenience init(_ dto: ComicBookDTo) {
        self.init()
        uniqueID = dto.uniqueID
        title = dto.title
        text = dto.text
    }
    
    convenience init(_ comicBook: ComicBook) {
        self.init()
        uniqueID = comicBook.uniqueID
        title = comicBook.title
        text = comicBook.textObjects.count > 0 ? comicBook.textObjects[0].text : "No description"
    }
}

struct ComicBookDTo {
    var uniqueID: String
    var title: String
    var text: String
    
    init(object: ComicBookObject) {
        uniqueID = object.uniqueID
        title = object.title
        text = object.text
    }
}




final class StorageService {
    private let storage: Realm?
    
    init(_ configuration: Realm.Configuration = Realm.Configuration(inMemoryIdentifier: "inMemory")) {
        self.storage = try? Realm(configuration: configuration)
    }
    
    func saveOrUpdateObject(object: Object) throws {
        guard let storage else { return }
        try storage.write {
            storage.add(object, update: .all)
        }
    }
    
    func saveOrUpdateAllObjects(objects: [Object]) throws {
        try objects.forEach {
            try saveOrUpdateObject(object: $0)
        }
    }
    
    
    func delete(object: ComicBookObject) throws {
        guard let storage else { return }
        try storage.write {
            guard let itemToDelete = storage.object(ofType: ComicBookObject.self, forPrimaryKey: object.uniqueID) else { return }
            storage.delete(itemToDelete)
//            storage.delete(object)
//            storage.delete(Realm.object(obj)
        }
    }
    
    func deleteAll() throws {
        guard let storage else { return }
        try storage.write {
            storage.deleteAll()
        }
    }
    
    
    func fetch<T: Object>(by type: T.Type) -> [T] {
        guard let storage else { return [] }
        return storage.objects(T.self).toArray()
    }
}


extension Results {
    func toArray() -> [Element] {
        .init(self)
    }
}


protocol ComicBookRepository {
    func getAirportList() -> [ComicBookDTo]
    func saveAirportList(_ data: [ComicBook])
    func clearAirportList()
}

final class ComicBookRepositoryImpl: ComicBookRepository {
    private let storage: StorageService
    
    init(storage: StorageService = StorageService()) {
        self.storage = storage
    }
    
    func getAirportList() -> [ComicBookDTo] {
        let data = storage.fetch(by: ComicBookObject.self)
        return data.map(ComicBookDTo.init)
    }
    
    func saveAirportList(_ data: [/*ComicBookDTo*/ ComicBook]) {
        let objects = data.map(ComicBookObject.init)
        try? storage.saveOrUpdateAllObjects(objects: objects)
    }
    
    func deleteOneItem(item: ComicBookDTo) {
        let item = ComicBookObject(item)
        try? storage.delete(object: item)
    }
    
    func clearAirportList() {
        try? storage.deleteAll()
    }
}


class TVKRealmStorage {
    static let shared = ComicBookRepositoryImpl()
    private init() {}
}
