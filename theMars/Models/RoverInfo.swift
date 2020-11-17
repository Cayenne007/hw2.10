//
//  RoverInfo.swift
//  theMars
//
//  Created by Cayenne on 14.11.2020.
// 

struct RoverInfo: Decodable {
    let launch_date: String
    let status: String
    let max_sol: Int
    let max_date: String
    let total_photos: Int
    
    var info: String {
        """
            Статус: \(status)
            Начало миссии: \(launch_date)
            Последняя активность: \(max_date)
            Всего фото: \(total_photos)
        """
    }
    
    init(with data: [String : Any]) {
        launch_date = data["launch_date"] as? String ?? "N/A"
        status = data["status"] as? String ?? "N/A"
        max_sol = data["max_sol"] as? Int ?? 0
        max_date = data["max_date"] as? String ?? "N/A"
        total_photos = data["total_photos"] as? Int ?? 0
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
