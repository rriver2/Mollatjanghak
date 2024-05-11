//
//  Onboarding.swift
//  janghakhere
//
//  Created by Gaeun Lee on 4/21/24.
//

import SwiftUI

struct UserDataMinimum: Encodable, Hashable {
    let id: String
    let name: String
    let sex: String
    let birth: String
    let schoolName: String
    let enrolled: String // EnrolledStatus, 입학예정, 재학 등
    let semester: String // 이 정보를 석사, 학기를 통합해서 보여줘야함
    let majorCategory: String
    let previousGrade: Double?
    let entireGrade: Double?
    let maximumGrade: String?
    let incomeDecile: String?
}

struct UserDataMaximum: Encodable, Hashable {
    let id: String
    let name: String
    let sex: String
    let birth: String
    let schoolName: String
    let enrolled: String // EnrolledStatus, 입학예정, 재학 등
    let semester: String // 이 정보를 석사, 학기를 통합해서 보여줘야함
    let majorCategory: String
    let previousGrade: Double?
    let entireGrade: Double? // 최대가 아니라 전체 평균을 의미
    let incomeDecile: String? // "1", "2" ...
    let militaryService: String? // 병역 필, 병역 미필, 해당 없음
    let siblingExists: Bool? //
    let detailedConditions: [String]
}
