//
//  RoverFilter.swift
//  theMars
//
//  Created by Cayenne on 14.11.2020.
//


struct RoverFilter {
    
    var roverType: RoverType
    var date: String

    var description: String {
        "\(roverType) \(date)"
    }
    
    static func getDefault() -> RoverFilter {
        RoverFilter(roverType: .curiosity, date: "2014-8-14")
    }
    
}

enum RoverType: Int, CaseIterable {
    case curiosity = 0
    case opportunity = 1
    case spirit = 2
}
