//
//  NetworkManager.swift
//  theMars
//
//  Created by Cayenne on 14.11.2020.
//

import UIKit

struct NetworkManager {
    
    static func loadData(filter: RoverFilter, delegate: ResultsDidLoadDelegate) {
        
        let strUrl = "https://api.nasa.gov/mars-photos/api/v1/rovers/\(filter.roverType)/photos?earth_date=\(filter.date)&api_key=v7ik3uNVNN925fUHxcySjJGqpbgLT5sab29rjoV7"
  
        guard let url = URL(string: strUrl) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, _, error) in
        
            if let error = error {
                print(error)
                return
            }
            
            guard let data = data else {
                print("data has an incorrect structure")
                return
            }
            
            do {
                let photos = try JSONDecoder().decode(RoverData.self, from: data)
                delegate.updateList(photos: photos.photos, filter: filter)
            } catch {
                print(error)
            }
        
            
        }.resume()
    }
    
    static func fetchImageToImageView(url: String, imageView: UIImageView?) {
        
        DispatchQueue.global().async {
            
            
            guard let url = URL(string: url) else { return }
            
            URLSession.shared.dataTask(with: url) { (data, _, error) in
                
                if let error = error {
                    print(error)
                    return
                }
                
                guard let data = data else {
                    print("data has an incorrect structure")
                    return
                }
                
                DispatchQueue.main.async {
                    imageView?.image = UIImage(data: data)
                }
                
                
            }.resume()
            
        }
    }
    
}

