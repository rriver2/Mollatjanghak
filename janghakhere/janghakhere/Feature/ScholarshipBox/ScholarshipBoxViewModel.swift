//
//  ScholarshipBoxViewModel.swift
//  janghakhere
//
//  Created by Gaeun Lee on 5/6/24.
//

import SwiftUI

@MainActor
final class ScholarshipBoxViewModel: ObservableObject {
    let sholarshipStatusActor: ScholarshipStatusActor = ScholarshipStatusActor()
    
    /// 맞춤, 전체 공고에 있는 저장 버튼 클릭시
    func mainStorageButtonPressed(id: Int) {
        postScholarshipStatus(id: id, status: PublicAnnouncementStatusCategory.saved.rawValue)
    }
    
    /// 시트에서  공고 status 변경 버튼을 클릭 시
    func sheetStorageButtonPressed(id: Int, status: String) {
        postScholarshipStatus(id: id, status: status)
    }
}

// private 함수들
extension ScholarshipBoxViewModel {
    private func postScholarshipStatus(id: Int, status: String) {
        Task {
            do {
                let successStatus = try await sholarshipStatusActor.postScholarshipStatus(id: id, status: status)
                
            } catch {
                print(error)
            }
        }
    }
}