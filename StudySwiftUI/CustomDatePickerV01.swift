//
//  CustsomDatePickerV01.swift
//  StudySwiftUI
//
//  Created by peter on 2023/06/17.
//

import SwiftUI

struct Task: Identifiable {
    var id: String = UUID().uuidString
    var title: String
    var time: Date = Date()
}

struct TaskMetaData: Identifiable {
    var id: String = UUID().uuidString
    var task: [Task]
    var taskDate: Date
}

func getSampleDate(offset: Int) -> Date {
    let calendar = Calendar.current
    
    let date = calendar.date(byAdding: .day, value: offset, to: Date())
    
    return date ?? Date()
}

var tasks: [TaskMetaData] = [
    TaskMetaData(task: [
        Task(title: "Talk to iJustin"),
        Task(title: "iPhone 13, Great Design Change"),
        Task(title: "Nothing Much Workout")
    ], taskDate: getSampleDate(offset: 1)),
    TaskMetaData(task: [
        Task(title: "Talk To Jenna")
    ], taskDate: getSampleDate(offset: -3)),
    TaskMetaData(task: [
        Task(title: "Meeting with Tim Cook")
    ], taskDate: getSampleDate(offset: -8)),
    TaskMetaData(task: [
        Task(title: "Next Version of SwiftUI"),
    ], taskDate: getSampleDate(offset: 10)),
    TaskMetaData(task: [
        Task(title: "Nothing Much Workout")
    ], taskDate: getSampleDate(offset: -22)),
    TaskMetaData(task: [
        Task(title: "iPhone 13, Great Design Change"),
    ], taskDate: getSampleDate(offset: 15)),
    TaskMetaData(task: [
        Task(title: "Kavsoft App Updates")
    ], taskDate: getSampleDate(offset: 2))
]

struct CustomDatePickerV01: View {
    @Binding var currentDate: Date
    
    // Month update on arrow button clicks
    @State private var currentMonth: Int = 6
    
    var body: some View {
        VStack(spacing: 35) {
            let days: [String] = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
            
            HStack(spacing: 20) {
                
                VStack(alignment: .leading, spacing: 10) {
                    Text(extraData[0])
                        .font(.caption)
                        .fontWeight(.semibold)
                    
                    Text(extraData[1])
                        .font(.title.bold())
                }
                
                Spacer(minLength: 0)
                
                Button(action: {
                    withAnimation { self.currentMonth -= 1 }
                }) {
                    Image(systemName: "chevron.left").font(.title2)
                }
                
                Button(action: {
                    withAnimation { self.currentMonth += 1 }
                }) {
                    Image(systemName: "chevron.right").font(.title2)
                }
            }
            .padding(.horizontal)
            
            // Day View ...
            HStack(spacing: 0) {
                ForEach(days, id: \.self) { day in
                    Text(day)
                        .font(.callout)
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                }
            }
            .padding(.horizontal)
            
            // Date ...
            // Lazy Grid..
            let columns = Array(repeating: GridItem(.flexible()), count: 7)
            
            LazyVGrid(columns: columns, spacing: 15) {
                ForEach(extractDate()) { value in
                    CardView(value: value)
                        .background {
                            Capsule()
                                .fill(Color.pink)
                                .padding(.horizontal, 8)
                                .opacity(value.date.isSameDay(with: currentDate) ? 1 : 0)
                        }
                        .onTapGesture {
                            currentDate = value.date
                        }
                }
            }.padding(.horizontal)
            
            VStack(spacing: 20) {
                Text("Tasks")
                    .font(.title2.bold())
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                if let task = tasks.first(where: { $0.taskDate.isSameDay(with: currentDate) }) {
                    ForEach(task.task) { task in
                        VStack(alignment: .leading, spacing: 10) {
                            Text(
                                task.time.addingTimeInterval(CGFloat.random(in: 0...5000)),
                                style: .time
                            )
                            
                            Text(task.title)
                                .font(.title2.bold())
                        }
                        .padding(.vertical, 10)
                        .padding(.horizontal)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background {
                            Color.purple
                                .opacity(0.5)
                                .cornerRadius(10)
                        }
                    }
                } else {
                    Text("No Task Found")
                }
            }
            .padding()
        }
        .onChange(of: currentMonth) { changed in
            // Update Month ...
            self.currentDate = getCurrentMonth()
        }
    }
    
    @ViewBuilder
    func CardView(value: DateValue) -> some View {
        VStack {
            if value.day != -1 {
                if let task = tasks.first(where: { $0.taskDate.isSameDay(with: value.date) }) {
                    Text("\(value.day)")
                        .font(.title3.bold())
                        .foregroundColor(value.date.isSameDay(with: currentDate) ? .white : .primary)
                        .frame(maxWidth: .infinity)
                    
                    Spacer()
                    
                    Circle()
                        .fill(task.taskDate.isSameDay(with: currentDate) ? .white : .pink)
                        .frame(width: 8, height: 8)
                } else {
                    Text("\(value.day)")
                        .font(.title3.bold())
                        .foregroundColor(value.date.isSameDay(with: currentDate) ? .white : .primary)
                        .frame(maxWidth: .infinity)
                    
                    Spacer()
                }
            }
        }
        .padding(.vertical, 9)
        .frame(height: 60, alignment: .top)
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

struct CustsomDatePickerV01_Previews: PreviewProvider {
    static var previews: some View {
        ElegantCalendarTask()
    }
}
