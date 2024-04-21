//
//  SearchScholarshipActor.swift
//  janghakhere
//
//  Created by Gaeun Lee on 4/17/24.
//

import Foundation

actor SearchScholarshipActor {
    func fetchScholarshipBoxList() async throws -> [ScholarshipBox] {
        //FIXME: API 데이터로 변경
        return [ScholarshipBox(id: "10", sponsor: "(재)한국장학재단", title: "(전체)인문100년장학금", DDay: 3, prize: "200만원+", publicAnnouncementStatus: .Nothing),
                ScholarshipBox(id: "11", sponsor: "(재)한국장학재단", title: "(전체)인문100년장학금", DDay: 3, prize: "200만원+", publicAnnouncementStatus: .Nothing),
                ScholarshipBox(id: "12", sponsor: "(재)한국장학재단", title: "(전체)인문100년장학금", DDay: 3, prize: "200만원+", publicAnnouncementStatus: .Nothing),
                ScholarshipBox(id: "13", sponsor: "(재)한국장학재단", title: "(전체)인문100년장학금", DDay: 3, prize: "200만원+", publicAnnouncementStatus: .Nothing),
                ScholarshipBox(id: "14", sponsor: "(재)한국장학재단", title: "(전체)인문100년장학금", DDay: 3, prize: "200만원+", publicAnnouncementStatus: .Nothing)]
    }
}
