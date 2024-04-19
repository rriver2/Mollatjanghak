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
        return Array(repeating: ScholarshipBox.mockAllData, count: 10)
    }
}
