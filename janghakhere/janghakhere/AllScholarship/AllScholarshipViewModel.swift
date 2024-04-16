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
    @Published private(set) var detailScholarship: DetailScholarship? = nil
    private var tasks: [Task<Void, Never>] = []
    
    /// header의 맞춤, 전체 버튼 클릭
    func scholarshipCategoryButtonPressed(_ category : ScholarshipCategory) {
        self.scholarshipCategory = category
        self.getScholarShip(category)
    }
    
    /// 장학금 박스 버튼 클릭
    func scholarshipButtonPressed(id: String) {
        self.getDetailScholarship(id: id)
    }
    
    // sorting 최신,
    func sortingButtonPressed() {
        
    }
    
    func scholarship() {
        
    }
}

// private 함수들
extension AllScholarshipViewModel {
    private func getScholarShip(_ category : ScholarshipCategory) {
        let task = Task {
            do {
                scholarshipList = try await managerActor.fetchScholarshipList(category)
            } catch {
                print(error)
            }
        }
        tasks.append(task)
    }
    
    private func getDetailScholarship(id: String) {
        let task = Task {
            do {
                detailScholarship = try await managerActor.fetchDetailScholarship(id: id)
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
        self.getScholarShip(.custom)
    }
    
    func cancelTasks() {
        tasks.forEach({ $0.cancel()})
        tasks = []
    }
}
