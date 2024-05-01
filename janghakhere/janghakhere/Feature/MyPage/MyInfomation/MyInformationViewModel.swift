//
//  MyInformationViewModel.swift
//  janghakhere
//
//  Created by Taehwan Kim on 5/1/24.
//

import SwiftUI

@MainActor
final class MyInformationViewModel: ObservableObject {
    let managerActor: MyInformationActor = MyInformationActor()
    @Published var name: String = "윤영서"
    @Published var sex: Sex = .notSelected
    @Published var militaryStatus: MilitaryStatus = .notSelected
    @Published var incomeStatus: IncomeDecile = .notSelected
    @Published var sibilingStatus: SiblingStatus = .notSelected
    @Published var schoolName: String = "서울여자대학교"
    @Published var semesterYear: SemesterYear = .sophomore
    @Published var majorField: MajorField = .engineering
    @Published var totalScore: String = "4.5"
    
    private var tasks: [Task<Void, Never>] = []
    
    @Published private(set) var defaultDatas: [String] = []
    
}

// MARK: - private 함수들
extension MyInformationViewModel {
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
extension MyInformationViewModel {
    func createView() {
        self.useTemplatePrivateFunction()
    }
    
    func cancelTasks() {
        tasks.forEach({ $0.cancel()})
        tasks = []
    }
}
