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
    
    @Published var isStatusSheet = false
    @Published var changedStatus: PublicAnnouncementStatusCategory? = nil
    @Published var isShowSavedError: Bool = true
    
    /// 맞춤, 전체 공고에 있는 저장 버튼 클릭시
    func mainStorageButtonPressed(id: String, afterAddingStatus: @escaping () -> Void) {
        postScholarshipStatus(id: id, status: PublicAnnouncementStatusCategory.saved, afterAddingStatus: afterAddingStatus)
    }
    
    /// 시트에서  공고 status 변경 버튼을 클릭 시
    func sheetStorageButtonPressed(id: String, status: PublicAnnouncementStatusCategory, afterAddingStatus: @escaping () -> Void) {
        if status == .nothing {
            deleteScholarshipStatus(id: id, status: status, afterAddingStatus: afterAddingStatus)
        } else {
            postScholarshipStatus(id: id, status: status, afterAddingStatus: afterAddingStatus)
        }
    }
}

// private 함수들
extension ScholarshipBoxViewModel {
    private func postScholarshipStatus(id: String, status: PublicAnnouncementStatusCategory, afterAddingStatus: @escaping () -> Void) {
        Task {
            do {
                try await sholarshipStatusActor.postScholarshipStatus(id: id, status: status.rawValue)
                try await sholarshipStatusActor.postScholarshipStatus(id: id, status: "stored")
                
                changedStatus = status
                afterAddingStatus()
            } catch {
                isShowSavedError = true
                print(error)
            }
        }
    }
    
    private func deleteScholarshipStatus(id: String, status: PublicAnnouncementStatusCategory, afterAddingStatus: @escaping () -> Void) {
        Task {
            do {
                try await sholarshipStatusActor.postScholarshipStatus(id: id, status: status.rawValue)
                try await sholarshipStatusActor.deleteScholarshipStatus(id: id)
                
                changedStatus = status
                afterAddingStatus()
            } catch {
                isShowSavedError = true
                print(error)
            }
        }
    }

}
