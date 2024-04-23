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
    
    private var tasks: [Task<Void, Never>] = []
    
    @Published private(set) var alarmList: [Alarm] = []
}

// MARK: - private 함수들
extension AlarmViewModel {
    private func useTemplatePrivateFunction() {
        let task = Task {
            do {
//                defaultDatas = try await managerActor.getData()
            } catch {
                print(error)
            }
        }
        tasks.append(task)
    }
}

// MARK: - 기본 함수들
extension AlarmViewModel {
    func createView() {
        self.useTemplatePrivateFunction()
    }
    
    func cancelTasks() {
        tasks.forEach({ $0.cancel()})
        tasks = []
    }
}
