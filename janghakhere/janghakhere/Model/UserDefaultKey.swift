//
//  UserDefaultKey.swift
//  janghakhere
//
//  Created by Gaeun Lee on 4/19/24.
//

import Foundation

enum UserDefaultKey: String, CaseIterable, Equatable {
    // 장학금 검색 Chips
    case searchedScholarshipTextList
    
    // 저장완료, 지원예정, 지원완료한 데이터
    case publicAnnouncementStatusList
}

struct publicAnnouncementStatus: Codable {
    let id: String
    var status: PublicAnnouncementStatusCategory
}

extension publicAnnouncementStatus: Equatable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id &&
        lhs.status == rhs.status
    }
}
