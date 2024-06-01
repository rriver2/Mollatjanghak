//
//  ScholarshipStatusViewModel.swift
//  janghakhere
//
//  Created by Gaeun Lee on 6/1/24.
//

import SwiftUI

@MainActor
final class ScholarshipStatusViewModel: ObservableObject {
    @Published private(set) var ScholarshipStatusList: [String : PublicAnnouncementStatusCategory] = [:]
}

// MARK: - private 함수들
extension ScholarshipStatusViewModel {
    
    // ScholarshipStatusList에 status가 변경된 ScholarshipBox 저장
    func addScholarship(id: String, status: PublicAnnouncementStatusCategory) {
        ScholarshipStatusList[id] = status
    }
    
    ///[ScholarshipBox]을 요소로 받아서 현재 status 값이 변경된 장학금들 [ScholarshipBox]에 반영해서 return하기
    func getFilteringScholarshipList(list: [ScholarshipBox]) -> [ScholarshipBox] {
        var returnList = list
        for index in list.indices {
            if let status = ScholarshipStatusList[list[index].id] {
                returnList[index].publicAnnouncementStatus = status
            }
        }
        return returnList
    }
}
