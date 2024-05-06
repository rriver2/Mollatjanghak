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
    case applied
    case passed
    case non_passed
    
    var id: String {
        self.rawValue
    }
    
    var name: String {
        switch self {
        case .applied:
            PublicAnnouncementStatusCategory.applied.title
        case .passed:
            PublicAnnouncementStatusCategory.passed.title
        case .non_passed:
            PublicAnnouncementStatusCategory.non_passed.title
        }
    }
}
