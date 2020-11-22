//
//  FavoriteListViewController.swift
//  theMars
//
//  Created by Cayenne on 20.11.2020.
//

import UIKit

protocol UpdateFavoriteListDelegate {
    func updateListFavorite()
}

class FavoriteListViewController: UIViewController, UpdateFavoriteListDelegate {

    @IBOutlet var infoLabel: UILabel!
    @IBOutlet var collectionView: UICollectionView!
    
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
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let photoVC = segue.destination as? PhotoViewController {
            photoVC.photos = list
            photoVC.photoIndex = sender as? Int ?? 0
            photoVC.delegate = self
        }
    
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
        // #warning Incomplete implementation, return the number of sections
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
        
        NetworkManager.shared.fetchImage(photo.imageUrl) { (image) in
            cell.imageView.image = image
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "photo", sender: indexPath.item)
    }
}



extension FavoriteListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenSize: CGRect = UIScreen.main.bounds
        let screenWidth = screenSize.width
        return CGSize(width: (screenWidth/2)-6, height: (screenWidth/2)-6)
            
    }
}
