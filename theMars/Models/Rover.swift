//
//  RoverPhoto.swift
//  theMars
//
//  Created by Cayenne on 14.11.2020.
//

class RoverPhoto: Codable, Equatable {
    
    let id: Int
    let sol: Int
    let camera: RoverCamera
    let imageUrl: String
    let earthDate: String  //YYYY-MM-DD
    let rover: Rover
    
    
    var description: String {
        """
        camera: \(camera.fullName)
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
        id = data["id"] as? Int ?? 0
        sol = data["sol"] as? Int ?? 0
        camera = RoverCamera(data["camera"])
        earthDate = data["earth_date"] as? String ?? "N/A"
        rover = Rover(data["rover"])
        
        let rawImageUrl = data["img_src"] as? String ?? "N/A"
        //json fix for cache
        imageUrl = rawImageUrl.replacingOccurrences(of: "http://mars.jpl.nasa.gov", with: "https://mars.nasa.gov")
        
    }
    
    static func == (lhs: RoverPhoto, rhs: RoverPhoto) -> Bool {
        lhs.imageUrl == rhs.imageUrl
    }
}

struct RoverCamera: Codable {
    let name: String
    let fullName: String
    init(_ data: Any?) {
        let dict = data as? [String: Any] ?? [:]
        name = dict["name"] as? String ?? "N/A"
        fullName = dict["full_name"] as? String ?? "N/A"
    }
}

struct Rover: Codable {
    let name: String
    init(_ data: Any?) {
        let dict = data as? [String: Any] ?? [:]
        name = dict["name"] as? String ?? "N/A"
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
        
        var result = photosData.compactMap{RoverPhoto(with: $0)}
        result.sort(by: {$0.id < $1.id})
        
        return result
        
    }
}


