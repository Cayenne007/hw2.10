//
//  FilterButton.swift
//  theMars
//
//  Created by Cayenne on 17.11.2020.
//

import UIKit

class FavoriteButton: UIButton {

    var isFavorite: Bool {
        didSet{
            setFavorite()
        }
    }
    
    private var favoriteImage = UIImage(systemName: "bookmark.fill",
                                        withConfiguration: UIImage.SymbolConfiguration(scale: .large))
    private var normalImage = UIImage(systemName: "bookmark",
                                        withConfiguration: UIImage.SymbolConfiguration(scale: .default))
    

    required init(_ isFavorite: Bool) {
        
        self.isFavorite = isFavorite
        
        super.init(frame: .zero)
        
        layer.cornerRadius = 25
        
        clipsToBounds = true
        
        translatesAutoresizingMaskIntoConstraints = false
        
    }
    

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func pulsate() {
        let pulse = CASpringAnimation(keyPath: "transform.scale")
        pulse.fromValue = 0.8
        pulse.toValue = 1
        pulse.duration = 0.6
        pulse.autoreverses = true
        pulse.repeatCount = 2
        pulse.initialVelocity = 0.9
        pulse.damping = 1
        
        layer.add(pulse, forKey: nil)
    }
    
    private func setFavorite() {
        if isFavorite {
            setImage(favoriteImage, for: .normal)
            imageView?.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            imageEdgeInsets = UIEdgeInsets(top: 40, left: 40, bottom: 40, right: 40)
            backgroundColor = UIColor.red.withAlphaComponent(0.8)
        } else {
            setImage(normalImage, for: .normal)
            imageView?.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            imageEdgeInsets = UIEdgeInsets(top: 40, left: 40, bottom: 40, right: 40)
            backgroundColor = UIColor.red.withAlphaComponent(0)
        }
    }
    
}
