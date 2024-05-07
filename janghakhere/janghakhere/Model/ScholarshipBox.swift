//
//  ScholarshipBox.swift
//  janghakhere
//
//  Created by Gaeun Lee on 4/16/24.
//

import Foundation

struct ScholarshipBox: Identifiable, Hashable {
    let id: String
    let sponsor: String
    let title: String
    let DDay: String?
    let prize: String
    var publicAnnouncementStatus: PublicAnnouncementStatusCategory
    
    init(id: String, sponsor: String, title: String, DDay: String?, prize: String, statusString: String) {
        self.id = id
        self.sponsor = sponsor
        self.title = title
        self.DDay = DDay
        self.prize = prize
        self.publicAnnouncementStatus = PublicAnnouncementStatusCategory.allCases.first { $0.rawValue == statusString} ?? .nothing
    }
    
    init(id: String, sponsor: String, title: String, DDay: String?, prize: String, publicAnnouncementStatus: PublicAnnouncementStatusCategory) {
        self.id = id
        self.sponsor = sponsor
        self.title = title
        self.DDay = DDay
        self.prize = prize
        self.publicAnnouncementStatus = publicAnnouncementStatus
    }
}

extension ScholarshipBox: CustomStringConvertible {
    var description: String {
        "id: \(id) 장학금 후원자: \(sponsor) 제목: \(title) 디데이: D-\(DDay) 상금: \(prize) 상태: \(publicAnnouncementStatus.rawValue)"
    }
}

extension ScholarshipBox: Equatable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id &&
        lhs.sponsor == rhs.sponsor &&
        lhs.title == rhs.title &&
        lhs.DDay == rhs.DDay &&
        lhs.prize == rhs.prize &&
        lhs.publicAnnouncementStatus == rhs.publicAnnouncementStatus
    }
}
