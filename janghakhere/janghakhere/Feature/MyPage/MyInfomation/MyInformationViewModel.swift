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
    
    private var tasks: [Task<Void, Never>] = []
    
    @Published private(set) var defaultDatas: [String] = []
}

// MARK: - private 함수들
extension MyInformationViewModel {
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
extension MyInformationViewModel {
    func createView() {
        self.useTemplatePrivateFunction()
    }
    
    func cancelTasks() {
        tasks.forEach({ $0.cancel()})
        tasks = []
    }
}
