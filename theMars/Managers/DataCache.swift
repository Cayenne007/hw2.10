//
//  DataCache.swift
//  theMars
//
//  Created by Cayenne on 21.11.2020.
//

import Foundation

class DataCache {
    
    var cacheDiskUsage: Int {
        URLCache.shared.currentDiskUsage / 1_000_000
    }
    var cacheRamUsage: Int {
        URLCache.shared.currentMemoryUsage / 1_000_000
    }
    var cacheInfo: String {
        """
        Кеш изображений:
        Диск: \(cacheDiskUsage) Mb
        RAM: \(cacheRamUsage) Mb
        """
    }
    
    static var shared = DataCache()
    
    private init() {
        URLCache.shared.diskCapacity = 500_000_000
        URLCache.shared.memoryCapacity = 100_000_000
    }
    
    func load(url: URL) -> Data? {
        let request = URLRequest(url: url)
        let cachedData = URLCache.shared.cachedResponse(for: request)
        
        return cachedData?.data
    }
    
    func save(url: URL, response: URLResponse, data: Data) {
        let urlRequest = URLRequest(url: url)
        let cachedResponse = CachedURLResponse(response: response, data: data)
        URLCache.shared.storeCachedResponse(cachedResponse, for: urlRequest)
    }
    
    func removeAll() {
        URLCache.shared.removeAllCachedResponses()
    }
    
}
