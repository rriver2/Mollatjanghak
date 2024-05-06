//
//  Gender.swift
//  janghakhere
//
//  Created by Taehwan Kim on 4/21/24.
//

import Foundation
//String, CaseIterable, CustomStringConvertible
enum Sex: String, CaseIterable, CustomStringConvertible, Codable {
    case notSelected = "선택 안 됨"
    case female = "여"
    case male = "남"
    
    var description: String {
        self.rawValue
    }
}
