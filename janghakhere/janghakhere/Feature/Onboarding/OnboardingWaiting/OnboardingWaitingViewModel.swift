//
//  OnboardingWaitingViewModel.swift
//  janghakhere
//
//  Created by Taehwan Kim on 5/5/24.
//

import SwiftUI

@MainActor
final class OnboardingWaitingViewModel: ObservableObject {
    let managerActor: OnboardingWaitingActor = OnboardingWaitingActor()
    @Published var matchedScholarships: Int = -1
    @Published private var timer: Timer?
    @AppStorage("isRegistered") private var isRegisterd: Bool = false
    private var tasks: [Task<Void, Never>] = []
}

// MARK: - private 함수들
extension OnboardingWaitingViewModel {
    private func checkServerJobDone(_ userData: UserDataMinimum) {
        let task = Task {
            do {
                if userData.id == "" { return }
                let data = try await managerActor.getCompleteStatus(id: userData.id)
                if data.done {
                    self.matchedScholarships = data.count
                    isRegisterd.toggle()
                    self.timer?.invalidate()
                    self.timer = nil
                }
            } catch {
                print(error)
            }
        }
        tasks.append(task)
    }
    
    private func timerinit(_ userData: UserDataMinimum) {
        timer?.invalidate()
        timer = nil
        self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            self.checkServerJobDone(userData)
        }
    }
}

// MARK: - 기본 함수들
extension OnboardingWaitingViewModel {
    func createView(userData: UserDataMinimum) {
        self.timerinit(userData)
    }
    
    func cancelTasks() {
        tasks.forEach({ $0.cancel()})
        tasks = []
    }
    
    func beginSignIn(userData: UserDataMinimum) {
        let task = Task {
            do {
                try await self.managerActor.signInWithMinumumData(userData: userData)
                
            } catch {
                print(error)
            }
        }
        tasks.append(task)
    }
}

