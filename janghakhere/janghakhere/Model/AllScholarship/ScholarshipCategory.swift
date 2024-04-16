//
//  ScholarshipCategory.swift
//  janghakhere
//
//  Created by Gaeun Lee on 4/16/24.
//

import Foundation

enum ScholarshipCategory: CaseIterable {
    case custom
    case all
    
    var name: String {
        switch self {
        case .custom:
            "맞춤"
        case .all:
            "전체"
        }
    }
}
