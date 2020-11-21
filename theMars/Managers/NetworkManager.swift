//
//  NetworkManager.swift
//  theMars
//
//  Created by Cayenne on 14.11.2020.
//

import Alamofire

struct NetworkManager {
    
    static func loadData(filter: RoverFilter, completion: @escaping ([RoverPhoto])->()) {
        
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
    
    static func fetchImage(_ url: String, completion: @escaping (UIImage?)->()) {
        
        guard let url = URL(string: url) else { return }
        
        if let data = DataCache.shared.load(url: url), let image = UIImage(data: data) {
            DispatchQueue.main.async {
                completion(image)
            }
            return
        }
        
        AF.request(url).validate().responseData { (dataResponse) in
            switch dataResponse.result {
            case .success(_):
                if let data = dataResponse.data, let response = dataResponse.response {
                    
                    DataCache.shared.save(response: response, data: data)
                    
                    guard url == response.url else { return }
                    
                    let image = UIImage(data: data)
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

