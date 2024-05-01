//
//  OnboardingExtraViewModel.swift
//  janghakhere
//
//  Created by Taehwan Kim on 5/1/24.
//

import SwiftUI

@MainActor
final class OnboardingExtraViewModel: ObservableObject {
    let managerActor: OnboardingExtraActor = OnboardingExtraActor()
    @Published var currentPage: Int = 0 
    @Published var previousGrade: Double = 0.0
    @Published var entireGrade: Double = 0.0
    @Published var incomeDecile: IncomeDecile = .notSelected
    
    @Published var maximumGrade: MaxGradeStatus = .fourDotFive
    @Published var isShowIncomeSheet = false
    @Published var isShowGradeSheet = false
    
    @Published var militaryStatus: MilitaryStatus = .notSelected
    @Published var siblingStatus: SiblingStatus = .notSelected
    @Published var degreesStatus: DegreesStatus = .notSelected
    @Published var isShowBirthdaySheet = false
    @Published var isShowSemesterSheet = false
    
    private var tasks: [Task<Void, Never>] = []
    
    @Published private(set) var defaultDatas: [String] = []
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

// MARK: - 기본 함수들
extension OnboardingExtraViewModel {
    func createView() {
        self.useTemplatePrivateFunction()
    }
    
    func cancelTasks() {
        tasks.forEach({ $0.cancel()})
        tasks = []
    }
}
