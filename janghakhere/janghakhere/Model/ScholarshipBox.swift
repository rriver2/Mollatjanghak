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
    let DDay: String
    let prize: String
    var publicAnnouncementStatus: PublicAnnouncementStatusCategory
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

extension ScholarshipBox {
    static var mockCustomData: ScholarshipBox {
        ScholarshipBox(id: UUID().uuidString, sponsor: "청양사랑인재육성장학회", title: "(맞춤)인문100년장학금", DDay: "4", prize: "300만원+", publicAnnouncementStatus: .nothing)
    }
    static var mockAllData: ScholarshipBox {
        ScholarshipBox(id: UUID().uuidString, sponsor: "(재)한국장학재단", title: "(전체)인문100년장학금", DDay: "3", prize: "200만원+", publicAnnouncementStatus: .nothing)
    }
    
    static func mockDataList(_ category : ScholarshipCategory) -> [ScholarshipBox] {
        switch category {
        case .custom:
            return [ScholarshipBox(id: "1", sponsor: "청양사랑인재육성장학회", title: "(전체)인문100년장학금", DDay: "3", prize: "200만원+", publicAnnouncementStatus: .nothing),
                    ScholarshipBox(id: "2", sponsor: "청양사랑인재육성장학회", title: "(전체)인문100년장학금", DDay: "3", prize: "200만원+", publicAnnouncementStatus: .nothing),
                    ScholarshipBox(id: "3", sponsor: "청양사랑인재육성장학회", title: "(전체)인문100년장학금", DDay: "3", prize: "200만원+", publicAnnouncementStatus: .nothing),
                    ScholarshipBox(id: "4", sponsor: "청양사랑인재육성장학회", title: "(전체)인문100년장학금", DDay: "3", prize: "200만원+", publicAnnouncementStatus: .nothing),
                    ScholarshipBox(id: "5", sponsor: "청양사랑인재육성장학회", title: "(전체)인문100년장학금", DDay: "3", prize: "200만원+", publicAnnouncementStatus: .nothing),
                    ScholarshipBox(id: "6", sponsor: "청양사랑인재육성장학회", title: "(전체)인문100년장학금", DDay: "3", prize: "200만원+", publicAnnouncementStatus: .nothing),
                    ScholarshipBox(id: "7", sponsor: "청양사랑인재육성장학회", title: "(전체)인문100년장학금", DDay: "3", prize: "200만원+", publicAnnouncementStatus: .nothing)]
        case .all:
            return [ScholarshipBox(id: "20", sponsor: "(재)한국장학재단", title: "(전체)인문100년장학금", DDay: "3", prize: "200만원+", publicAnnouncementStatus: .nothing),
                    ScholarshipBox(id: "21", sponsor: "(재)한국장학재단", title: "(전체)인문100년장학금", DDay: "3", prize: "200만원+", publicAnnouncementStatus: .nothing),
                    ScholarshipBox(id: "22", sponsor: "(재)한국장학재단", title: "(전체)인문100년장학금", DDay: "3", prize: "200만원+", publicAnnouncementStatus: .nothing),
                    ScholarshipBox(id: "23", sponsor: "(재)한국장학재단", title: "(전체)인문100년장학금", DDay: "3", prize: "200만원+", publicAnnouncementStatus: .nothing),
                    ScholarshipBox(id: "24", sponsor: "(재)한국장학재단", title: "(전체)인문100년장학금", DDay: "3", prize: "200만원+", publicAnnouncementStatus: .nothing)]
        }
    }
}
