//
//  SuccessFailViewModel.swift
//  janghakhere
//
//  Created by Gaeun Lee on 5/3/24.
//

import SwiftUI

@MainActor
final class SuccessFailViewModel: ObservableObject {
    let sholarshipStatusActor: ScholarshipStatusActor = ScholarshipStatusActor()
    
    @Published var isShowSavedError: Bool = false
    
    private var tasks: [Task<Void, Never>] = []
    
    func susseccButtonPressed(scholarship: ScholarshipBox) {
        self.postScholarshipStatus(id: scholarship.id, status: PublicAnnouncementStatusCategory.passed)
    }
    
    func failButtonPressed(scholarship: ScholarshipBox) {
        self.postScholarshipStatus(id: scholarship.id, status: PublicAnnouncementStatusCategory.non_passed)
    }
}

// private 함수들
extension SuccessFailViewModel {
    private func postScholarshipStatus(id: String, status: PublicAnnouncementStatusCategory) {
        Task {
            do {
                let isStatusSuccess = try await sholarshipStatusActor.postScholarshipStatus(id: id, status: status.rawValue)
                
                if !isStatusSuccess {
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

// 기본 함수들
extension SuccessFailViewModel {
    func viewOpened() {
    }
    
    func cancelTasks() {
        tasks.forEach({ $0.cancel()})
        tasks = []
    }
}
