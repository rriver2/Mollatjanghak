//
//  PublicAnnouncementStatusCategory.swift
//  janghakhere
//
//  Created by Gaeun Lee on 4/16/24.
//

import SwiftUI

enum PublicAnnouncementStatusCategory: String, CaseIterable, Codable {
    case Nothing
    case Storage
    case ToBeSupported
    case SupportCompleted
    
    var IconName: ImageResource {
        switch self {
        case .Nothing:
                .floppyDisk
        case .Storage:
                .floppyDisk
        case .ToBeSupported:
                .fire
        case .SupportCompleted:
                .check
        }
    }
    
    var title: String {
        switch self {
        case .Nothing:
            "저장"
        case .Storage:
            "공고 저장"
        case .ToBeSupported:
            "지원 예정"
        case .SupportCompleted:
            "지원 완료"
        }
    }
    
    var buttonColor: Color {
        switch self {
        case .Nothing:
            Color.gray70
        case .Storage:
            Color.subGreen
        case .ToBeSupported:
            Color.subPink
        case .SupportCompleted:
            Color.subPurple
        }
    }
    
    var buttonFontColor: Color {
        switch self {
        case .Nothing:
            Color.gray700
        case .Storage, .ToBeSupported, .SupportCompleted:
            Color.white
        }
    }
}
