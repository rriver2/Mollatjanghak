//
//  PublicAnnouncementStatusCategory.swift
//  janghakhere
//
//  Created by Gaeun Lee on 4/16/24.
//

import SwiftUI

enum PublicAnnouncementStatusCategory: String, CaseIterable, Codable {
    case nothing // 기본값
    case storage // 저장완료
    case toBeSupported // 지원예정
    case supportCompleted //지원완료
    case passed // 합격
    case failed // 불합격
    
    var IconName: ImageResource? {
        switch self {
        case .nothing:
                .floppyDisk
        case .storage:
                .floppyDisk
        case .toBeSupported:
                .fire
        case .supportCompleted:
                .check
        case .failed, .passed:
            nil
        }
    }
    
    var title: String {
        switch self {
        case .nothing:
            "저장"
        case .storage:
            "공고저장"
        case .toBeSupported:
            "지원예정"
        case .supportCompleted:
            "지원완료"
        case .failed:
            "합격"
        case .passed:
            "불합격"
        }
    }
    
    var buttonColor: Color {
        switch self {
        case .nothing:
            Color.gray70
        case .storage:
            Color.subGreen
        case .toBeSupported:
            Color.subPink
        case .supportCompleted:
            Color.subPurple
        case .failed:
            Color(hex: "37C084")?.opacity(0.08) ?? .white
        case .passed:
            Color(hex: "FF6464")?.opacity(0.08) ?? .white
        }
    }
    
    var buttonFontColor: Color {
        switch self {
        case .nothing:
            Color.gray700
        case .storage, .toBeSupported, .supportCompleted:
            Color.white
        case .failed:
            Color(hex: "FF6464") ?? .red
        case .passed:
            Color.subGreen
        }
    }
}
