//
//  SearchScholarshipViewModel.swift
//  janghakhere
//
//  Created by Gaeun Lee on 4/17/24.
//

import SwiftUI

@MainActor
final class SearchScholarshipViewModel: ObservableObject {
    let managerActor: SearchScholarshipActor = SearchScholarshipActor()
    
    private var tasks: [Task<Void, Never>] = []
    
    @Published var searchContent: String = ""
    @Published private (set)var searchScholarshipStatus: SearchScholarshipStatus = .notSearchedYet
    @Published private (set)var scholarshipList: [ScholarshipBox] = []
    
    func searchbarXButtonPressed() {
        self.searchContent = ""
        self.scholarshipList = []
        self.searchScholarshipStatus = .notSearchedYet
    }
    
    func searchButtonPressed() {
        self.searchScholarshipStatus = .loading
        getScholarshipList()
    }
}

// MARK: - private 함수들
extension SearchScholarshipViewModel {
    private func getScholarshipList() {
        let task = Task {
            do {
                let scholarshipList = try await managerActor.fetchScholarshipBoxList()
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
                    self.scholarshipList = scholarshipList
                    if scholarshipList.isEmpty {
                        self.searchScholarshipStatus = .searchedNoData
                    } else {
                        self.searchScholarshipStatus = .searchedWithData
                    }
                }
            } catch {
                print(error)
                self.searchScholarshipStatus = .failed
            }
        }
        tasks.append(task)
    }
}

// MARK: - 기본 함수들
extension SearchScholarshipViewModel {
    func cancelTasks() {
        tasks.forEach({ $0.cancel()})
        tasks = []
    }
}
