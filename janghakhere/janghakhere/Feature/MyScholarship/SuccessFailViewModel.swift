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
    
    func susseccButtonPressed(scholarship: ScholarshipBox, success: @escaping () -> Void) {
        self.postScholarshipStatus(id: scholarship.id, status: PublicAnnouncementStatusCategory.passed, success: success)
    }
    
    func failButtonPressed(scholarship: ScholarshipBox, success: @escaping () -> Void) {
        self.postScholarshipStatus(id: scholarship.id, status: PublicAnnouncementStatusCategory.non_passed, success: success)
    }
}

// private 함수들
extension SuccessFailViewModel {
    private func postScholarshipStatus(id: String, status: PublicAnnouncementStatusCategory, success: @escaping () -> Void) {
        Task {
            do {
                try await sholarshipStatusActor.postScholarshipStatus(id: id, status: status.rawValue)
                success()
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
