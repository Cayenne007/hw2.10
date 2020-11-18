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
    func plus(_ value: Int = 1) -> String {
        var dayComponent    = DateComponents()
        dayComponent.day    = value
        let theCalendar     = Calendar.current
        let date            = self.toDate ?? Date()
        
        let newDate         = theCalendar.date(byAdding: dayComponent, to: date) ?? Date()
        
        return newDate.toString
    }
}
