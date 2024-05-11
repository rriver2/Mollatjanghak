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
    var emptyTitle: String { get }
    var emptySubTitle: String { get }
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
    
    var emptyTitle: String {
        switch self {
        case .applied:
            "아직 지원한 장학금이 없어요"
        case .passed:
            "아직 합격한 장학금이 없어요"
        case .non_passed:
            "불합격한 장학금이 없어요"
        }
    }
    
    var emptySubTitle: String {
        switch self {
        case .applied:
            "여깄장학과 함께 지원하고\n합격해보세요"
        case .passed:
            "여깄장학과 함께 지원하고\n합격해보세요"
        case .non_passed:
            ""
        }
    }
}
