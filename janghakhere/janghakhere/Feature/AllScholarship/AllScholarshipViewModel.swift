//
//  AllScholarshipViewModel.swift
//  janghakhere
//
//  Created by Gaeun Lee on 4/16/24.
//

import SwiftUI

enum NetworkStatus {
    case loading
    case success
    case failed
}

@MainActor
final class AllScholarshipViewModel: ObservableObject {
    let scholarshipBoxListActor: ScholarshipBoxListActor = ScholarshipBoxListActor()
    
    @Published private(set) var scholarshipCategory: ScholarshipCategory = .custom
    @Published var scholarshipList: [ScholarshipBox] = []
    @Published var advertisementSelection: Int = 0
    @Published private var timer: Timer?
    @Published private(set) var networkStatus: NetworkStatus = .loading
    
    @Published private(set) var totalScholarshipCount: Int = 0 // 장학금 총 수
    @Published var totalPages: Int = 0 // 전체 페이지 수
    @Published private(set) var nextPageNumber: Int = 0 // 다음 페이지 num
    @Published var isGetMoreScholarshipBox = false
    @Published var filteringcategory: ScholarshipBoxListFliteringCategory = .allCases.first!
    @Published var isShowFilteringSheet = false
    @Published var name: String = ""
    
    @Published private(set) var isNewAlarm: Bool = false
    @AppStorage("userData") private var userData: Data?
    
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
        self.filteringcategory = ScholarshipBoxListFliteringCategory.allCases.first!
        self.scholarshipCategory = category
        self.scholarshipList = []
        self.nextPageNumber = 0
        self.getScholarShipList(category)
    }
    
    // sorting 마감, 최신 버튼
    func sortingButtonPressed(_ category : ScholarshipCategory, _ filteringCategory: ScholarshipBoxListFliteringCategory) {
        self.filteringcategory = filteringCategory
        self.scholarshipCategory = category
        self.nextPageNumber = 0
        self.scholarshipList = []
        self.getScholarShipList(category)
    }
    
    func scholarship() {
        
    }
    // 자동 swipe 배너를 위한 타이머 설정
    func timerinit() {
        timerRestart()
    }
    
    func bottomPartScrolled() {
        self.getScholarShipList(scholarshipCategory)
    }
}

// private 함수들
extension AllScholarshipViewModel {
    private func getScholarShipList(_ category : ScholarshipCategory) {
        self.networkStatus = .loading
        let task = Task {
            do {
                var scholarshipList: [ScholarshipBox] = []
                var totalScholarshipCount: Int = 0
                var currentPageNumber: Int = 0
                var totalPages: Int = 0
                
                switch category {
                case .all:
                    (scholarshipList, totalScholarshipCount, currentPageNumber, totalPages) = try await scholarshipBoxListActor.fetchScholarshipBoxList(filteringcategory, page: nextPageNumber)
                case .custom:
                    (scholarshipList, totalScholarshipCount, currentPageNumber, totalPages) = try await scholarshipBoxListActor.fetchCustomScholarshipBoxList(filteringcategory, page: nextPageNumber)
                }
                
                self.totalScholarshipCount = totalScholarshipCount
                self.nextPageNumber = currentPageNumber + 1
                self.scholarshipList.append(contentsOf: ScholarshipBoxManager.checkScholarshipBoxListStatus(scholarshipBoxList: scholarshipList))
                self.totalPages = totalPages
                
                if !(totalPages < nextPageNumber) {
                    self.isGetMoreScholarshipBox = false
                }
                self.networkStatus = .success
            } catch {
                print(error)
                self.isGetMoreScholarshipBox = false
                self.networkStatus = .failed
            }
        }
        tasks.append(task)
    }
    
    private func timerRestart() {
        timer?.invalidate()
        timer = nil
        self.timer = Timer.scheduledTimer(withTimeInterval: 7, repeats: false) { timer in
            if self.advertisementSelection == 2 {
                self.advertisementSelection = 0
            } else {
                self.advertisementSelection += 1
            }
        }
    }
    
    func getNewAlarmStatus() {
        let newAlarmList = NotificationManager.instance.getCurrentAlarmScholarshipList().filter({ getIsNotReaded(date: $0.DDayDate) })
        
        if newAlarmList.isEmpty {
            self.isNewAlarm = false
        } else {
            self.isNewAlarm = true
        }
    }
    
    private func getIsNotReaded(date: Date) -> Bool {
        if let lastAlertCheckedDate = UserDefaults.getValueFromDevice(key: .lastAlertCheckedDate, Date.self),
           lastAlertCheckedDate >= date {
            return false
        } else {
            return true
        }
    }
    
    private func initializeUserData() {
        if let data = userData {
            do {
                let decoder = JSONDecoder()
                let loadedUserData = try decoder.decode(UserData.self, from: data)
                
                self.name = loadedUserData.name
            } catch {
                print("Failed to decode user data: \(error)")
            }
        }
    }
}

// 기본 함수들
extension AllScholarshipViewModel {
    func viewOpened() {
        self.getScholarShipList(scholarshipCategory)
        self.timerinit()
        self.initializeUserData()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.getNewAlarmStatus()
        }
    }
    
    func cancelTasks() {
        tasks.forEach({ $0.cancel()})
        tasks = []
    }
}
