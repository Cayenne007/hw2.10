//
//  RoverPhoto.swift
//  theMars
//
//  Created by Cayenne on 14.11.2020.
//

struct RoverPhoto: Decodable {
    let sol: Int
    let camera: RoverCamera
    let img_src: String
    let earth_date: String  //YYYY-MM-DD
    let rover: Rover
    
    
    var description: String {
        """
        camera: \(camera.name)
        sol: \(sol)
        date: \(earth_date)
        rover: \(rover.name)
        """
    }
    
    init(with data: [String : Any]) {
        sol = data["sol"] as? Int ?? 0
        camera = RoverCamera(with: data["camera"])
        img_src = data["img_src"] as? String ?? ""
        earth_date = data["earth_date"] as? String ?? ""
        rover = Rover(with: data["rover"])
        
    }
}

struct RoverCamera: Decodable {
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

struct Rover: Decodable {
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


