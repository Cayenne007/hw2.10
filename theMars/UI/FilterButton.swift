//
//  FilterButton.swift
//  theMars
//
//  Created by Cayenne on 17.11.2020.
//

import UIKit

class FilterButton: UIButton {


    required init(systemName: String) {
        
        super.init(frame: .zero)
        
        layer.cornerRadius = 25
        
        clipsToBounds = true
        setImage(UIImage(systemName: systemName), for: .normal)
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if systemName == "magnifyingglass" {
            backgroundColor = UIColor.red.withAlphaComponent(0.6)
            imageView?.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        } else {
            backgroundColor = UIColor.red.withAlphaComponent(0.5)
            imageView?.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }
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
    
}
