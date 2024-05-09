//
//  SuccessFailViewModel.swift
//  janghakhere
//
//  Created by Gaeun Lee on 5/3/24.
//

import SwiftUI

@MainActor
final class SuccessFailViewModel: ObservableObject {
    
    private var tasks: [Task<Void, Never>] = []
    
    func susseccButtonPressed(scholarship: ScholarshipBox) {
        self.postScholarshipStatus(id: Int(scholarship.id) ?? 0, status: PublicAnnouncementStatusCategory.passed.rawValue)
    }
    
    func failButtonPressed(scholarship: ScholarshipBox) {
        self.postScholarshipStatus(id: Int(scholarship.id) ?? 0, status: PublicAnnouncementStatusCategory.non_passed.rawValue)
    }
}

// private 함수들
extension SuccessFailViewModel {
    private func postScholarshipStatus(id: Int, status: String) {
        
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
