//
//  SemesterYear.swift
//  janghakhere
//
//  Created by Taehwan Kim on 4/21/24.
//

import Foundation

enum SemesterYear: CaseIterable {
    case notSelected
    case freshman
    case sophomore
    case junior
    case senior
    case fifthYear
    func getYearText() -> String {
        switch self {
        case .freshman:
            return "1학년"
        case .sophomore:
            return "2학년"
        case .junior:
            return "3학년"
        case .senior:
            return "4학년"
        case .fifthYear:
            return "5학년 이상(의약학, 건축학)"
        case .notSelected:
            return "1학년"
            // 구현상의 편리를 위해서 1학년으로 만듬. 나중에 필요가 있으면 "선택 안 됨"으로 수정하시죠!
        }
    }
}
