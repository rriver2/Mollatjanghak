//
//  MyScholarshipViewModel.swift
//  janghakhere
//
//  Created by Gaeun Lee on 4/28/24.
//

import SwiftUI

enum MyScholarshipCategory {
    case supported(SupportedCategory)
    case stored(StorageCategory)
    static let supportedName: String = "지원 공고"
    static let storedName: String = "저장 공고"
}

@MainActor
final class MyScholarshipViewModel: ObservableObject {
    let scholarshipBoxListActor: ScholarshipBoxListActor = ScholarshipBoxListActor()
    
    @Published private(set) var selectedCategory: MyScholarshipCategory = .stored(.all)
    @Published private(set) var selectedCategoryName: String = MyScholarshipCategory.storedName
    @Published private(set) var selectedCategoryDetailName: String = StorageCategory.allCases.first?.name ?? "에베베"
    
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
    func sortingButtonPressed() {
           
    }
    
    func getStoreChangedtScholarShip() -> MyScholarshipCategory? {
        for newScholarship in selectedScholarShipList {
            if let index = totalScholarShipList.firstIndex(where: { $0.id == newScholarship.id }),
               totalScholarShipList[index].publicAnnouncementStatus != newScholarship.publicAnnouncementStatus {
                switch newScholarship.publicAnnouncementStatus {
                case .failed:
                    return .supported(.failed)
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
            case .supportCompleted:
                selectedScholarShipList = totalScholarShipList.filter({ $0.publicAnnouncementStatus == .supportCompleted })
            case .failed:
                selectedScholarShipList = totalScholarShipList.filter({ $0.publicAnnouncementStatus == .failed })
            case .passed:
                selectedScholarShipList = totalScholarShipList.filter({ $0.publicAnnouncementStatus == .passed })
            }
        case .stored(let storedCategory):
            let filterScholarShipList = totalScholarShipList.filter({ $0.publicAnnouncementStatus != .failed && $0.publicAnnouncementStatus != .passed && $0.publicAnnouncementStatus != .nothing})
            switch storedCategory {
            case .all:
                selectedScholarShipList = filterScholarShipList
            case .inProgress:
                selectedScholarShipList = filterScholarShipList.filter { $0.DDay.first != "+" }
            case .closing:
                selectedScholarShipList = filterScholarShipList.filter { $0.DDay.first == "+" }
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
    
    private func getAllScholarShipList() {
        totalScholarShipList = ScholarshipBox.mockAllDataList
    }
}

// 기본 함수들
extension MyScholarshipViewModel {
    func viewOpened() {
        self.getAllScholarShipList()
        self.getScholarShipList(MyScholarshipCategory.stored(.all))
    }
    
    func cancelTasks() {
        tasks.forEach({ $0.cancel()})
        tasks = []
    }
}
