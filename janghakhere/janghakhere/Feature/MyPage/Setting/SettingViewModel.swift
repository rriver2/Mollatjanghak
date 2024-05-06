//
//  SettingViewModel.swift
//  janghakhere
//
//  Created by Taehwan Kim on 5/6/24.
//

import SwiftUI

@MainActor
final class SettingViewModel: ObservableObject {
    @AppStorage("userData") private var userData: Data?
    @Published private(set) var decodedData: UserData?
    
}

// MARK: - private 함수들
extension SettingViewModel {
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
extension SettingViewModel {
    func createView() {
        self.initializeUserData()
    }
}
