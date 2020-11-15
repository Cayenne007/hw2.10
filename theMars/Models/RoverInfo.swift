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
}

struct RoverManifest: Decodable {
    let photo_manifest: RoverInfo
}
