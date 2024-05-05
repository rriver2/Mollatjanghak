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
    case planned // 지원예정
    case applied // 지원완료
    case passed // 합격
    case non_passed // 불합격
    
    var IconName: ImageResource? {
        switch self {
        case .nothing:
                .floppyDisk
        case .storage:
                .floppyDisk
        case .planned:
                .fire
        case .applied:
                .check
        case .non_passed, .passed:
            nil
        }
    }
    
    var IconNameDetailViewButton: ImageResource? {
        switch self {
        case .storage, .nothing:
                .floppyDisk
        case .planned:
                .fire
        case .applied:
                .checkFat
        case .non_passed, .passed:
            nil
        }
    }
    
    var detailViewButtonColor: Color {
        switch self {
        case .nothing:
                .gray70
        case .storage:
                .subGreen
        case .planned:
                .subPink
        case .applied:
                .subPurple
        case .non_passed, .passed:
                .white
        }
    }
    
    var detailViewButtonTextColor: Color {
        switch self {
        case .nothing:
                .mainGray
        case .planned, .storage, .applied, .non_passed, .passed:
                .white
        }
    }
    
    
    var IconNameButton: ImageResource? {
        switch self {
        case .storage:
                .saveScholarship
        case .planned:
                .prepareScholarship
        case .applied:
                .doneScholarship
        case .nothing, .non_passed, .passed:
            nil
        }
    }
    
    var title: String {
        switch self {
        case .nothing:
            "저장"
        case .storage:
            "공고저장"
        case .planned:
            "지원예정"
        case .applied:
            "지원완료"
        case .non_passed:
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
        case .planned:
            Color.subPink
        case .applied:
            Color.subPurple
        case .non_passed:
            Color.ectRed.opacity(0.08)
        case .passed:
            Color.subGreen.opacity(0.08)
        }
    }
    
    var buttonFontColor: Color {
        switch self {
        case .nothing:
            Color.gray700
        case .storage, .planned, .applied:
            Color.white
        case .non_passed:
            Color.ectRed
        case .passed:
            Color.subGreen
        }
    }
    
    var fontSize: UIFont {
        switch self {
        case .nothing, .storage, .planned, .applied:
                .semi_title_sm
        case .non_passed, .passed:
                .semi_title_md
        }
    }
    
    var horizontalPadding: CGFloat {
        switch self {
        case .nothing, .storage, .planned, .applied:
            12
        case .non_passed, .passed:
            20
        }
    }
}
