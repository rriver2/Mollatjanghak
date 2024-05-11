//
//  StorageCategory.swift
//  janghakhere
//
//  Created by Gaeun Lee on 5/1/24.
//

import SwiftUI

enum StorageCategory: String, CaseIterable, MyscholarshipCategory {
    
    case all
    case inProgress
    case closing

    var id: String {
        self.rawValue
    }
    
    var name: String {
        switch self {
        case .all:
            "전체"
        case .inProgress:
            "진행중"
        case .closing:
            "마감"
        }
    }
    
    var emptyTitle: String {
        switch self {
        case .all:
            "아직 저장한 공고가 없어요_전체"
        case .inProgress:
            "아직 저장한 공고가 없어요_진행중"
        case .closing:
            "아직 저장한 공고가 없어요_마감"
        }
    }
    
    var emptySubTitle: String {
        switch self {
        case .all:
            "여깄장학과 함께 저장하고\n지원해보세요"
        case .inProgress:
            "여깄장학과 함께 저장하고\n지원해보세요"
        case .closing:
            "여깄장학과 함께 저장하고\n지원해보세요"
        }
    }

}
