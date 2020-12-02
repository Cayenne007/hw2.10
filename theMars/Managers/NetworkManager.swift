//
//  NetworkManager.swift
//  theMars
//
//  Created by Cayenne on 14.11.2020.
//

import Alamofire

class NetworkManager {
    
    static var shared = NetworkManager()
    
    private init() {}
    
    
    func loadData(filter: RoverFilter, completion: @escaping ([RoverPhoto])->()) {
        
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
    
    func fetchImage(_ url: String, completion: @escaping (UIImage?)->()) {
        
        if let data = StorageManager.shared.fetch(with: url), let image = UIImage(data: data) {
            DispatchQueue.main.async {
                completion(image)
            }
            return
        }
        
        guard let url = URL(string: url) else { return }
        
        AF.request(url).validate().responseData { (dataResponse) in
            switch dataResponse.result {
            case .success(_):
                if let data = dataResponse.data, let response = dataResponse.response {
                    
                    guard url == response.url else { return }
                    
                    StorageManager.shared.save(url: url, data: data)
                    
                    let image = UIImage(data: data)
                    DispatchQueue.main.async {
                        completion(image)
                    }
                }
            case .failure(let error): print(error)
            }
            
        }

    }
    
    
    func getRoverInfo(filter: RoverFilter, completion: @escaping (RoverInfo) -> ()) {
        
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

