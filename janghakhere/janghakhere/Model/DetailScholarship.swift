//
//  DetailScholarship.swift
//  janghakhere
//
//  Created by Gaeun Lee on 4/16/24.
//

import Foundation

struct DetailScholarship: Identifiable, Hashable {
    let id: String
    let sponsor: String
    let title: String
    let DDay: Int
    let prize: String
    let url: URL
    let publicAnnouncementStatus: PublicAnnouncementStatusCategory
    
    //FIXME: 세부 내용 더 추가해야함
}

extension DetailScholarship: CustomStringConvertible {
    var description: String {
        "장학금 후원자: \(sponsor) 제목: \(title) , URL: \(url.description) 디데이: D-\(DDay) 상금: \(prize) 상태: \(publicAnnouncementStatus.rawValue)"
    }
}

extension DetailScholarship: Equatable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id &&
        lhs.sponsor == rhs.sponsor &&
        lhs.title == rhs.title &&
        lhs.url == rhs.url &&
        lhs.DDay == rhs.DDay &&
        lhs.prize == rhs.prize &&
        lhs.publicAnnouncementStatus == rhs.publicAnnouncementStatus
    }
}

extension DetailScholarship {
    static var mockData: DetailScholarship {
        DetailScholarship(id: UUID().uuidString, sponsor: "청양사랑인재육성장학회", title: "(맞춤)인문100년장학금", DDay: 4, prize: "300만원+", url: URL(string: "https://developer.apple.com/documentation/swiftui/sharepreview")!, publicAnnouncementStatus: .Nothing)
    }
}

