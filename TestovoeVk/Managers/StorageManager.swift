//
//  StorageManager.swift
//  TestovoeVk
//
//  Created by Evgeni Novik on 04.12.2024.
//

import Foundation
import RealmSwift


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
    func getAirportList() -> [ComicBook]
    func saveAirportList(_ data: [DataComicBook])
    func clearAirportList()
}

final class ComicBookRepositoryImpl: ComicBookRepository {
    private let storage: StorageService
    
    init(storage: StorageService = StorageService()) {
        self.storage = storage
    }
    
    func getAirportList() -> [ComicBook] {
        let data = storage.fetch(by: ComicBookObject.self)
        return data.map(ComicBook.init)
    }
    
    func saveAirportList(_ data: [/*ComicBookDTo*/ DataComicBook]) {
        let objects = data.map(ComicBookObject.init)
        try? storage.saveOrUpdateAllObjects(objects: objects)
    }
    
    func saveComicBook(item: ComicBook) {
        let item = ComicBookObject(item)
        try? storage.saveOrUpdateObject(object: item)
    }
    
    func deleteOneItem(item: ComicBook) {
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
