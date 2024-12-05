//
//  StorageManager.swift
//  TestovoeVk
//
//  Created by Evgeni Novik on 04.12.2024.
//

import Foundation
import RealmSwift


final class StorageManager {
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
    
    func delete<T: Object>(by type: T, primaryKey: String) throws {
        guard let storage else { return }
        try storage.write {
            guard let itemToDelete = storage.object(ofType: T.self, forPrimaryKey: primaryKey) else { return }
            storage.delete(itemToDelete)
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


final class ComicsRealmStorage {
    static let shared = ComicsRealmStorage()
    private let storage: StorageManager
    
    
    private init(storage: StorageManager = StorageManager()) {
        self.storage = storage
    }
    
    func getComicsList() -> [ComicBook] {
        let data = storage.fetch(by: ComicBookObject.self)
        return data.map(ComicBook.init)
    }
    
    func saveComicsList(_ data: [DataComicBook]) {
        let objects = data.map(ComicBookObject.init)
        do {
            try storage.saveOrUpdateAllObjects(objects: objects)
        } catch {
            print(TVKError.cantSaveToTheStorage)
        }
    }
    
    func save(comicBook: ComicBook) {
        let item = ComicBookObject(comicBook)
        do {
            try storage.saveOrUpdateObject(object: item)
        } catch {
            print(TVKError.cantSaveToTheStorage)
        }
    }
    
    func delete(comicBook: ComicBook) {
        let item = ComicBookObject(comicBook)
        do {
            try storage.delete(by: item.self, primaryKey: item.uniqueID)
        } catch {
            print(TVKError.cantDeleteFromTheStorage)
        }
    }
    
    func deleteAllComics() {
        do {
            try storage.deleteAll()
        } catch {
            print(TVKError.cantDeleteFromTheStorage)
        }
    }
}



extension Results {
    func toArray() -> [Element] {
        .init(self)
    }
}
