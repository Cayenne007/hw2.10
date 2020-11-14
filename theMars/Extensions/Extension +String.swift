//
//  Extension +String.swift
//  theMars
//
//  Created by Cayenne on 14.11.2020.
//

import Foundation

extension String {
    var toDate: Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-M-d"
        return dateFormatter.date(from: self)
    }
}
