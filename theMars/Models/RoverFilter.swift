//
//  RoverFilter.swift
//  theMars
//
//  Created by Cayenne on 14.11.2020.
//


struct RoverFilter {
    
    var roverType: RoverType
    var date: String

    static func getDefault() -> RoverFilter {
        RoverFilter(roverType: .curiosity, date: "2015-6-1")
    }
    
}

enum RoverType: Int, CaseIterable {
    case curiosity = 0
    case opportunity = 1
    case spirit = 2
}