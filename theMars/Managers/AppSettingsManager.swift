//
//  AppSettingsManager.swift
//  theMars
//
//  Created by user184293 on 11/20/20.
//

import Foundation


class AppSettingsManager {
    static var standart = AppSettingsManager()
    private init() {}
    
    func loadRoverFilter() -> RoverFilter {
        
        if let savedData = UserDefaults.standard.data(forKey: "filter") ,
           let savedFilter = try? JSONDecoder().decode(RoverFilter.self, from: savedData){
            return savedFilter
        } else {
            return RoverFilter(roverType: .curiosity, date: "2014-8-14")
        }
    }
    
    func saveRoverFilter(filter: RoverFilter) {
        
        guard let dataFilter = try? JSONEncoder().encode(filter) else { return }
        UserDefaults.standard.set(dataFilter, forKey: "filter")
    }
    
    
}
