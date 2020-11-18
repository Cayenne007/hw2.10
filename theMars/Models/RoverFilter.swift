//
//  RoverFilter.swift
//  theMars
//
//  Created by Cayenne on 14.11.2020.
//


struct RoverFilter {
    
    static let defaultDate = "2014-8-14"
    
    var roverType: RoverType
    var date: String


    var description: String {
        "\(roverType) \(date)"
    }
    
    static func getDefault() -> RoverFilter {
        RoverFilter(roverType: .curiosity, date: RoverFilter.defaultDate)
    }
    
}

enum RoverType: Int, CaseIterable {
    case curiosity = 0
    case opportunity = 1
    case spirit = 2
}
