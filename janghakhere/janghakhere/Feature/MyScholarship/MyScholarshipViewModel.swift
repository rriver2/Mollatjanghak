//
//  MyScholarshipViewModel.swift
//  janghakhere
//
//  Created by Gaeun Lee on 4/28/24.
//

import SwiftUI

@MainActor
final class MyScholarshipViewModel: ObservableObject {
    let myScholarshipBoxListActor: MyScholarshipBoxListActor = MyScholarshipBoxListActor()
    
    @Published private(set) var selectedCategory: MyScholarshipCategory = .stored(.all)
    @Published private(set) var selectedCategoryName: String = MyScholarshipCategory.storedName
    @Published private(set) var selectedCategoryDetailName: String = StorageCategory.allCases.first?.name ?? "에베베"
    @Published private(set) var selectedDetailCategory: PublicAnnouncementStatusCategory? = nil
    
    @Published private(set) var networkStatus: NetworkStatus = .loading
    @Published var filteringCategory: MyScholarshipFilteringCategory = .allCases.first!
    @Published var isShowFilteringSheet = false
    
    @Published var totalScholarShipList: [ScholarshipBox] = []
    @Published var selectedScholarShipList: [ScholarshipBox] = []
    
    private var tasks: [Task<Void, Never>] = []
    
    /// header의 저장, 지원 공고 버튼 클릭 or header의 저장, 지원 Detail 종류 버튼 클릭
    func scholarshipCategoryButtonPressed(_ category : MyScholarshipCategory) {
        switch category {
        case .supported(let supportedCategory):
            changeDetailSupportedCategory(supportedCategory)
        case .stored(let storedCategory):
            changeDetailStorageCategory(storedCategory)
        }
        storeChangedtScholarShip(category)
    }
    
    // sorting 최신,
    func sortingButtonPressed(_ category: MyScholarshipFilteringCategory) {
        self.totalScholarShipList = []
        self.filteringCategory = category
        self.getAllScholarShipList(category)
    }
    
    func reloadButtonPressed() {
        self.getAllScholarShipList(filteringCategory)
    }
    
    //FIXME: 이게 뭐지
    // 선택된 값이 달라졌을 때
    func getStoreChangedtScholarShip() -> MyScholarshipCategory? {
        for newScholarship in selectedScholarShipList {
            if let index = totalScholarShipList.firstIndex(where: { $0.id == newScholarship.id }),
               totalScholarShipList[index].publicAnnouncementStatus != newScholarship.publicAnnouncementStatus {
                switch newScholarship.publicAnnouncementStatus {
                case .non_passed:
                    return .supported(.non_passed)
                case .passed:
                    return .supported(.passed)
                default:
                    return nil
                }
            }
        }
        return nil
    }
}

// private 함수들
extension MyScholarshipViewModel {
    private func storeChangedtScholarShip(_ category : MyScholarshipCategory) {
        for newScholarship in selectedScholarShipList {
            if let index = totalScholarShipList.firstIndex(where: { $0.id == newScholarship.id }) {
               totalScholarShipList[index].publicAnnouncementStatus = newScholarship.publicAnnouncementStatus
            }
        }
        getScholarShipList(category)
    }
    
    private func getScholarShipList(_ category : MyScholarshipCategory) {
        
        switch category {
        case .supported(let supportedCategory):
            switch supportedCategory { 
            case .applied:
                selectedScholarShipList = totalScholarShipList.filter({ $0.publicAnnouncementStatus == .applied })
            case .non_passed:
                selectedScholarShipList = totalScholarShipList.filter({ $0.publicAnnouncementStatus == .non_passed })
            case .passed:
                selectedScholarShipList = totalScholarShipList.filter({ $0.publicAnnouncementStatus == .passed })
            }
        case .stored(let storedCategory):
            let filterScholarShipList = totalScholarShipList.filter({ $0.publicAnnouncementStatus != .non_passed && $0.publicAnnouncementStatus != .passed && $0.publicAnnouncementStatus != .nothing})
            switch storedCategory {
            case .all:
                selectedScholarShipList = filterScholarShipList
            case .inProgress:
                selectedScholarShipList = filterScholarShipList.filter { $0.DDay?.first != "+" }
            case .closing:
                selectedScholarShipList = filterScholarShipList.filter { $0.DDay?.first == "+" }
            }
        }
    }

    private func changeDetailSupportedCategory(_ category : SupportedCategory) {
        selectedCategoryName = MyScholarshipCategory.supportedName
        selectedCategoryDetailName = category.name
        selectedCategory = .supported(category)
    }
    
    private func changeDetailStorageCategory(_ category : StorageCategory) {
        selectedCategoryName = MyScholarshipCategory.storedName
        selectedCategoryDetailName = category.name
        selectedCategory = .stored(category)
    }
    
    private func getAllScholarShipList(_ category: MyScholarshipFilteringCategory) {
        self.networkStatus = .loading
        let task = Task {
            do {
                let scholarshipList = try await myScholarshipBoxListActor.fetchScholarshipBoxList(category)
                self.totalScholarShipList = scholarshipList
                self.getScholarShipList(selectedCategory)
                self.networkStatus = .success
            } catch {
                self.networkStatus = .failed
                print(error)
            }
        }
        tasks.append(task)
    }
}

// 기본 함수들
extension MyScholarshipViewModel {
    func viewOpened() {
        self.getAllScholarShipList(MyScholarshipFilteringCategory.allCases.first!)
    }
    
    func cancelTasks() {
        tasks.forEach({ $0.cancel()})
        tasks = []
    }
}
