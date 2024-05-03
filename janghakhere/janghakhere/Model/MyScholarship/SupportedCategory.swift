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
}
