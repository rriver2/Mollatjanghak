//
//  StorageCategory.swift
//  janghakhere
//
//  Created by Gaeun Lee on 5/1/24.
//

import Foundation

enum StorageCategory: String, CaseIterable {
    case all
    case inProgress
    case closing

    var id: String {
        self.rawValue
    }
    
    var name: String {
        switch self {
        case .all:
            "전체"
        case .inProgress:
            "진행중"
        case .closing:
            "마감"
        }
    }
    
    func getCategory(_ id: String) -> StorageCategory {
        return StorageCategory.allCases.first { category in
            category.id == self.id
        }!
    }
    
    var allCasesId: [String] {
        return StorageCategory.allCases.map { $0.rawValue }
    }
    
    var allCasesName: [String] {
        return StorageCategory.allCases.map { $0.name }
    }
}
