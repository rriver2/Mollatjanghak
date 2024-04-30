//
//  MyScholarshipCategory.swift
//  janghakhere
//
//  Created by Gaeun Lee on 5/1/24.
//

import Foundation

enum MyScholarshipCategory: CaseIterable {
    case storaged
    case supported
    
    var name: String {
        switch self {
        case .storaged:
            "저장 공고"
        case .supported:
            "지원 공고"
        }
    }
}
