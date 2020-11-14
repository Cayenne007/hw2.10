//
//  Extension +Date.swift
//  theMars
//
//  Created by Cayenne on 14.11.2020.
//

import Foundation

extension Date {
    var toString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-M-d"
        return dateFormatter.string(from: self)
    }
}
