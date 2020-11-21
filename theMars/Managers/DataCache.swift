//
//  DataCache.swift
//  theMars
//
//  Created by Cayenne on 21.11.2020.
//

import Foundation

class DataCache {
    
    static var shared = DataCache()
    
    private init() {}
    
    func load(url: URL) -> Data? {
        let request = URLRequest(url: url)
        let cachedData = URLCache.shared.cachedResponse(for: request)
        
        return cachedData?.data
    }
    
    func save(response: URLResponse, data: Data) {
        guard let url = response.url else { return }
        let urlRequest = URLRequest(url: url)
        let cachedResponse = CachedURLResponse(response: response, data: data)
        URLCache.shared.storeCachedResponse(cachedResponse, for: urlRequest)
    }
    
}
