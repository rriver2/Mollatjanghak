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
    
    @Published var name: String = "미입력"
    @Published var sex: Sex = .notSelected
    @Published var birth: Date = Date()
    @Published var militaryStatus: MilitaryStatus = .notSelected
    @Published var incomeStatus: IncomeDecile = .notSelected
    @Published var siblingStatus: SiblingStatus = .notSelected
    @Published var schoolName: String = "미입력"
    @Published var schoolYear: SemesterYear = .notSelected
    @Published var majorField: MajorField = .notSelected
    @Published var lastSemesterGrade: String = "미입력"
    @Published var totalGrade: String = "미입력"
    @Published var maxGrade: MaxGradeStatus = .notSelected
    
    private var tasks: [Task<Void, Never>] = []
}

// MARK: - private 함수들
extension MyInformationViewModel {
    private func initializeUserData() {
        if let data = userData {
            do {
                let decoder = JSONDecoder()
                let loadedUserData = try decoder.decode(UserData.self, from: data)
                self.decodedData = loadedUserData
                
                self.name = loadedUserData.name
                self.sex = loadedUserData.sex
                self.birth = loadedUserData.birth
                
                if let lastGrade = loadedUserData.lastSemesterGrade {
                    self.lastSemesterGrade = String(lastGrade)
                } else {
                    self.lastSemesterGrade = "미입력"
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
                    self.totalGrade = String(totalGrade)
                } else {
                    self.totalGrade = "미입력"
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
}

extension Date {
    func MyInfoDateFomatter() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월 dd일"
        return formatter.string(from: self)
    }
}
