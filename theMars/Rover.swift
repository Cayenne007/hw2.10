//
//  RoverPhoto.swift
//  theMars
//
//  Created by Cayenne on 14.11.2020.
//

struct RoverPhoto: Decodable {
    var sol: Int
    var camera: RoverCamera
    var img_src: String
    var earth_date: String  //YYYY-MM-DD
    var rover: Rover
    
    var description: String {
        """
        camera: \(camera.name)
        sol: \(sol)
        date: \(earth_date)
        rover: \(rover.name)
        """
    }
}

struct RoverCamera: Decodable {
    var name: String
}

struct Rover: Decodable {
    var name: String
}

struct RoverData: Decodable {
    var photos: [RoverPhoto]
}


