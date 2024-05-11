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
    func mainStorageButtonPressed(id: String) {
        postScholarshipStatus(id: id, status: PublicAnnouncementStatusCategory.saved)
    }
    
    /// 시트에서  공고 status 변경 버튼을 클릭 시
    func sheetStorageButtonPressed(id: String, status: PublicAnnouncementStatusCategory) {
        if status == .nothing {
            deleteScholarshipStatus(id: id, status: status)
        } else {
            postScholarshipStatus(id: id, status: status)
        }
    }
}

// private 함수들
extension ScholarshipBoxViewModel {
    private func postScholarshipStatus(id: String, status: PublicAnnouncementStatusCategory) {
        Task {
            do {
                async let isStatusSuccess = self.sholarshipStatusActor.postScholarshipStatus(id: id, status: status.rawValue)
                async let isStoredSuccess = self.sholarshipStatusActor.postScholarshipStatus(id: id, status: "stored")
                
                let (success1, success2) = await (try isStatusSuccess, try isStoredSuccess)
                
                if success1 && success2 {
                    changedStatus = status
                } else {
                    // FIXME: Toast 저장 안 됐음 알리기
                    isShowSavedError = true
                }
            } catch {
                isShowSavedError = true
                print(error)
            }
        }
    }
    
    private func deleteScholarshipStatus(id: String, status: PublicAnnouncementStatusCategory) {
        Task {
            do {
                async let isStatusSuccess = self.sholarshipStatusActor.postScholarshipStatus(id: id, status: status.rawValue)
                async let isStoredSuccess = self.sholarshipStatusActor.deleteScholarshipStatus(id: id)
                
                let (success1, success2) = await (try isStatusSuccess, try isStoredSuccess)
                
                if success1 && success2 {
                    changedStatus = status
                } else {
                    // FIXME: Toast 저장 안 됐음 알리기
                    isShowSavedError = true
                }
            } catch {
                isShowSavedError = true
                print(error)
            }
        }
    }

}
