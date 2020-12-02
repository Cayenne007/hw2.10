//
//  StorageManager.swift
//  WooCommerce
//
//  Created by Cayenne on 28.11.2020.
//

import CoreData
import UIKit

class StorageManager {
    
    private let persistentContainer: NSPersistentContainer!
    private let context: NSManagedObjectContext!
    
    static var shared = StorageManager()
    
    
    private init() {
        
        persistentContainer = NSPersistentContainer(name: "Rover")
        persistentContainer.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        
        context = persistentContainer.viewContext
        
    }
    
    
    func fetch(with url: String) -> Data? {
     
        let fetchRequest = NSFetchRequest<PhotoEntitie>(entityName: "PhotoEntitie")
        let predicate = NSPredicate(format: "url = %@", url)
        fetchRequest.predicate = predicate
    
        if let photos = try? context.fetch(fetchRequest),
           let photo = photos.first,
           let data = photo.data {
                return data
        }
        
        return nil
        
    }
    
    func saveContext() {
        do {
            if context.hasChanges {
                try context.save()
            }
        } catch let error as NSError {
            print(error.userInfo)
        }
    }
    
    func save(url: URL, data: Data) {
        guard fetch(with: url.description) == nil else { return }
        
        let newPhoto = PhotoEntitie(context: self.context)
        newPhoto.url = url.description
        newPhoto.data = data
        saveContext()
    }
    
    func fetchCollection(photos: [RoverPhoto]) -> [UIImage] {
        
        var images: [UIImage] = []

        for photo in photos {

            let fetchRequest = NSFetchRequest<PhotoEntitie>(entityName: "PhotoEntitie")
            let predicate = NSPredicate(format: "url = %@", photo.imageUrl)
            fetchRequest.predicate = predicate

            if let fetchPhotos = try? context.fetch(fetchRequest) {
                if let data = fetchPhotos.first?.data,
                   let img = UIImage(data: data) {
                    images.append(img)
                } else {
                    images.append(UIImage(systemName: "questionmark.folder")!)
                }
            }

        }

        return images
        
//        let urls = photos.map(\.imageUrl)
//
//        let fetchRequest = NSFetchRequest<PhotoEntitie>(entityName: "PhotoEntitie")
//        let predicate = NSPredicate(format: "url IN %@", urls)
//        fetchRequest.predicate = predicate
//        
//        if let fetchPhotos = try? context.fetch(fetchRequest) {
//            
//            for url in urls {
//                if let element = fetchPhotos.first(where: {$0.url == url}),
//                   let data = element.data,
//                   let image = UIImage(data: data) {
//                    
//                    images.append(image)
//                }
//                
//            }
//        }
//        
//        return images
        
    }
        
    
    
    private func getSqliteStoreSize(forPersistentContainerUrl storeUrl: URL) -> String {
        do {
            let size = try Data(contentsOf: storeUrl)
            if size.count < 1 {
                print("Size could not be determined.")
                return ""
            }
            let bcf = ByteCountFormatter()
            bcf.allowedUnits = [.useMB] // optional: restricts the units to MB only
            bcf.countStyle = .file
            let string = bcf.string(fromByteCount: Int64(size.count))
            print(string)
            return string
        } catch {
            print("Failed to get size of store: \(error)")
            return ""
        }
    }
    
    
    func getSize() -> String {
        guard let storeUrl = context.persistentStoreCoordinator!.persistentStores.first?.url else {
            print("There is no store url")
            return ""
        }
        return getSqliteStoreSize(forPersistentContainerUrl: storeUrl)
    }
    
}
