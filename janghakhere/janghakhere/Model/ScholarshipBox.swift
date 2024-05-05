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

extension ScholarshipBox {
    static var mockCustomData: ScholarshipBox {
        ScholarshipBox(id: UUID().uuidString, sponsor: "청양사랑인재육성장학회", title: "(맞춤)인문100년장학금", DDay: "4", prize: "300만원+", publicAnnouncementStatus: .nothing)
    }
    static var mockAllData: ScholarshipBox {
        ScholarshipBox(id: UUID().uuidString, sponsor: "(재)한국장학재단", title: "(전체)인문100년장학금", DDay: "3", prize: "200만원+", publicAnnouncementStatus: .nothing)
    }
    
    static var mockAllDataList: [ScholarshipBox] {
        [ScholarshipBox(id: "1", sponsor: "1청양사랑인재육성장학회", title: "(전체)인문100년장학금", DDay: "+3", prize: "200만원+", publicAnnouncementStatus: .nothing),
         ScholarshipBox(id: "2", sponsor: "2청양사랑인재육성장학회", title: "(전체)인문100년장학금", DDay: "+3", prize: "200만원+", publicAnnouncementStatus: .failed),
         ScholarshipBox(id: "3", sponsor: "3청양사랑인재육성장학회", title: "(전체)인문100년장학금", DDay: "-3", prize: "200만원+", publicAnnouncementStatus: .nothing),
         ScholarshipBox(id: "4", sponsor: "4청양사랑인재육성장학회", title: "(전체)인문100년장학금", DDay: "-3", prize: "200만원+", publicAnnouncementStatus: .passed),
         ScholarshipBox(id: "5", sponsor: "5청양사랑인재육성장학회", title: "(전체)인문100년장학금", DDay: "0", prize: "200만원+", publicAnnouncementStatus: .storage),
         ScholarshipBox(id: "6", sponsor: "6청양사랑인재육성장학회", title: "(전체)인문100년장학금", DDay: "-123", prize: "200만원+", publicAnnouncementStatus: .nothing),
         ScholarshipBox(id: "7", sponsor: "7청양사랑인재육성장학회", title: "(전체)인문100년장학금", DDay: "-223", prize: "200만원+", publicAnnouncementStatus: .supportCompleted),
         ScholarshipBox(id: "8", sponsor: "8청양사랑인재육성장학회", title: "(전체)인문100년장학금", DDay: "0", prize: "200만원+", publicAnnouncementStatus: .toBeSupported),
         ScholarshipBox(id: "9", sponsor: "9청양사랑인재육성장학회", title: "(전체)인문100년장학금", DDay: "+12", prize: "200만원+", publicAnnouncementStatus: .nothing),
         ScholarshipBox(id: "10", sponsor: "10청양사랑인재육성장학회", title: "(전체)인문100년장학금", DDay: "-113", prize: "200만원+", publicAnnouncementStatus: .passed),
         ScholarshipBox(id: "11", sponsor: "11청양사랑인재육성장학회", title: "(전체)인문100년장학금", DDay: "+3", prize: "200만원+", publicAnnouncementStatus: .passed),
         ScholarshipBox(id: "12", sponsor: "12청양사랑인재육성장학회", title: "(전체)인문100년장학금", DDay: "0", prize: "200만원+", publicAnnouncementStatus: .supportCompleted),
         ScholarshipBox(id: "13", sponsor: "13청양사랑인재육성장학회", title: "(전체)인문100년장학금", DDay: "0", prize: "200만원+", publicAnnouncementStatus: .supportCompleted),
         ScholarshipBox(id: "14", sponsor: "14청양사랑인재육성장학회", title: "(전체)인문100년장학금", DDay: "+22", prize: "200만원+", publicAnnouncementStatus: .storage)]
    }
    
