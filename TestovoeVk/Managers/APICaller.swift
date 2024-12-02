//
//  APICaller.swift
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


enum ApiError: Error {
    case failedToGetData
}


final class APICaller {
    static let shared = APICaller()
    
    func getComics(offset: Int = 0, completion: @escaping (Result<[ComicBook], Error>) -> Void) {
        guard let url = URL(string: "\(Constants.baseURL)?ts=\(Constants.ts)&apikey=\(Constants.publicKey)&hash=\(Constants.hash)&offset=\(offset)") else { return }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else { return }
            
            do {
                let results = try JSONDecoder().decode(ComicsResponse.self, from: data)
                completion(.success(results.data.comicBooks))
            } catch {
                completion(.failure(ApiError.failedToGetData))
            }
        }
        task.resume()
    }
}
