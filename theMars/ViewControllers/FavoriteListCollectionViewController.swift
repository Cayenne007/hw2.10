//
//  FavoriteListViewController.swift
//  theMars
//
//  Created by Cayenne on 20.11.2020.
//

import UIKit
import ImageSlideshow

protocol UpdateFavoriteListDelegate {
    func updateListFavorite()
}

class FavoriteListViewController: UIViewController, UpdateFavoriteListDelegate {

    @IBOutlet var infoLabel: UILabel!
    @IBOutlet var collectionView: UICollectionView!
    
    var imageSlideshow: ImageSlideshow!
    
    var delegate: UpdateFavoriteListDelegate!
    
    
    var list: [RoverPhoto] = [] {
        didSet{
            infoLabel.text = "Всего элементов \(list.count)"
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        list = RoverFavorite.shared.list
        collectionView.reloadData()
        imageSlideshow = ImageSlideshow(frame: CGRect(x: UIScreen.main.bounds.midX,
                                                      y: UIScreen.main.bounds.midY,
                                                      width: 10,
                                                      height: 10))
    }
    
    func updateListFavorite() {
        DispatchQueue.main.async {
            self.list = RoverFavorite.shared.list
            self.collectionView.reloadData()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        delegate.updateListFavorite()
    }

}

// MARK: UICollectionViewDataSource & Delegate
extension FavoriteListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return list.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! FavoriteListCollectionViewCell
        let photo = list[indexPath.item]
        
        cell.imageView.contentMode = .scaleAspectFill
        cell.imageView.clipsToBounds = true
        
        let interaction = UIContextMenuInteraction(delegate: self)
        cell.addInteraction(interaction)
        
        NetworkManager.shared.fetchImage(photo.imageUrl) { (image) in
            cell.imageView.image = image
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var collection: [ImageSource] = []
        for element in StorageManager.shared.fetchCollection(photos: list) {
            collection.append(ImageSource(image: element))
        }
        imageSlideshow.setImageInputs(collection)
        imageSlideshow.setCurrentPage(indexPath.row, animated: false)
        
        imageSlideshow.presentFullScreenController(from: self)
    }
}



extension FavoriteListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenSize: CGRect = UIScreen.main.bounds
        let screenWidth = screenSize.width
        return CGSize(width: (screenWidth/2)-6, height: (screenWidth/2)-6)
            
    }
}




extension FavoriteListViewController: UIContextMenuInteractionDelegate {
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        nil
    }
    
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let configuration = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { suggestedActions in
            
            let photo = self.list[indexPath.item]
            
            var actions = [UIAction]()
            
            let favoriteTitle = "Убрать из избранного"
            let favoriteImage = UIImage(systemName: "star.slash")
            let action = UIAction(title: favoriteTitle,
                                  image: favoriteImage) { _ in
                if photo.isFavorite {
                    RoverFavorite.shared.del(photo)
                }
                self.list = RoverFavorite.shared.list
                self.collectionView.deleteItems(at: [indexPath])
            }
            
            let saveAction = UIAction(title: "Сохранить",
                                      image: UIImage(systemName: "folder")) { (action) in
                NetworkManager.shared.fetchImage(photo.imageUrl) { (image) in
                    if let image = image {
                        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                        self.showAlert(title: "Сохранено", message: "")
                    }
                    
                }
            }
            
            actions.append(action)
            actions.append(saveAction)
            return UIMenu(title: "", children: actions)
        }
        return configuration
        
    }
        
}
