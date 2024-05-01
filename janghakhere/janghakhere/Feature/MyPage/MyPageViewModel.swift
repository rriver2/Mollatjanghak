//
//  MyPageViewModel.swift
//  janghakhere
//
//  Created by Taehwan Kim on 4/30/24.
//

import SwiftUI

@MainActor
final class MyPageViewModel: ObservableObject {
    let managerActor: MyPageActor = MyPageActor()
    @State private(set) var name: String = "윤영서"
    @State private(set) var totalScholarshipMoney: Int = 4400000
    @State private(set) var applyCount: Int = 3
    @State private(set) var successRatio: Int = 70
    private var tasks: [Task<Void, Never>] = []
    
    @Published private(set) var defaultDatas: [String] = []
}

// MARK: - private 함수들
extension MyPageViewModel {
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
extension MyPageViewModel {
    func createView() {
        self.useTemplatePrivateFunction()
    }
    
    func cancelTasks() {
        tasks.forEach({ $0.cancel()})
        tasks = []
    }
}
