//
//  NetworkManager.swift
//  TestovoeVk
//
//  Created by Evgeni Novik on 02.12.2024.
//

import UIKit

final class NetworkManager {
    let cache = NSCache<NSString, UIImage>()
    static let shared = NetworkManager()
    private init() {}
        
    
    func downloadPhoto(from urlString: String) async throws -> UIImage {
        let cacheKey = NSString(string: urlString)
        
        if let cachedImage = cache.object(forKey: cacheKey) {
            return cachedImage
        }
        guard let url = URL(string: urlString) else {
            throw URLError(.resourceUnavailable)
            //                throw TMUError.problemsWithURL
        }
        print(urlString)
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            //                throw TMUError.problemsWithTheNetwork
            throw URLError(.resourceUnavailable)
        }
        guard let image = UIImage(data: data) else {
            //                throw TMUError.problemsWithConvertingDataIntoImage
            throw URLError(.resourceUnavailable)
        }
        
        cache.setObject(image, forKey: cacheKey)
        return image
    }
}
