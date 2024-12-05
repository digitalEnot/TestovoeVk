//
//  TestovoeVkTests.swift
//  TestovoeVkTests
//
//  Created by Evgeni Novik on 02.12.2024.
//

import XCTest
@testable import TestovoeVk

final class TestovoeVkTests: XCTestCase {
    
    private var storage: ComicsRealmStorage!

    
    override func setUpWithError() throws {
        storage = ComicsRealmStorage.shared
    }

    
    override func tearDownWithError() throws {
        storage = nil
    }
    
    
    func testSaveAndFetchComicBook() throws {
        let comicBook = ComicBook(uniqueID: "12345", title: "Test Comic", text: "Text")
        storage.save(comicBook: comicBook)
        
        let fetchedComics: [ComicBook] = storage.getComicsList()
        
        XCTAssertEqual(fetchedComics.last?.uniqueID, "12345")
        XCTAssertEqual(fetchedComics.last?.title, "Test Comic")
        XCTAssertEqual(fetchedComics.last?.description, "Text")
    }
    
    func testDeleteObjectByPrimaryKey() throws {
        storage.deleteAllComics()
        let comicBook = ComicBook(uniqueID: "12345", title: "Test Comic", text: "Text")
        
        storage.delete(comicBook: comicBook)
        let fetchedComics: [ComicBook] = storage.getComicsList()
        
        XCTAssertTrue(fetchedComics.isEmpty)
    }
    
    func testSaveOrUpdateAllObjects() throws {
        storage.deleteAllComics()
        let DatacomicBook1 = DataComicBook(title: "Title1", textObjects: [TextObjects(text: "Text1")])
        let DatacomicBook2 = DataComicBook(title: "Title2", textObjects: [TextObjects(text: "Text2")])
        
        storage.saveComicsList([DatacomicBook1, DatacomicBook2])
        let fetchedComics: [ComicBook] = storage.getComicsList()
        
        XCTAssertEqual(fetchedComics.count, 2)
    }
}
