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
        
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1) //UIColor.red.withAlphaComponent(0.5)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

enum ButtonType {
    case search
    case add
}

