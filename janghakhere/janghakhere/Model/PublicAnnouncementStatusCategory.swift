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
    
    var IconNameDetailViewButton: ImageResource? {
        switch self {
        case .storage, .nothing:
                .floppyDisk
        case .toBeSupported:
                .fire
        case .supportCompleted:
                .checkFat
        case .failed, .passed:
            nil
        }
    }
    
    var detailViewButtonColor: Color {
        switch self {
        case .nothing:
                .gray70
        case .storage:
                .subGreen
        case .toBeSupported:
                .subPink
        case .supportCompleted:
                .subPurple
        case .failed, .passed:
                .white
        }
    }
    
    var detailViewButtonTextColor: Color {
        switch self {
        case .nothing:
                .mainGray
        case .toBeSupported, .storage, .supportCompleted, .failed, .passed:
                .white
        }
    }
    
    
    var IconNameButton: ImageResource? {
        switch self {
        case .storage:
                .saveScholarship
        case .toBeSupported:
                .prepareScholarship
        case .supportCompleted:
                .doneScholarship
        case .nothing, .failed, .passed:
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
            "불합격"
        case .passed:
            "합격"
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
            Color.subRed.opacity(0.08)
        case .passed:
            Color.subGreen.opacity(0.08)
        }
    }
    
    var buttonFontColor: Color {
        switch self {
        case .nothing:
            Color.gray700
        case .storage, .toBeSupported, .supportCompleted:
            Color.white
        case .failed:
            Color.subRed
        case .passed:
            Color.subGreen
        }
    }
    
    var fontSize: UIFont {
        switch self {
        case .nothing, .storage, .toBeSupported, .supportCompleted:
                .semi_title_sm
        case .failed, .passed:
                .semi_title_md
        }
    }
    
    var horizontalPadding: CGFloat {
        switch self {
        case .nothing, .storage, .toBeSupported, .supportCompleted:
            12
        case .failed, .passed:
            20
        }
    }
}
