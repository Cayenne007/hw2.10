//
//  MainCollectionViewCell.swift
//  theMars
//
//  Created by Cayenne on 14.11.2020.
//

import UIKit

class MainCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet var imageView: UIImageView!
    
    
    func setData(photo: RoverPhoto) {
        
        self.imageView.contentMode = .scaleAspectFill
        self.imageView.clipsToBounds = true
        
        NetworkManager.fetchImageToImageView(url: photo.img_src, imageView: imageView)
        
    }
}
