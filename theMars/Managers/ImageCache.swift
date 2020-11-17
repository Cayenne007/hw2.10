//
//  ImageCache.swift
//  theMars
//
//  Created by Cayenne on 17.11.2020.
//

import UIKit

class ImageCache {
    
    private var list: [String: UIImage] = [:]
    
    static var shared = ImageCache()
    
    
    private init() {}
    
    func load(_ url: String) -> UIImage? {
        ImageCache.shared.list[url]
    }
    
    func save(_ url: String,_ image: UIImage?) {
        ImageCache.shared.list[url] = image
    }
    
    func count() -> Int {
        ImageCache.shared.list.count
    }
    
}
