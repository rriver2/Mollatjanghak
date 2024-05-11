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
    @AppStorage("userData") private var userData: Data?
    @Published var decodedData: UserData?
    @Published var id: String = ""
    @Published var name: String = "미입력"
    @Published var sex: Sex = .notSelected
    @Published var birthDate: Date = Date()
    @Published var enrolled: EnrollmentStatus = .notSelected
    @Published var militaryStatus: MilitaryStatus = .notSelected
    @Published var degreeStatus: DegreesStatus = .notSelected
    @Published var incomeStatus: IncomeDecile = .notSelected
    @Published var siblingStatus: SiblingStatus = .notSelected
    @Published var schoolName: String = "미입력"
    @Published var schoolYear: SemesterYear = .notSelected
    @Published var semester: SemesterStatus = .notSelected
    @Published var majorField: MajorField = .notSelected
    @Published var lastSemesterGrade: Double = 0.0
    @Published var totalGrade: Double = 0.0
    @Published var maxGrade: MaxGradeStatus = .notSelected
    
    @Published var isShowBirthdaySheet: Bool = false
    @Published var isShowSchoolYearSheet: Bool = false
    @Published var isShowGradeSheet: Bool = false
    
    @Published var isShowSchoolNameSheet: Bool = false
    @Published var isShowMajorSheet: Bool = false
    @Published var isShowGradesSheet: Bool = false
    @Published var isShowSiblingSheet: Bool = false
    @Published var isShowIncomeSheet: Bool = false
    
    private var tasks: [Task<Void, Never>] = []
}

// MARK: - private 함수들
extension MyInformationViewModel {
    private func initializeUserData() {
        if let data = userData {
            do {
                let decoder = JSONDecoder()
                let loadedUserData = try decoder.decode(UserData.self, from: data)
                self.id = loadedUserData.id
                self.decodedData = loadedUserData
                self.degreeStatus = loadedUserData.degree
                self.enrolled = loadedUserData.enrolled
                self.name = loadedUserData.name
                self.sex = loadedUserData.sex
                self.birthDate = loadedUserData.birth
                self.semester = loadedUserData.semester
                if let lastGrade = loadedUserData.lastSemesterGrade {
                    self.lastSemesterGrade = lastGrade
                } else {
                    self.lastSemesterGrade = 0.0
                }
                
                if let military = loadedUserData.militaryService {
                    self.militaryStatus = military
                } else {
                    self.militaryStatus = MilitaryStatus.notSelected
                }
                
                if let incomeStatus = loadedUserData.incomeRange {
                    self.incomeStatus = incomeStatus
                } else {
                    self.incomeStatus = IncomeDecile.notSelected
                }

                if let siblingStatus = loadedUserData.siblingStatus {
                    self.siblingStatus = siblingStatus
                } else {
                    self.siblingStatus = SiblingStatus.notSelected
                }
                
                
                self.schoolName = loadedUserData.schoolName
                self.schoolYear = loadedUserData.schoolYear
                self.majorField = loadedUserData.majorCategory
                
                if let totalGrade = loadedUserData.totalGrade {
                    self.totalGrade = totalGrade
                } else {
                    self.totalGrade = 0.0
                }
                
                if let maxGrade = loadedUserData.maximumGrade {
                    self.maxGrade = maxGrade
                } else {
                    self.maxGrade = .notSelected
                }
                
            } catch {
                print("Failed to decode user data: \(error)")
            }
        }
    }
    
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
extension MyInformationViewModel {
    func createView() {
        self.initializeUserData()
    }
    
    func cancelTasks() {
        tasks.forEach({ $0.cancel()})
        tasks = []
    }
    
    func makeUserData() -> UserDataMaximum {
        let refineSemesterInfo = refineSemester(
            degree: degreeStatus,
            semesterYear: schoolYear,
            semester: semester)
        
        let userData = UserDataMaximum(
            id: id,
            name: name,
            sex: sex.description,
            birth: birthDate.DateDayFomatter(),
            schoolName: schoolName,
            enrolled: enrolled.description,
            semester: refineSemesterInfo,
            majorCategory: majorField.description,
            previousGrade: lastSemesterGrade,
            entireGrade: totalGrade,
            incomeDecile: incomeStatus.description,
            militaryService: militaryStatus.description,
            siblingExists: siblingStatus == .exist ? true : false,
            detailedConditions: []
        )
        return userData
    }
    
    func sendNewUserData(userData: UserDataMaximum) {
        let task = Task {
            do {
                try await self.managerActor.sendNewUserData(userData: userData)
            } catch {
                print(error)
            }
        }
        tasks.append(task)
    }
    func saveUserData() {
        let userData = UserData(
            id: id,
            name: name,
            sex: sex,
            birth: birthDate,
            schoolName: schoolName,
            enrolled: enrolled,
            degree: degreeStatus,
            schoolYear: schoolYear,
            semester: semester,
            majorCategory: majorField,
            lastSemesterGrade: lastSemesterGrade,
            totalGrade: totalGrade,
            maximumGrade: maxGrade,
            incomeRange: incomeStatus,
            militaryService: militaryStatus,
            siblingStatus: siblingStatus,
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
    func MyInfoDateFomatter() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월 dd일"
        return formatter.string(from: self)
    }
}
