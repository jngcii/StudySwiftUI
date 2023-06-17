//
//  DateValue.swift
//  StudySwiftUI
//
//  Created by peter on 2023/06/17.
//

import Foundation

struct DateValue: Identifiable {
    var id = UUID().uuidString
    var day: Int
    var date: Date
}
