//
//  RoverInfo.swift
//  theMars
//
//  Created by Cayenne on 14.11.2020.
// 

struct RoverInfo: Decodable {
    var launch_date: String
    var status: String
    var max_sol: Int
    var max_date: String
    var total_photos: Int
}

struct RoverManifest: Decodable {
    var photo_manifest: RoverInfo
}
