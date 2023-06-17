//
//  DateHelper.swift
//  StudySwiftUI
//
//  Created by peter on 2023/06/17.
//

import Foundation

// Extending Date to get Current Month Dates...
extension Date {
    var allDates: [Date] {
        let calendar = Calendar.current
        
        // getting start Date...
        let startDate = calendar.date(from: Calendar.current.dateComponents([.year, .month], from: self))!
        
        let range = calendar.range(of: .day, in: .month, for: startDate)!
        
        return range.compactMap { day -> Date in
            return calendar.date(byAdding: .day, value: day - 1, to: startDate)!
        }
    }
    
    func isSameDay(with date: Date) -> Bool {
        let calendar = Calendar.current
        
        return calendar.isDate(self, inSameDayAs: date)
    }
}
