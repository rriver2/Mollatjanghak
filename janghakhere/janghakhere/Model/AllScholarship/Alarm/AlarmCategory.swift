//
//  AlarmCategory.swift
//  janghakhere
//
//  Created by Gaeun Lee on 4/23/24.
//

import SwiftUI

enum AlarmCategory: Hashable {
    case new(count: Int)
    case storage(scholorshipName: String, DDay: Int)
    
    var IconName: ImageResource {
        switch self {
        case .new:
            .new
        case .storage:
            .saved
        }
    }
    
    var title: String {
        switch self {
        case .new:
            "새 공고"
        case .storage:
            "저장 공고"
        }
    }
    
    var content: String {
        switch self {
        case .new(let count):
            //FIXME: 이름 불러와야 함
            let name = "영서"
            return "\(name)님이 지원 가능한 장학금 공고가\n\(count)개 올라왔어요!"
        case .storage(let scholorshipName, let DDay):
            return "\(scholorshipName)D-\(DDay)\n마감기한이 얼마 남지 않았어요!"
        }
    }
}
