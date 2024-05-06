//
//  OnboardingExtraViewModel.swift
//  janghakhere
//
//  Created by Taehwan Kim on 5/1/24.
//

import SwiftUI
import Combine

@MainActor
final class OnboardingExtraViewModel: ObservableObject {
    let managerActor: OnboardingExtraActor = OnboardingExtraActor()
    
    @Published var currentPage: Int = 0
    @Published var previousGrade: Double = 0.0
    @Published var entireGrade: Double = 0.0
    @Published var incomeDecile: IncomeDecile = .notSelected
    @Published var maximumGrade: MaxGradeStatus = .fourDotFive
    @Published var militaryStatus: MilitaryStatus = .notSelected
    @Published var siblingStatus: SiblingStatus = .notSelected
    @Published var degreesStatus: DegreesStatus = .notSelected
    @Published var isShowIncomeSheet = false
    @Published var isShowGradeSheet = false
    @Published var isShowBirthdaySheet = false
    @Published var isShowSemesterSheet = false
    
    private var tasks: [Task<Void, Never>] = []
    
    @Published private(set) var defaultDatas: [String] = []
    
    @Published var chips: [OnboardingChipModel] = [
        OnboardingChipModel(isSelected: true, title: "해당없음"),
        OnboardingChipModel(isSelected: false, title: "국가유공자 및 배우자"),
        OnboardingChipModel(isSelected: false, title: "한부모가정"),
        OnboardingChipModel(isSelected: false, title: "장애인/장애우"),
        OnboardingChipModel(isSelected: false, title: "다문화가정"),
        OnboardingChipModel(isSelected: false, title: "학생가장(보육원, 조손가정포함)"),
        OnboardingChipModel(isSelected: false, title: "고속도로 사고 관련자"),
        OnboardingChipModel(isSelected: false, title: "북한이탈주민자녀"),
        OnboardingChipModel(isSelected: false, title: "고용보험 피해자"),
        OnboardingChipModel(isSelected: false, title: "농립수산업인 본인/자녀"),
        OnboardingChipModel(isSelected: false, title: "농어촌 거주"),
        OnboardingChipModel(isSelected: false, title: "현역군인 및 군무원의 자녀"),
        OnboardingChipModel(isSelected: false, title: "장기복무군인 본인/자녀"),
        OnboardingChipModel(isSelected: false, title: "공무원 본인/자녀"),
        OnboardingChipModel(isSelected: false, title: "중소기업 근로자의 자녀"),
        OnboardingChipModel(isSelected: false, title: "산재근로자 본인/배우자/자녀"),
        OnboardingChipModel(isSelected: false, title: "사립학교 교직원 본인/자녀")
    ]
}

// MARK: - private 함수들
extension OnboardingExtraViewModel {
    private func useTemplatePrivateFunction() {
        let task = Task {
            do {
                defaultDatas = try await managerActor.getData()
            } catch {
                print(error)
            }
        }
        tasks.append(task)
    }
}

// MARK: - 함수들
extension OnboardingExtraViewModel {
    func updateChipSelection() {
        let otherChips = chips.filter { $0.title != "해당없음" }
        let areOtherChipsSelected = otherChips.contains { $0.isSelected }
        
        if areOtherChipsSelected {
            if let noneChipIndex = chips.firstIndex(where: { $0.title == "해당없음" }) {
                chips[noneChipIndex].isSelected = false
            }
            return
        }
        
        if let noneChipIndex = chips.firstIndex(where: { $0.title == "해당없음" }) {
            chips[noneChipIndex].isSelected = true
        }
    }
    
    func createView() {
        self.useTemplatePrivateFunction()
    }
    
    func cancelTasks() {
        tasks.forEach({ $0.cancel()})
        tasks = []
    }
}
