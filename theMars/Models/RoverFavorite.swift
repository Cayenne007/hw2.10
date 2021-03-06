//
//  RoverFavorite.swift
//  theMars
//
//  Created by Cayenne on 20.11.2020.
//

class RoverFavorite {
    
    static var shared = RoverFavorite()
    var list: [RoverPhoto] = AppSettingsManager.shared.loadFavoriteList()
    
    private init() {}
    
    func add(_ photo: RoverPhoto) {
        if !list.contains(photo) {
            list.append(photo)
        }
        AppSettingsManager.shared.saveToFavoriteList(photo)
    }
    
    func del(_ photo: RoverPhoto) {
        list.removeAll(where: {$0 == photo})
        AppSettingsManager.shared.replaceFavoriteList(list)
    }
    
    func isFavorite(_ photo: RoverPhoto) -> Bool {
        list.contains(photo)
    }
    
}
