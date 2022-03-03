//
//  SwiftUIView.swift
//  CalendarSelf
//
//  Created by Kyungyun Lee on 03/03/2022.
//

import SwiftUI

struct Task : Identifiable {
    var id = UUID()
    var title : String
    var time : Date = Date()
}

struct TaskModel : Identifiable {
    var id = UUID()
    var task : [Task]
    var taskDate : Date
}

func getTaskDate(offset : Int) -> Date {
    
    let calendar = Calendar.current
    let date = calendar.date(byAdding: .day, value: offset, to: Date())
    return date ?? Date() // 여기서 오프셋은 오늘 날짜 기준으로 +1 을 나타낸다.
    
}

var tasks : [TaskModel] = [

    TaskModel(task: [Task(title: "경윤이 약속"), Task(title: "수현이 약속")], taskDate: getTaskDate(offset: 1)),TaskModel(task: [Task(title: "경윤이 약속"), Task(title: "수현이 약속")], taskDate: getTaskDate(offset: 4)),TaskModel(task: [Task(title: "경윤이 약속"), Task(title: "수현이 약속")], taskDate: getTaskDate(offset: 5)), TaskModel(task: [Task(title: "경윤이 약속"), Task(title: "수현이 약속")], taskDate: getTaskDate(offset: -5))
]
