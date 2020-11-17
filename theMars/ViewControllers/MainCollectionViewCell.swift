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
        
        NetworkManager.fetchImage(url: photo.img_src) { (image) in
            self.imageView.image = image
        }
        
    }
}