    static func mockDataList(_ category : ScholarshipCategory) -> [ScholarshipBox] {
        switch category {
        case .custom:
            return [ScholarshipBox(id: "100", sponsor: "청양사랑인재육성장학회", title: "(전체)인문100년장학금", DDay: "3", prize: "200만원+", publicAnnouncementStatus: .nothing),
                    ScholarshipBox(id: "200", sponsor: "청양사랑인재육성장학회", title: "(전체)인문100년장학금", DDay: "3", prize: "200만원+", publicAnnouncementStatus: .nothing),
                    ScholarshipBox(id: "300", sponsor: "청양사랑인재육성장학회", title: "(전체)인문100년장학금", DDay: "3", prize: "200만원+", publicAnnouncementStatus: .nothing),
                    ScholarshipBox(id: "400", sponsor: "청양사랑인재육성장학회", title: "(전체)인문100년장학금", DDay: "3", prize: "200만원+", publicAnnouncementStatus: .nothing),
                    ScholarshipBox(id: "500", sponsor: "청양사랑인재육성장학회", title: "(전체)인문100년장학금", DDay: "3", prize: "200만원+", publicAnnouncementStatus: .nothing),
                    ScholarshipBox(id: "600", sponsor: "청양사랑인재육성장학회", title: "(전체)인문100년장학금", DDay: "3", prize: "200만원+", publicAnnouncementStatus: .nothing),
                    ScholarshipBox(id: "700", sponsor: "청양사랑인재육성장학회", title: "(전체)인문100년장학금", DDay: "3", prize: "200만원+", publicAnnouncementStatus: .nothing)]
        case .all:
            return self.mockAllDataList
        }
    }
    
