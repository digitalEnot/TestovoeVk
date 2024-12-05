//
//  NetworkManager.swift
//  TestovoeVk
//
//  Created by Evgeni Novik on 02.12.2024.
//

import Foundation


struct Constants {
    static let publicKey = "5769e16e8e201f21907454de0170aee2"
    static let ts = "1733138572"
    static let hash = "4d73f49ea1627d34386efcf6f3dd8a26"
    static let baseURL = "https://gateway.marvel.com:443/v1/public/comics"
}


final class NetworkManager {
    static let shared = NetworkManager()
    
    func getComics(offset: Int = 0, orderBy: FilterOpions) async throws -> [DataComicBook] {
        guard let url = URL(string: "\(Constants.baseURL)?ts=\(Constants.ts)&apikey=\(Constants.publicKey)&hash=\(Constants.hash)&orderBy=\(orderBy)&offset=\(offset)") else {
            throw TVKError.problemsWithURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw TVKError.problemsWithTheNetwork
        }
        
        do {
            let results = try JSONDecoder().decode(ComicsResponse.self, from: data)
            return results.data.comicBooks
        } catch {
            throw  TVKError.problemsWithDecodingData
        }
    }

}

