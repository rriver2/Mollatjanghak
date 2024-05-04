//
//  MyScholarshipCategory.swift
//  janghakhere
//
//  Created by Gaeun Lee on 5/1/24.
//

import Foundation

enum MyScholarshipCategory {
    case supported(SupportedCategory)
    case stored(StorageCategory)
    static let supportedName: String = "지원 공고"
    static let storedName: String = "저장 공고"
}
