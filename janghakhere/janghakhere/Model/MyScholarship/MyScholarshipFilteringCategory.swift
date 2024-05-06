//
//  MyScholarshipFilteringCategory.swift
//  janghakhere
//
//  Created by Gaeun Lee on 5/7/24.
//

import Foundation

enum MyScholarshipFilteringCategory: CaseIterable {
    case recent
    case deadline
    
    var title: String {
        switch self {
        case .recent:
            return "최근 저장한 순"
        case .deadline:
            return "마감순"
        }
    }
}