    static func mockDataList(_ category : PublicAnnouncementStatusCategory) -> [ScholarshipBox] {
        switch category {
        case .nothing:
            [ScholarshipBox(id: "900", sponsor: "(재)한국장학재단", title: "(전체)인문100년장학금", DDay: "3", prize: "200만원+", publicAnnouncementStatus: .nothing),
                    ScholarshipBox(id: "1000", sponsor: "(재)한국장학재단", title: "(전체)인문100년장학금", DDay: "3", prize: "200만원+", publicAnnouncementStatus: .nothing),
                    ScholarshipBox(id: "1001", sponsor: "(재)한국장학재단", title: "(전체)인문100년장학금", DDay: "3", prize: "200만원+", publicAnnouncementStatus: .nothing),
                    ScholarshipBox(id: "1002", sponsor: "(재)한국장학재단", title: "(전체)인문100년장학금", DDay: "3", prize: "200만원+", publicAnnouncementStatus: .nothing),
                    ScholarshipBox(id: "1003", sponsor: "(재)한국장학재단", title: "(전체)인문100년장학금", DDay: "3", prize: "200만원+", publicAnnouncementStatus: .nothing)]
        case .storage:
            [ScholarshipBox(id: "10001", sponsor: "(재)한국장학재단", title: "(전체)인문100년장학금", DDay: "3", prize: "200만원+", publicAnnouncementStatus: .storage),
                    ScholarshipBox(id: "10002", sponsor: "(재)한국장학재단", title: "(전체)인문100년장학금", DDay: "3", prize: "200만원+", publicAnnouncementStatus: .storage),
                    ScholarshipBox(id: "10003", sponsor: "(재)한국장학재단", title: "(전체)인문100년장학금", DDay: "3", prize: "200만원+", publicAnnouncementStatus: .storage),
                    ScholarshipBox(id: "10004", sponsor: "(재)한국장학재단", title: "(전체)인문100년장학금", DDay: "3", prize: "200만원+", publicAnnouncementStatus: .storage),
                    ScholarshipBox(id: "10005", sponsor: "(재)한국장학재단", title: "(전체)인문100년장학금", DDay: "3", prize: "200만원+", publicAnnouncementStatus: .storage)]
        case .toBeSupported:
            [ScholarshipBox(id: "10006", sponsor: "(재)한국장학재단", title: "(전체)인문100년장학금", DDay: "3", prize: "200만원+", publicAnnouncementStatus: .toBeSupported),
                    ScholarshipBox(id: "10007", sponsor: "(재)한국장학재단", title: "(전체)인문100년장학금", DDay: "3", prize: "200만원+", publicAnnouncementStatus: .toBeSupported),
                    ScholarshipBox(id: "10008", sponsor: "(재)한국장학재단", title: "(전체)인문100년장학금", DDay: "3", prize: "200만원+", publicAnnouncementStatus: .toBeSupported),
                    ScholarshipBox(id: "10009", sponsor: "(재)한국장학재단", title: "(전체)인문100년장학금", DDay: "3", prize: "200만원+", publicAnnouncementStatus: .toBeSupported),
                    ScholarshipBox(id: "20000", sponsor: "(재)한국장학재단", title: "(전체)인문100년장학금", DDay: "3", prize: "200만원+", publicAnnouncementStatus: .toBeSupported)]
        case .supportCompleted:
            [ScholarshipBox(id: "20001", sponsor: "(재)한국장학재단", title: "(전체)인문100년장학금", DDay: "3", prize: "200만원+", publicAnnouncementStatus: .supportCompleted),
                    ScholarshipBox(id: "20002", sponsor: "(재)한국장학재단", title: "(전체)인문100년장학금", DDay: "3", prize: "200만원+", publicAnnouncementStatus: .supportCompleted),
                    ScholarshipBox(id: "20003", sponsor: "(재)한국장학재단", title: "(전체)인문100년장학금", DDay: "3", prize: "200만원+", publicAnnouncementStatus: .supportCompleted),
                    ScholarshipBox(id: "20004", sponsor: "(재)한국장학재단", title: "(전체)인문100년장학금", DDay: "3", prize: "200만원+", publicAnnouncementStatus: .supportCompleted),
                    ScholarshipBox(id: "20005", sponsor: "(재)한국장학재단", title: "(전체)인문100년장학금", DDay: "3", prize: "200만원+", publicAnnouncementStatus: .supportCompleted)]
        case .passed:
            [ScholarshipBox(id: "20000006", sponsor: "(재)한국장학재단", title: "(전체)인문100년장학금", DDay: "3", prize: "200만원+", publicAnnouncementStatus: .passed),
                    ScholarshipBox(id: "20000007", sponsor: "(재)한국장학재단", title: "(전체)인문100년장학금", DDay: "3", prize: "200만원+", publicAnnouncementStatus: .passed),
                    ScholarshipBox(id: "20000008", sponsor: "(재)한국장학재단", title: "(전체)인문100년장학금", DDay: "3", prize: "200만원+", publicAnnouncementStatus: .passed),
                    ScholarshipBox(id: "20000009", sponsor: "(재)한국장학재단", title: "(전체)인문100년장학금", DDay: "3", prize: "200만원+", publicAnnouncementStatus: .passed),
                    ScholarshipBox(id: "30000000", sponsor: "(재)한국장학재단", title: "(전체)인문100년장학금", DDay: "3", prize: "200만원+", publicAnnouncementStatus: .passed)]
        case .failed:
            [ScholarshipBox(id: "1000000000", sponsor: "(재)한국장학재단", title: "(전체)인문100년장학금", DDay: "3", prize: "200만원+", publicAnnouncementStatus: .failed),
                    ScholarshipBox(id: "2000000000", sponsor: "(재)한국장학재단", title: "(전체)인문100년장학금", DDay: "3", prize: "200만원+", publicAnnouncementStatus: .failed),
                    ScholarshipBox(id: "3000000000", sponsor: "(재)한국장학재단", title: "(전체)인문100년장학금", DDay: "3", prize: "200만원+", publicAnnouncementStatus: .failed),
                    ScholarshipBox(id: "4000000000", sponsor: "(재)한국장학재단", title: "(전체)인문100년장학금", DDay: "3", prize: "200만원+", publicAnnouncementStatus: .failed),
                    ScholarshipBox(id: "5000000000", sponsor: "(재)한국장학재단", title: "(전체)인문100년장학금", DDay: "3", prize: "200만원+", publicAnnouncementStatus: .failed)]
        }
    }
}
