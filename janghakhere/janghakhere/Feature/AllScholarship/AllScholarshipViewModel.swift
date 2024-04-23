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
    @Published var advertisementSelection: Int = 0
    @Published private var timer: Timer?
    
    var advertisementSelectionWidth: CGFloat {
        if advertisementSelection == 0 {
           return 113/3
        } else if advertisementSelection == 1 {
            return 113/3*2
        } else {
            return 113
        }
    }
    
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
    // 자동 swipe 배너를 위한 타이머 설정
    func timerinit() {
        timerRestart()
    }
}

// private 함수들
extension AllScholarshipViewModel {
    private func getScholarShipList(_ category : ScholarshipCategory) {
        let task = Task {
            do {
                let scholarshipList = try await managerActor.fetchScholarshipList(category)
                self.scholarshipList = ScholarshipBoxManager.checkScholarshipBoxListStatus(scholarshipBoxList: scholarshipList)
            } catch {
                print(error)
            }
        }
        tasks.append(task)
    }
    
    private func timerRestart() {
        timer?.invalidate()
        timer = nil
        self.timer = Timer.scheduledTimer(withTimeInterval: 4, repeats: true) { timer in
            if self.advertisementSelection == 2 {
                self.advertisementSelection = 0
            } else {
                self.advertisementSelection += 1
            }
        }
    }
}

// 기본 함수들
extension AllScholarshipViewModel {
    func viewOpened() {
        self.getScholarShipList(.custom)
        self.timerinit()
    }
    
    func cancelTasks() {
        tasks.forEach({ $0.cancel()})
        tasks = []
    }
}
