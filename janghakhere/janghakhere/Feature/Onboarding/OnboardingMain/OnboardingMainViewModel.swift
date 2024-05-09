//
//  OnboardingMainViewModel.swift
//  janghakhere
//
//  Created by Taehwan Kim on 4/21/24.
//

import SwiftUI

struct UserData: Codable {
    let id: String
    var name: String
    var sex: Sex
    var birth: Date
    var schoolName: String
    var enrolled: EnrollmentStatus // EnrolledStatus, 입학예정, 재학 등
    var degree: DegreesStatus // 현재 없음. degreesStatus, 학사, 석사 등
    var schoolYear: SemesterYear // 현재 없음. 1학년, 2학년 등
    var semester: SemesterStatus // 수정 필요. 1학기, 2학기만 되게
    var majorCategory: MajorField
    var lastSemesterGrade: Double?
    var totalGrade: Double?
    var maximumGrade: MaxGradeStatus?
    var incomeRange: IncomeDecile?
    var militaryService: MilitaryStatus?
    var siblingStatus: SiblingStatus?
    var detailedConditions: [String]
    var totalScholarshipMoney: Int
    var applyCount: Int
    var successScholarshipCount: Int
}

@MainActor
final class OnboardingMainViewModel: ObservableObject {
    let managerActor: OnboardingMainActor = OnboardingMainActor()
    @Published var networkStatus: NetworkStatus = .loading
    
    private var tasks: [Task<Void, Never>] = []
    @AppStorage("userData") private var userData: Data?
    @Published var userId = HTTPUtils.getDeviceUUID()
    
    @Published private(set) var defaultDatas: [String] = []
    
    @Published var currentPage: Int = 0
    @Published var name: String = ""
    @Published var birthDate: Date = .now
    @Published var schoolName: String = ""
    @Published var previousGrade: Double = 0.0
    @Published var entireGrade: Double = 0.0
    
    @Published var sex: Sex = .notSelected
    @Published var incomeDecile: IncomeDecile = .notSelected
    @Published var maximumGrade: MaxGradeStatus = .fourDotFive
    @Published var semesterYear: SemesterYear = .notSelected
    @Published var semesterStatus: SemesterStatus = .notSelected
    @Published var enrollmentStatus: EnrollmentStatus = .notSelected
    @Published var majorField: MajorField = .notSelected
    @Published var degreesStatus: DegreesStatus = .notSelected
    
    @Published var isShowBirthdaySheet = false
    @Published var isShowSemesterSheet = false
    @Published var isShowIncomeSheet = false
    @Published var isShowGradeSheet = false
    
    private var nilPreviousGrade: Double? {
        if previousGrade != 0 {
                return previousGrade
        } else {
            return  nil
        }
    }
    private var nilEntireGrade: Double? {
        if entireGrade != 0 {
            return entireGrade
        } else {
            return nil
        }
    }
    
    private var nilIncomeDecile: String? {
        if incomeDecile != .notSelected {
            return incomeDecile.description
        } else {
            return nil
        }
    }
    
    private var nilMaximumGrade: String? {
        if maximumGrade != .notSelected {
            return maximumGrade.description
        } else {
            return nil
        }
    }
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
            sex: sex.description,
            birth: birthDate.DateDayFomatter(),
            schoolName: schoolName,
            enrolled: enrollmentStatus.description,
            semester: refineSemesterInfo,
            majorCategory: majorField.description,
            previousGrade: nilPreviousGrade,
            entireGrade: nilEntireGrade,
            maximumGrade: nilMaximumGrade,
            incomeDecile: nilIncomeDecile
        )
        return userData
    }
    
    func saveUserData() {
        let userData = UserData(
            id: userId,
            name: name,
            sex: sex,
            birth: birthDate,
            schoolName: schoolName,
            enrolled: enrollmentStatus,
            degree: degreesStatus,
            schoolYear: semesterYear,
            semester: semesterStatus,
            majorCategory: majorField,
            lastSemesterGrade: nilPreviousGrade,
            totalGrade: nilEntireGrade,
            maximumGrade: maximumGrade,
            incomeRange: incomeDecile,
            militaryService: nil,
            siblingStatus: nil,
            detailedConditions: [],
            totalScholarshipMoney: 0,
            applyCount: 0,
            successScholarshipCount: 0
        )
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(userData)
            self.userData = data
        } catch {
            print("Failed to encode user data: \(error)")
        }
    }
}


extension Date {
    func DateDayFomatter() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: self)
    }
}
