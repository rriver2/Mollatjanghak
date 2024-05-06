//
//  AlarmScholarship.swift
//  janghakhere
//
//  Created by Gaeun Lee on 5/3/24.
//

import SwiftUI

struct AlarmScholarship: Hashable, Codable {
    let id: String
    let content: String
    let DDayDate: Date
    let category: Category
    var interverDate: String {
            return dataInterver(date: DDayDate)
        }
    
    enum Category: Codable {
        case new
        case saved
        
        var title: String {
            switch self {
            case .new:
                "새 공고"
            case .saved:
                "저장 공고"
            }
        }
        
        var imageName: ImageResource {
            switch self {
            case .new:
                    .new
            case .saved:
                    .saved
            }
        }
    }
    
    init(id: String, content: String, DDayDate: Date, category: Category) {
        self.id = id
        self.content = content
        self.DDayDate = DDayDate
        self.category = category
    }
}

// private 함수
extension AlarmScholarship {
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
