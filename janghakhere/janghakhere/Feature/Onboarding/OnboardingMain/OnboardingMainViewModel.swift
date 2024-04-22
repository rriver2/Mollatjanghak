//
//  OnboardingMainViewModel.swift
//  janghakhere
//
//  Created by Taehwan Kim on 4/21/24.
//

import SwiftUI

@MainActor
final class OnboardingMainViewModel: ObservableObject {
    let managerActor: OnboardingMainActor = OnboardingMainActor()
    
    private var tasks: [Task<Void, Never>] = []
    
    @Published private(set) var defaultDatas: [String] = []
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
}
