//
//  CustomDatePicker.swift
//  CalendarSelf
//
//  Created by Kyungyun Lee on 03/03/2022.
//

import SwiftUI

struct CustomDatePicker: View {
    
    @Binding var currentDate : Date
    
    let column = Array(repeating: GridItem(.flexible()), count: 7)
    let dates : [String] = [ "Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    
    @State var currentMonth = 0
    
    var body: some View {
        VStack {
            HStack {
                VStack {
                    Text(extraDate()[0])
                    Text(extraDate()[1])
                }
                .padding()
                Spacer()
                
                Button(action: {
                    currentMonth -= 1
                }, label: {
                    Image(systemName: "chevron.left")
                        .frame(width : 30, height : 30)
                        .background(.blue)
                        .foregroundColor(.white)
                        .mask(Rectangle())
                        .cornerRadius(10)
                })
                
                Button(action: {
                    currentMonth += 1
                }, label: {
                    Image(systemName: "chevron.right")
                        .frame(width : 30, height : 30)
                        .background(.blue)
                        .foregroundColor(.white)
                        .mask(Rectangle())
                        .cornerRadius(10)
                })
                .padding()
            }
            
            HStack(spacing: 25) {
                ForEach(dates, id: \.self) { item in
                    Text(item)
                }
            }
            
            LazyVGrid(columns: column) {
                ForEach(extractDate()) { item in
                    cardView(value: item)
                        .background(
                            Capsule()
                                .fill(.pink)
                                .padding(.horizontal, 8)
                                .opacity(isSameDay(date1: item.date, date2: currentDate) ? 1 : 0)
                        )
                        .onTapGesture {
                            currentDate = item.date
                        }
                }
            }
            .onChange(of: currentMonth) { newValue in
                currentDate = getCurrentMonth()
            }
            
        }
        .padding()
        VStack {
            Text("Tasks")
            
            if let task = tasks.first(where: { task in
                return isSameDay(date1: task.taskDate, date2: currentDate)
            }) {
                ForEach(task.task) { task in
                    HStack {
                        Text(task.time.addingTimeInterval(1), style : .time)
                        Text(task.title) // 타임 어라이벌에 들어가는 숫자는 초단위이다. 지금은 5분 뒤로 타임이 책정된 상태이다.
                        
                    }
                }
            }
        }
    }
}

extension CustomDatePicker {
    
    @ViewBuilder
    func cardView(value : DateValue) -> some View {
        
        VStack {
            if value.day != -1 {
                if let task = tasks.first(where: { task in
                    return isSameDay(date1: task.taskDate, date2: value.date)
                }) {
                    Text("\(value.day)")
                        .foregroundColor(isSameDay(date1: task.taskDate, date2: currentDate) ? .white : .primary)
                    Spacer()
                    Circle()
                        .fill(isSameDay(date1: task.taskDate, date2: currentDate) ? .white : .pink)
            } else {
                Text("\(value.day)")
                    .font(.title3.bold())
                    .foregroundColor(isSameDay(date1: value.date, date2: currentDate) ? .white : .primary)
                    .frame(maxWidth : .infinity)
                Spacer()
                }
            }
        }
        .frame(height : 50)
    }
    
    
    func isSameDay(date1 : Date, date2 : Date) -> Bool {
        
        let calendar = Calendar.current
        return calendar.isDate(date1, inSameDayAs: date2)
        
    }
    
    func getCurrentMonth() -> Date {
        let calendar = Calendar.current
        
        guard let currentMonth = calendar.date(byAdding: .month, value: self.currentMonth, to: Date())
        else { return Date() }
        
        return currentMonth // 다음은 현재 무슨 달인지를 알아낸다.
    }
    
    func extractDate() -> [DateValue] {
        
        let calendar = Calendar.current
        let currentMonth = getCurrentMonth()
        
        var days = currentMonth.getAllDate().compactMap { date -> DateValue in
            
            let day = calendar.component(.day, from: date)
            return DateValue(day: day, date: date)
        }
        
        let firstWeekday = calendar.component(.weekday, from: days.first?.date ?? Date())
        
        for _ in 0..<firstWeekday - 1 {
            days.insert(DateValue(day: -1, date: Date()), at: 0)
        }
        
        return days
    } // 해당 달이 가지고 있는 날짜를 모두 뽑아낸다.
    
    func extraDate() -> [String] {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY MMMM"
        
        let date = formatter.string(from: currentDate)
        return date.components(separatedBy: " ")
    }
}

extension Date {
    
    func getAllDate() -> [Date] { // 1. 캘린더에서 모든 데이트를 뽑아낸다.
        
        let calendar = Calendar.current
        
        let startDate = calendar.date(from: Calendar.current.dateComponents([.year, .month], from: self))!
        
        let range = calendar.range(of: .day, in: .month, for: startDate)!
        
        return range.compactMap { day -> Date in
            return calendar.date(byAdding: .day, value: day - 1, to: startDate)!
        }
    }
    
    
}
