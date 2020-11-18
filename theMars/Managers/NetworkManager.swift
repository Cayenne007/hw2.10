//
//  NetworkManager.swift
//  theMars
//
//  Created by Cayenne on 14.11.2020.
//

import Alamofire

struct NetworkManager {
    
    static func loadData(filter: RoverFilter, completion: @escaping ([RoverPhoto])->()) {
        
        ImageCache.shared.list.removeAll()
        
        let url = "https://api.nasa.gov/mars-photos/api/v1/rovers/\(filter.roverType)/photos?earth_date=\(filter.date)&api_key=v7ik3uNVNN925fUHxcySjJGqpbgLT5sab29rjoV7"
        
        AF.request(url).validate().responseJSON { (dataResponse) in
            switch dataResponse.result {
            
            case .success(let value):
                
                DispatchQueue.main.async {
                    completion(RoverData.getRoverPhotos(data: value))
                }
                
            case .failure(let error): print(error)
            }
        }
       
    }
    
    static func fetchImage(url: String, completion: @escaping (UIImage?)->()) {
        
        if let image = ImageCache.shared.load(url) {
            completion(image)
            return
        }
        
        AF.request(url).validate().responseData { (dataResponse) in
            switch dataResponse.result {
            case .success(_):
                if let data = dataResponse.data {
                    let image = UIImage(data: data)
                    ImageCache.shared.save(url, image)
                    DispatchQueue.main.async {
                        completion(image)
                    }
                }
            case .failure(let error): print(error)
            }
            
        }
        
    }
    
    
    static func getRoverInfo(filter: RoverFilter, completion: @escaping (RoverInfo) -> ()) {
        
        let url = "https://api.nasa.gov/mars-photos/api/v1/manifests/\(filter.roverType)?api_key=v7ik3uNVNN925fUHxcySjJGqpbgLT5sab29rjoV7"
        
        AF.request(url).validate().responseJSON { (dataResponse) in
            switch dataResponse.result {
            
            case .success(let value):
                
                completion(RoverManifest.getRoverInfo(data: value))
                
            case .failure(let error): print(error)
            }
        }

    }
    
}

