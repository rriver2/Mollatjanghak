//
//  Gender.swift
//  janghakhere
//
//  Created by Taehwan Kim on 4/21/24.
//

import Foundation

enum Sex {
    case notSelected
    case female
    case male
    func getText() -> String {
        switch self {
        case .female:
            return "여"
        case .male:
            return "남"
        case .notSelected:
            return "선택 안 됨"
        }
    }
}
