//
// SupportedCategory
//  janghakhere
//
//  Created by Gaeun Lee on 5/1/24.
//

import SwiftUI

protocol MyscholarshipCategory {
    var id: String { get }
    var name: String { get }
    var buttonTextColor: Color { get }
    var buttonBackgroundColor: Color { get }
    var allCasesId: [String] { get }
    var allCasesName: [String] { get }
}

enum SupportedCategory: String, CaseIterable, MyscholarshipCategory {
    case completedApplication
    case passed
    case failed
    
    var id: String {
        self.rawValue
    }
    
    var name: String {
        switch self {
        case .completedApplication:
            "지원완료"
        case .passed:
            "합격"
        case .failed:
            "불합격"
        }
    }
    
    var buttonTextColor: Color {
        switch self {
        case .completedApplication:
                Color.black
        case .passed:
            Color.subGreen
        case .failed:
            Color(hex: "FF6464") ?? .black
        }
    }
    
    var buttonBackgroundColor: Color {
        switch self {
        case .completedApplication:
                Color.black
        case .passed:
            Color(hex: "37C084")?.opacity(0.08) ?? .black
        case .failed:
            Color(hex: "FF6464")?.opacity(0.08) ?? .black
        }
    }
    
//    func getCategory(_ id: String) -> SupportedCategory {
//        return SupportedCategory.allCases.first { category in
//            category.id == self.id
//        }!
//    }
    
    var allCasesId: [String] {
        return SupportedCategory.allCases.map { $0.rawValue }
    }
    
    var allCasesName: [String] {
        return SupportedCategory.allCases.map { $0.name }
    }
}
