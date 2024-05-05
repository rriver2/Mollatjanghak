//
//  OnboardingMainViewModel.swift
//  janghakhere
//
//  Created by Taehwan Kim on 4/21/24.
//

import SwiftUI

struct UserData {
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
    @Published var networkStatus: NetworkStatus = .loading
    private var tasks: [Task<Void, Never>] = []
    @Published var userId = HTTPUtils.getDeviceUUID()
    
    @Published private(set) var defaultDatas: [String] = []
    
    @Published var currentPage: Int = 0
    @Published var name: String = ""
    @Published var sex: Sex = .notSelected
    @Published var birthDate: Date = .now
    @Published var schoolName: String = ""
    
    @Published var semesterYear: SemesterYear = .notSelected
    @Published var semesterStatus: SemesterStatus = .notSelected
    @Published var enrollmentStatus: EnrollmentStatus = .notSelected
    @Published var majorField: MajorField = .notSelected
    @Published var degreesStatus: DegreesStatus = .notSelected
    
    @Published var isShowBirthdaySheet = false
    @Published var isShowSemesterSheet = false
//    @Published var isShowGradeSheet = false
//    @Published var isShowIncomeSheet = false
}

// MARK: - private 함수들
extension OnboardingMainViewModel {
    
    private func refineSemester(
        degree: DegreesStatus,
        semesterYear: SemesterYear,
        semester: SemesterStatus) -> String {
            var year = 0
            var semesterNum = 0
    
            switch semesterYear {
            case .notSelected:
                year = 0
            case .freshman:
                year = 1
            case .sophomore:
                year = 2
            case .junior:
                year = 3
            case .senior:
                year = 4
            case .fifthYear:
                year = 5
            }
            
            switch semester {
            case .first:
                semesterNum = 1
            case .second:
                semesterNum = 2
            case .extraSemester:
                semesterNum = 3
            case .prospectiveStudent:
                semesterNum = 0
            case .notSelected:
                semesterNum = 0
                break
            }
            
            if semester == .notSelected || semesterYear == .notSelected {
                return "선택 안 된 항목 존재"
            }
            
            if degree == .doctor {
                return "박사과정"
            }
            
            if degree == .master {
                if semesterNum == 1 {
                    return "석사신입생(1학기)"
                }
                return "석사2학기이상"
            }
            
            if semesterYear == .freshman {
                if semester == .prospectiveStudent || semester == .first {
                    return "대학신입생"
                }
            }
            
            let totalSemester = year * semesterNum
            if totalSemester >= 8 {
                return "대학8학기이상"
            }
            
            return "대학\(totalSemester)학기"
        }
}

// MARK: - 기본 함수들
extension OnboardingMainViewModel {
    func createView() {
        
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
    
    func makeUserData() -> UserDataMinimum {
        let refineSemesterInfo = refineSemester(degree: degreesStatus, semesterYear: semesterYear, semester: semesterStatus)
        let userData = UserDataMinimum(
            id: userId,
            name: name,
            sex: sex.getText(),
            birth: birthDate.DateDayFomatter(),
            schoolName: schoolName,
            enrolled: enrollmentStatus.description,
            semester: refineSemesterInfo,
            majorCategory: majorField.description
        )
        return userData
    }

    
//    func beginSignIn() {
//        let task = Task {
//            do {
//                let refineSemesterInfo = refineSemester(degree: degreesStatus, semesterYear: semesterYear, semester: semesterStatus)
//                let userData = UserDataMinimum(
//                    id: userId,
//                    name: name,
//                    sex: sex.getText(), 
//                    birth: birthDate.description, 
//                    schoolName: schoolName, 
//                    enrolled: enrollmentStatus.description, 
//                    semester: refineSemesterInfo,
//                    majorCategory: majorField.description
//                )
//                try await self.managerActor.signInWithMinumumData(userData: userData)
//                self.networkStatus = .success
//            } catch {
//                print(error)
//                self.networkStatus = .failed
//            }
//        }
//        tasks.append(task)
//    }
}


extension Date {
    func DateDayFomatter() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: self)
    }
}
