//
//  ScholarshipBoxListFliteringCategory.swift
//  janghakhere
//
//  Created by Gaeun Lee on 5/7/24.
//

import Foundation

enum ScholarshipBoxListFliteringCategory: CaseIterable {
    case recent
    case inquiry
    case deadline
    
    var title: String {
        switch self {
        case .recent:
            return "최신순"
        case .inquiry:
            return "조회순"
        case .deadline:
            return "마감순"
        }
    }
}
