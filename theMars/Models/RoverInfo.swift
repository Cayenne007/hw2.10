//
//  RoverInfo.swift
//  theMars
//
//  Created by Cayenne on 14.11.2020.
// 

struct RoverInfo: Decodable {
    let launchDate: String
    let status: String
    let maxSol: Int
    let maxDate: String
    let totalPhotos: Int
    
    var info: String {
        """
            Статус: \(status)
            Начало миссии: \(launchDate)
            Последняя активность: \(maxDate)
            Всего фото: \(totalPhotos)
        """
    }
    
    init(with data: [String : Any]) {
        launchDate = data["launch_date"] as? String ?? "N/A"
        status = data["status"] as? String ?? "N/A"
        maxSol = data["max_sol"] as? Int ?? 0
        maxDate = data["max_date"] as? String ?? "N/A"
        totalPhotos = data["total_photos"] as? Int ?? 0
    }
}

struct RoverManifest: Decodable {
    let photo_manifest: RoverInfo
    
    static func getRoverInfo(data: Any) -> RoverInfo {
        if let data = data as? [String : [String : Any]],
           let roverData = data["photo_manifest"]{
                return RoverInfo(with: roverData)
        } else {
            return RoverInfo(with: [:])
        }
              
              
    }
}
