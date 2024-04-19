//
//  AllScholarshipViewModel.swift
//  janghakhere
//
//  Created by Gaeun Lee on 4/16/24.
//

import SwiftUI

@MainActor
final class AllScholarshipViewModel: ObservableObject {
    let managerActor: AllScholarshipActor = AllScholarshipActor()
    
    @Published private(set) var scholarshipCategory: ScholarshipCategory = .custom
    @Published private(set) var scholarshipList: [ScholarshipBox] = []
    private var tasks: [Task<Void, Never>] = []
    
    /// header의 맞춤, 전체 버튼 클릭
    func scholarshipCategoryButtonPressed(_ category : ScholarshipCategory) {
        self.scholarshipCategory = category
        self.getScholarShipList(category)
    }
    
    // sorting 최신,
    func sortingButtonPressed() {
        
    }
    
    func scholarship() {
        
    }
}

// private 함수들
extension AllScholarshipViewModel {
    private func getScholarShipList(_ category : ScholarshipCategory) {
        let task = Task {
            do {
                scholarshipList = try await managerActor.fetchScholarshipList(category)
            } catch {
                print(error)
            }
        }
        tasks.append(task)
    }
}

// 기본 함수들
extension AllScholarshipViewModel {
    func viewOpened() {
        self.getScholarShipList(.custom)
    }
    
    func cancelTasks() {
        tasks.forEach({ $0.cancel()})
        tasks = []
    }
}