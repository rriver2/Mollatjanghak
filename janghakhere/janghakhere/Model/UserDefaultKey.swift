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
    
    // 사용자 이름
    case userName
    
    // 알림 공고
    case alertInfoList // 저장공고
    case alertFirstDate // 새공고
    case lastAlertCheckedDate // 알림 읽어본 날
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
