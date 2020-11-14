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
}

struct RoverCamera: Decodable {
    let name: String
}

struct Rover: Decodable {
    let name: String
}

struct RoverData: Decodable {
    let photos: [RoverPhoto]
}


