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
        //super.init(type: .custom)
        
        layer.cornerRadius = 25
        
        clipsToBounds = true
        let boldConfig = UIImage.SymbolConfiguration(weight: .bold)
        setImage(UIImage(systemName: systemName, withConfiguration: boldConfig), for: .normal)
        imageView?.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        imageView?.alpha = 0
        
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = UIColor.red.withAlphaComponent(0.8)
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

