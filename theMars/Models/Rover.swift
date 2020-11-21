//
//  RoverPhoto.swift
//  theMars
//
//  Created by Cayenne on 14.11.2020.
//

class RoverPhoto: Codable, Equatable {
        
    let sol: Int
    let camera: RoverCamera
    var imageUrl: String
    let earthDate: String  //YYYY-MM-DD
    let rover: Rover
    
    
    var description: String {
        """
        camera: \(camera.name)
        sol: \(sol)
        date: \(earthDate)
        rover: \(rover.name)
        """
    }
    
    var isFavorite: Bool {
        get {
            RoverFavorite.shared.isFavorite(self)
        }
        set {
                if newValue {
                    RoverFavorite.shared.add(self)
                } else {
                    RoverFavorite.shared.del(self)
                }
            }
        }
    
    init(with data: [String : Any]) {
        sol = data["sol"] as? Int ?? 0
        camera = RoverCamera(with: data["camera"])
        imageUrl = data["img_src"] as? String ?? "N/A"
        imageUrl = imageUrl.replacingOccurrences(of: "http://mars.jpl.nasa.gov", with: "https://mars.nasa.gov")
        
        earthDate = data["earth_date"] as? String ?? "N/A"
        rover = Rover(with: data["rover"])
        
    }
    
    static func == (lhs: RoverPhoto, rhs: RoverPhoto) -> Bool {
        lhs.imageUrl == rhs.imageUrl
    }
}

struct RoverCamera: Codable {
    let name: String
    init(with data: Any?) {
        if let data = data as? [String: Any],
              let name = data["name"] as? String {
            self.name = name
        } else {
            name = "N/A"
        }
        
    }
}

struct Rover: Codable {
    let name: String
    init(with data: Any?) {
        if let data = data as? [String: Any],
              let name = data["name"] as? String {
            self.name = name
        } else {
            name = "N/A"
        }
        
    }
}

struct RoverData: Decodable {
    
    let photos: [RoverPhoto]
    
    static func getRoverPhotos(data: Any?) -> [RoverPhoto] {
        
        guard let data = data as? [String : Any],
              let photosData = data["photos"] as? [[String: Any]]
        else {
            print("incorrect data")
            return []
        }
        
        return photosData.compactMap{RoverPhoto(with: $0)}
        
    }
}


