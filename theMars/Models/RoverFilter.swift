//
//  RoverFilter.swift
//  theMars
//
//  Created by Cayenne on 14.11.2020.
//


struct RoverFilter: Codable {
    
    var roverType: RoverType
    var date: String

    var description: String {
        "\(roverType) \(date)"
    }
    
}

enum RoverType: Int, Codable, CaseIterable {
    case curiosity = 0
    case opportunity = 1
    case spirit = 2
}
