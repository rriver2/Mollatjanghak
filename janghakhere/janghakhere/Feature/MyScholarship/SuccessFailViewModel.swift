//
//  SuccessFailViewModel.swift
//  janghakhere
//
//  Created by Gaeun Lee on 5/3/24.
//

import SwiftUI

@MainActor
final class SuccessFailViewModel: ObservableObject {
    let successFailActor: ScholarshipStatusActor = ScholarshipStatusActor()
    
    private var tasks: [Task<Void, Never>] = []
    
    func susseccButtonPressed(scholarship: ScholarshipBox) {
        self.postScholarshipStatus(id: Int(scholarship.id) ?? 0, status: PublicAnnouncementStatusCategory.passed.rawValue)
    }
    
    func failButtonPressed(scholarship: ScholarshipBox) {
        self.postScholarshipStatus(id: Int(scholarship.id) ?? 0, status: PublicAnnouncementStatusCategory.failed.rawValue)
    }
}

// private 함수들
extension SuccessFailViewModel {
    private func postScholarshipStatus(id: Int, status: String) {
        let task = Task {
            do {
                _ = try await successFailActor.postScholarshipStatus(id: id, status: status)
            } catch {
                print(error)
            }
        }
        tasks.append(task)
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
