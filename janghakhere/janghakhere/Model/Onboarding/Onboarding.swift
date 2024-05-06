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
}
