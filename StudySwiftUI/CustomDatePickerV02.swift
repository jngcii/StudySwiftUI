//
//  CustomDatePickerV02.swift
//  StudySwiftUI
//
//  Created by peter on 2023/06/17.
//

import SwiftUI

struct CustomDatePickerV02: View {
    @Binding var currentDate: Date
    
    // Month update on arrow button clicks
    @State private var currentMonth: Int = 0
    
    // MARK: Animated Sates
    @State private var animatedStates: [Bool] = Array(repeating: false, count: 2)
    
    var body: some View {
        VStack(spacing: 15) {
            HStack(spacing: 20) {
                Button(action: {
                    withAnimation { self.currentMonth -= 1 }
                }) {
                    Image(systemName: "chevron.left").font(.title3)
                }
                
                Text(extraData[0] + " " + extraData[1])
                    .font(.callout)
                    .fontWeight(.semibold)
                
                Button(action: {
                    withAnimation { self.currentMonth += 1 }
                }) {
                    Image(systemName: "chevron.right").font(.title3)
                }
            }
            .foregroundColor(.white)
            .padding(.horizontal)
            .opacity(animatedStates[0] ? 1 : 0)
            
            Rectangle()
                .fill(.white.opacity(0.4))
                .frame(width: animatedStates[0] ? nil : 0, height: 1)
                .padding(.vertical, 4)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            // Date ...
            // Lazy Grid..
            let columns = Array(repeating: GridItem(.flexible()), count: 7)
            
            if animatedStates[0] {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(0..<extractDate().count, id: \.self) { index in
                        let value = extractDate()[index]
                        PickerCardView(value: value, index: index, currentDate: $currentDate, isFinished: $animatedStates[1])
                            .onTapGesture {
                                currentDate = value.date
                            }
                    }
                }
            } else {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(extractDate().indices, id: \.self) { index in
                        let value = extractDate()[index]
                        PickerCardView(value: value, index: index, currentDate: $currentDate, isFinished: $animatedStates[1])
                            .onTapGesture {
                                currentDate = value.date
                            }
                    }
                }
                .opacity(0)
            }
        }
        .padding()
        .onChange(of: currentMonth) { changed in
            // Update Month ...
            self.currentDate = getCurrentMonth()
        }
        .onAppear {
            // Animatin View with some Delay
            // Delay for splash animation to sync with the current one
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                withAnimation(.easeInOut(duration: 0.3)) {
                    animatedStates[0] = true
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        animatedStates[1] = true
                    }
                }
            }
        }
    }
    
    // extracting year and month for display ...
    var extraData: [String] {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY MMMM"
        
        let date = formatter.string(from: currentDate)
        
        return date.components(separatedBy: " ")
    }
    
    func getCurrentMonth() -> Date {
        let calendar = Calendar.current
        
        guard let currentMonth = calendar.date(byAdding: .month, value: self.currentMonth, to: Date()) else {
            return Date()
        }
        
        return currentMonth
    }
    
    func extractDate() -> [DateValue] {
        let calendar = Calendar.current
        
        let currentMonth = getCurrentMonth()
        
        var days = currentMonth.allDates.compactMap { date -> DateValue in
            let day = calendar.component(.day, from: date)
            return DateValue(day: day, date: date)
        }
        
        // adding offset days to get extract week day...
        
        let firstWeekday = calendar.component(.weekday, from: days.first?.date ?? Date())
        
        for _ in 0..<firstWeekday - 1 {
            days.insert(DateValue(day: -1, date: Date()), at: 0)
        }
        
        return days
    }
}

struct PickerCardView: View {
    var value: DateValue
    var index: Int
    @Binding var currentDate: Date
    @Binding var isFinished: Bool
    
    @State var showView: Bool = false
    var body: some View {
        VStack {
            if value.day != -1 {
                Text("\(value.day)")
                    .font(.callout)
                    .fontWeight(.semibold)
                    .foregroundColor(value.date.isSameDay(with: currentDate) ? .black : .white)
                    .frame(maxWidth: .infinity)
            }
        }
        .background {
            RoundedRectangle(cornerRadius: 5, style: .continuous)
                .fill(.white)
                .padding(.vertical, -5)
                .padding(.horizontal, 5)
                .opacity(value.date.isSameDay(with: currentDate) ? 1 : 0)
        }
        .opacity(showView ? 1 : 0)
        .onAppear {
            // Since every time month changed its animating
            // Stopping it for only First time
            if isFinished { showView = true }
            withAnimation(.spring().delay(Double(index) * 0.02)) {
                self.showView = true
            }
        }
    }
}

struct CustsomDatePickerV02_Previews: PreviewProvider {
    static var previews: some View {
        CalendarAccountBook()
    }
}
