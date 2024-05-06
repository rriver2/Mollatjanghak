//
//  SettingViewModel.swift
//  janghakhere
//
//  Created by Gaeun Lee on 4/27/24.
//

import SwiftUI

@MainActor
final class ResetInfoViewModel: ObservableObject {
    let managerActor: ResetInfoActor = ResetInfoActor()
    @AppStorage("isRegistered") private var isRegisterd: Bool = false
    private var tasks: [Task<Void, Never>] = []
    
    func resetButtonPressed() {
        let task = Task {
            do {
                try await managerActor.clearUserInfo()
                //FIXME: 유저 디폴트 값 삭제
                
                isRegisterd = false
            } catch {
                print(error)
            }
        }
        tasks.append(task)
    }
}

// MARK: - 기본 함수들
extension ResetInfoViewModel {
    func cancelTasks() {
        tasks.forEach({ $0.cancel()})
        tasks = []
    }
}
