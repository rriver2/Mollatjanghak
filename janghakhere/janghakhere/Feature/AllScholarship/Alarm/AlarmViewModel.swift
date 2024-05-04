//
//  AlarmViewModel.swift
//  janghakhere
//
//  Created by Gaeun Lee on 4/22/24.
//

import SwiftUI

@MainActor
final class AlarmViewModel: ObservableObject {
    let managerActor: AlarmActor = AlarmActor()
    
    @Published private(set) var alarmList: [AlarmScholarship] = []
}

// MARK: - private 함수들
extension AlarmViewModel {
    private func getAlarmList() {
        var newAlarmList: [AlarmScholarship] = NotificationManager.instance.getCurrentAlarmScholarshipList()
        alarmList = newAlarmList.sorted(by: { a, b in a.DDayDate > b.DDayDate})
    }
}

// MARK: - 기본 함수들
extension AlarmViewModel {
    func createView() {
        self.getAlarmList()
    }
    
    func disAppearView() {
        UserDefaults.saveValueInDevice(key: .lastAlertCheckedDate, content: Date())
    }
}
