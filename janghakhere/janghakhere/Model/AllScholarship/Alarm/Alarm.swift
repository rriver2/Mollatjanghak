//
//  Alarm.swift
//  janghakhere
//
//  Created by Gaeun Lee on 4/23/24.
//

import SwiftUI

struct Alarm: Hashable {
    private let alarmCategory: AlarmCategory
    let IconName: ImageResource
    let title: String
    let content: String
    private let alarmDate: Date
    let isReaded: Bool
    var interverDate: String {
        return dataInterver(date: alarmDate)
    }
    
    init(alarmCategory: AlarmCategory, alarmDate: Date, isReaded: Bool = false) {
        self.alarmCategory = alarmCategory
        self.IconName = alarmCategory.IconName
        self.title = alarmCategory.title
        self.content = alarmCategory.content
        // alarmDate 계산하는 함수 구현
        self.alarmDate = alarmDate
        // isReaded 수정하기
        self.isReaded = isReaded
    }
}

// private 함수
extension Alarm {
    private func dataInterver(date: Date) -> String {
        let startDate = date
        let currentDate = Date()
        
        let calendar = Calendar.current
        
        // 시간 차이 계산
        let components = calendar.dateComponents([.day, .hour, .minute, .second], from: startDate, to: currentDate)
        
        if let day = components.day, day >= 1 {
            return "\(day)일 전"
        } else if let hour = components.hour, hour != 0 {
            return "\(hour)시간 전"
        } else if let minute = components.minute, minute != 0 {
            return "\(minute)분 전"
        }  else if let second = components.second, second != 0 {
            return "\(second)초 전"
        } else {
            return ""
        }
    }
}

extension Alarm {
    static let mockList: [Alarm] = [
        Alarm(alarmCategory: .new(count: 5), alarmDate: Calendar.current.date(byAdding: .second, value: -10, to: Date())!),
        Alarm(alarmCategory: .storage(scholorshipName: "[인문100년장학금]", DDay: 8), alarmDate: Calendar.current.date(byAdding: .second, value: -10, to: Date())!),
        Alarm(alarmCategory: .new(count: 9), alarmDate: Calendar.current.date(byAdding: .second, value: -10, to: Date())!),
        Alarm(alarmCategory: .new(count: 6), alarmDate: Calendar.current.date(byAdding: .minute, value: -3, to: Date())!),
        Alarm(alarmCategory: .storage(scholorshipName: "[인문100년장학금]", DDay: 2), alarmDate: Calendar.current.date(byAdding: .minute, value: -3, to: Date())!, isReaded: true),
        Alarm(alarmCategory: .new(count: 5), alarmDate: Calendar.current.date(byAdding: .hour, value: -2, to: Date())!, isReaded: true),
        Alarm(alarmCategory: .storage(scholorshipName: "[인문100년장학금]", DDay: 2), alarmDate: Calendar.current.date(byAdding: .hour, value: -3, to: Date())!),
        Alarm(alarmCategory: .new(count: 5), alarmDate: Calendar.current.date(byAdding: .hour, value: -4, to: Date())!, isReaded: true),
        Alarm(alarmCategory: .new(count: 10), alarmDate: Calendar.current.date(byAdding: .day, value: -50, to: Date())!, isReaded: true),
        Alarm(alarmCategory: .storage(scholorshipName: "[인문100년장학금]", DDay: 4), alarmDate:Calendar.current.date(byAdding: .day, value: -50, to: Date())!, isReaded: true)
    ]
}
