//
//  MyScholarshipViewModel.swift
//  janghakhere
//
//  Created by Gaeun Lee on 4/28/24.
//

import SwiftUI

@MainActor
final class MyScholarshipViewModel: ObservableObject {
    let scholarshipBoxListActor: ScholarshipBoxListActor = ScholarshipBoxListActor()
    
    @Published private(set) var scholarshipCategory: MyScholarshipCategory = .storaged
    // 임의의 수 넣어줘야 함
    @Published var detailCategoryDictionaryData: [categoryData] = categoryData.mockData1
    @Published var selectedDetailCategoryName: String = "전체"
    
    struct categoryData: Hashable {
        let name: String
        let scholarshipBoxList: [ScholarshipBox]
        
        static let mockData1 = [
            categoryData(name: "전체", scholarshipBoxList: [ScholarshipBox.mockAllData, ScholarshipBox.mockAllData, ScholarshipBox.mockAllData, ScholarshipBox.mockAllData, ScholarshipBox.mockAllData, ScholarshipBox.mockAllData]),
            categoryData(name: "진행중", scholarshipBoxList: [ScholarshipBox.mockCustomData, ScholarshipBox.mockCustomData, ScholarshipBox.mockCustomData, ScholarshipBox.mockCustomData, ScholarshipBox.mockCustomData, ScholarshipBox.mockCustomData]),
            categoryData(name: "마감", scholarshipBoxList: [ScholarshipBox.mockAllData, ScholarshipBox.mockAllData, ScholarshipBox.mockAllData, ScholarshipBox.mockAllData, ScholarshipBox.mockAllData, ScholarshipBox.mockAllData])
        ]
        
        static let mockData2 = [
            categoryData(name: "지원완료", scholarshipBoxList: [ScholarshipBox.mockAllData, ScholarshipBox.mockAllData, ScholarshipBox.mockAllData, ScholarshipBox.mockAllData, ScholarshipBox.mockAllData, ScholarshipBox.mockAllData]),
            categoryData(name: "합격", scholarshipBoxList: [ScholarshipBox.mockCustomData, ScholarshipBox.mockCustomData, ScholarshipBox.mockCustomData, ScholarshipBox.mockCustomData, ScholarshipBox.mockCustomData, ScholarshipBox.mockCustomData]),
            categoryData(name: "불합격", scholarshipBoxList: [ScholarshipBox.mockAllData, ScholarshipBox.mockAllData, ScholarshipBox.mockAllData, ScholarshipBox.mockAllData, ScholarshipBox.mockAllData, ScholarshipBox.mockAllData])
        ]
    }
    
    private var tasks: [Task<Void, Never>] = []
    
    /// header의 저장, 지원 공고 버튼 클릭
    func scholarshipCategoryButtonPressed(_ category : MyScholarshipCategory) {
        // detailCategoryDictionaryData 값 변경 시키기
        switch category {
        case .storaged:
            self.detailCategoryDictionaryData = categoryData.mockData1
        case .supported:
            self.detailCategoryDictionaryData = categoryData.mockData2
        }
        self.scholarshipCategory = category
        self.selectedDetailCategoryName = detailCategoryDictionaryData.first?.name ?? "지원완료"
    }
    
    // sorting 최신,
    func sortingButtonPressed() {
        
    }
}

// private 함수들
extension MyScholarshipViewModel {
    private func getScholarShipList(_ category : MyScholarshipCategory) {
        
        
    }
}

// 기본 함수들
extension MyScholarshipViewModel {
    func viewOpened() {
        self.getScholarShipList(scholarshipCategory)
    }
    
    func cancelTasks() {
        tasks.forEach({ $0.cancel()})
        tasks = []
    }
}
