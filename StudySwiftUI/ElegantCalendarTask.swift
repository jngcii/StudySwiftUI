//
//  ElegantCalendarTask.swift
//  StudySwiftUI
//
//  Created by peter on 2023/06/17.
//

import SwiftUI

struct ElegantCalendarTask: View {
    @State private var currentDate: Date = Date()
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 20) {
                CustomDatePickerV01(currentDate: $currentDate)
            }
            .padding(.vertical)
        }
        .safeAreaInset(edge: .bottom) {
            HStack {
                Button(action: {}) {
                    Text("Add Task")
                        .fontWeight(.bold)
                        .padding(.vertical)
                        .frame(maxWidth: .infinity)
                        .background(Color.orange, in: Capsule())
                }
                
                Button(action: {}) {
                    Text("Add Reminder")
                        .fontWeight(.bold)
                        .padding(.vertical)
                        .frame(maxWidth: .infinity)
                        .background(Color.purple, in: Capsule())
                }
            }
            .padding(.horizontal)
            .padding(.top, 10)
            .foregroundColor(.white)
            .background(.thinMaterial)
        }
    }
}

struct ElegantCalendarTask_Previews: PreviewProvider {
    static var previews: some View {
        ElegantCalendarTask()
    }
}
