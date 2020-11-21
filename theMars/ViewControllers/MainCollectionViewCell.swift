//
//  MainCollectionViewCell.swift
//  theMars
//
//  Created by Cayenne on 14.11.2020.
//

import UIKit

class MainCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet var imageView: UIImageView!
    
    
    func setData(photo: RoverPhoto, item: Int) {
        
        self.imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = nil

        imageView.layer.borderWidth = photo.isFavorite ? 3 : 0
        imageView.layer.borderColor = UIColor.red.cgColor
        
        NetworkManager.fetchImage(photo.imageUrl) { (image) in
            self.imageView.image = image
        }
        
    }
}
