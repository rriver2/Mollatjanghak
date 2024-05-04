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
    case supportCompleted
    case passed
    case failed
    
    var id: String {
        self.rawValue
    }
    
    var name: String {
        switch self {
        case .supportCompleted:
            PublicAnnouncementStatusCategory.supportCompleted.title
        case .passed:
            PublicAnnouncementStatusCategory.passed.title
        case .failed:
            PublicAnnouncementStatusCategory.failed.title
        }
    }
}
