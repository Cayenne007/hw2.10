//
//  AppSettingsManager.swift
//  theMars
//
//  Created by user184293 on 11/20/20.
//

import Foundation


class AppSettingsManager {
    
    static var shared = AppSettingsManager()
    
    
    private init() {}
    
    
    func loadRoverFilter() -> RoverFilter {
        
        if let savedFilter = readData(key: "filter") as RoverFilter? {
            return savedFilter
        } else {
            return defaultFilter()
        }
    }
    
    func saveRoverFilter(filter: RoverFilter) {
        writeData(filter, key: "filter")
    }
    
    func defaultFilter() -> RoverFilter {
        RoverFilter(roverType: .curiosity, date: "2014-8-14")
    }
    
    func loadFavoriteList() -> [RoverPhoto] {
        
        if let list = readData(key: "favoriteList") as [RoverPhoto]? {
            return list
        } else {
            return []
        }
        
    }
    
    func saveToFavoriteList(_ photo: RoverPhoto) {
        
        if var favoritesList = readData(key: "favoriteList") as [RoverPhoto]?,
           !favoritesList.contains(photo) {
            favoritesList.append(photo)
            writeData(favoritesList, key: "favoriteList")
        } else {
            writeData([photo], key: "favoriteList")
        }
        
    }
    
    func replaceFavoriteList(_ list: [RoverPhoto]) {
        writeData(list, key: "favoriteList")
    }
    
    private func readData<T: Decodable>(key: String) -> T? {
        if let savedData = UserDefaults.standard.data(forKey: key) ,
           let savedFavoriteList = try? JSONDecoder().decode(T.self, from: savedData) {
            return savedFavoriteList
        } else {
            return nil
        }
    }
    
    private func writeData<T: Encodable>(_ value: T, key: String) {
        guard let data = try? JSONEncoder().encode(value) else { return }
        UserDefaults.standard.set(data, forKey: key)
    }
    
}


