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
    @AppStorage("userData") private var userData: Data?
    @Published private(set) var decodedData: UserData?
    private var tasks: [Task<Void, Never>] = []
    
    @Published private(set) var defaultDatas: [String] = []
}

// MARK: - private 함수들
extension MyPageViewModel {
    private func initializeUserData() {
        if let data = userData {
            do {
                let decoder = JSONDecoder()
                let loadedUserData = try decoder.decode(UserData.self, from: data)
                self.decodedData = loadedUserData
            } catch {
                print("Failed to decode user data: \(error)")
            }
        }
    }
}

// MARK: - 기본 함수들
extension MyPageViewModel {
    func createView() {
        self.initializeUserData()
    }
    
    func cancelTasks() {
        tasks.forEach({ $0.cancel()})
        tasks = []
    }
}
