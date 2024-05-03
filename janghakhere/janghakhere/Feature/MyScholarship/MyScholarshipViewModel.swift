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
    
    @Published var TotalScholarShipList: [ScholarshipBox] = []
    
    // selectedCategory 지정 될 시 selectedScholarShipList 수정
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
    }
    
    // sorting 최신,
    func sortingButtonPressed() {
        
    }
    
    private func changeDetailSupportedCategory(_ category : SupportedCategory) {
        selectedCategoryName = MyScholarshipCategory.supportedName
        selectedCategoryDetailName = category.name
        selectedCategory = .supported(category)
        print("selectedCategoryDetailNam1e", selectedCategoryDetailName)
    }
    
    private func changeDetailStorageCategory(_ category : StorageCategory) {
        selectedCategoryName = MyScholarshipCategory.storedName
        selectedCategoryDetailName = category.name
        selectedCategory = .stored(category)
        print("selectedCategoryDetailNam2e", selectedCategoryDetailName)
    }
}

// private 함수들
extension MyScholarshipViewModel {
    private func getScholarShipList(_ category : MyScholarshipCategory) {
        selectedScholarShipList = ScholarshipBox.mockDataList(.all)
    }
}

// 기본 함수들
extension MyScholarshipViewModel {
    func viewOpened() {
        self.getScholarShipList(MyScholarshipCategory.stored(.all))
    }
    
    func cancelTasks() {
        tasks.forEach({ $0.cancel()})
        tasks = []
    }
}
