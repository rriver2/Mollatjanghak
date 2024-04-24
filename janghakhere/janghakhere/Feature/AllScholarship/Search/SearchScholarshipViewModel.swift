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
    @Published private (set)var chips: [Chip] = []
    
    /// 검색 내용 지우기 X 버튼 클릭시
    func searchbarXButtonPressed() {
        self.searchContent = ""
        self.scholarshipList = []
        self.searchScholarshipStatus = .notSearchedYet
        //FIXME: API 끊기게
    }
    
    /// 돋보기 클릭시
    func searchButtonPressed() {
        self.searchScholarshipStatus = .loading
        getScholarshipList()
        AddOneOfSearchedScholarshipText(searchContent)
    }
    
    /// 검색 장학금 전체 삭제 버튼 클릭시
    func removeAllSearchedScholarshipTextHistory() {
        UserDefaults.removeSomething(key: .searchedScholarshipTextList)
    }
    
    /// Chip 버튼 클릭
    func clickedChipButton(_ chip: Chip) {
        self.searchContent = chip.title
        searchButtonPressed()
    }
    
    /// Chip의 X 버튼 클릭
    func clickedChipXButton(_ chip: Chip) {
        removeSearchedScholarshipTextList(chip.title)
    }
}

// MARK: - private 함수들
extension SearchScholarshipViewModel {
    private func getScholarshipList() {
        let task = Task {
            do {
                //FIXME: page 넣기
                let scholarshipList = try await managerActor.fetchScholarshipBoxList(page: 0, keyword: searchContent)
                // scholarshipList의 장학금 status 값 확인하기
                self.scholarshipList = ScholarshipBoxManager.checkScholarshipBoxListStatus(scholarshipBoxList: scholarshipList)
                if scholarshipList.isEmpty {
                    self.searchScholarshipStatus = .searchedNoData
                } else {
                    self.searchScholarshipStatus = .searchedWithData
                }
            } catch {
                print(error)
                self.searchScholarshipStatus = .failed
            }
        }
        tasks.append(task)
    }
    
    private func checkScholarshipStatus() {
        
    }
    
    private func AddOneOfSearchedScholarshipText(_ content: String) {
        let newChip = Chip(title: content)
        if !chips.contains(newChip) {
            chips.insert(newChip, at: 0)
        }
        
        // 4개 이상일 시 삭제
        if chips.count > 3 {
            if !chips.isEmpty {
                chips.removeLast()
            }
        }
        
        UserDefaults.saveObjectInDevice(key: .searchedScholarshipTextList, content: chips)
    }
    
    private func getSearchedScholarshipTextList() {
        self.chips = UserDefaults.getObjectFromDevice(key: .searchedScholarshipTextList, [Chip].self) ?? []
    }
    
    private func removeSearchedScholarshipTextList(_ content: String) {
        self.chips = chips.filter { $0.title != content }
        UserDefaults.saveObjectInDevice(key: .searchedScholarshipTextList, content: chips)
    }
}

// MARK: - 기본 함수들
extension SearchScholarshipViewModel {
    func viewOpened() {
        getSearchedScholarshipTextList()
    }
    
    func cancelTasks() {
        tasks.forEach({ $0.cancel()})
        tasks = []
    }
}
