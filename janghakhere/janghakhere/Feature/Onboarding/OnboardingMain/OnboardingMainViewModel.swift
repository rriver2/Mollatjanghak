//
//  OnboardingMainViewModel.swift
//  janghakhere
//
//  Created by Taehwan Kim on 4/21/24.
//

import SwiftUI

struct UserMemeber {
    let id: String
    let name: String
    let sex: String
    let birth: String
    let schoolName: String
    let enrolled: String // EnrolledStatus, 입학예정, 재학 등
    let degree: String // 현재 없음. degreesStatus, 학사, 석사 등
    let SchoolYear: String // 현재 없음. 1학년, 2학년 등
    let semester: String // 수정 필요. 1학기, 2학기만 되게
    let majorCategory: String
    
    let lastSemesterGrade: Double?
    let totalGrade: Double?
    let incomeRange: String?
    let militaryService: String?
    let siblingExists: Bool?
    let detailedConditions: [String]
}

@MainActor
final class OnboardingMainViewModel: ObservableObject {
    let managerActor: OnboardingMainActor = OnboardingMainActor()
    
    private var tasks: [Task<Void, Never>] = []
    
    @Published private(set) var defaultDatas: [String] = []
    
    @Published var currentPage: Int = 0
    @Published var name: String = ""
    @Published var sex: Sex = .notSelected
    @Published var date: Date = .now
    @Published var schoolName: String = ""
    
    @Published var semesterYear: SemesterYear = .notSelected
    @Published var semesterStatus: SemesterStatus = .notSelected
    @Published var enrollmentStatus: EnrollmentStatus = .notSelected
    @Published var majorField: MajorField = .notSelected
    @Published var incomeDecile: IncomeDecile = .notSelected
    @Published var maximumGrade: MaxGradeStatus = .fourDotFive
    @Published var militaryStatus: MilitaryStatus = .notSelected
    @Published var siblingStatus: SiblingStatus = .notSelected
    @Published var degreesStatus: DegreesStatus = .notSelected
    
    @Published var previousGrade: Double = 0.0
    @Published var entireGrade: Double = 0.0
    
    @Published var isShowGradeSheet = false
    @Published var isShowBirthdaySheet = false
    @Published var isShowSemesterSheet = false
    @Published var isShowIncomeSheet = false
}

// MARK: - private 함수들
extension OnboardingMainViewModel {
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
extension OnboardingMainViewModel {
    func createView() {
        self.useTemplatePrivateFunction()
    }
    
    func cancelTasks() {
        tasks.forEach({ $0.cancel()})
        tasks = []
    }
    
    func isEmptyDate(_ date: Date) -> Bool {
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.year, .month, .day], from: date)
        let today = calendar.dateComponents([.year, .month, .day], from: Date())
        return dateComponents.year == today.year && dateComponents.month == today.month && dateComponents.day == today.day
    }
    
//    func sendUserInformation() {
//        let task = Task {
//            do {
//                self.detailContent = try await managerActor.fetchDetailScholarship(id)
//                self.networkStatus = .success
//            } catch {
//                print(error)
//                self.networkStatus = .failed
//            }
//        }
//        tasks.append(task)
//    }
}
