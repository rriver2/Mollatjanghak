//
//  DetailScholarshipViewModel.swift
//  janghakhere
//
//  Created by Gaeun Lee on 4/21/24.
//

import SwiftUI

@MainActor
final class DetailScholarshipViewModel: ObservableObject {
    let managerActor: DetailScholarshipActor = DetailScholarshipActor()
    
    @Published private(set) var detailContent: DetailScholarshipContent?
    @Published private(set) var networkStatus: NetworkStatus = .loading
    @Published private(set) var detailScholarship: DetailScholarship?

    private var tasks: [Task<Void, Never>] = []
    
    func shareButtonPressed() {
        if let detailScholarship = detailScholarship {
            let text = "여깄장학 설명"
            let activityVC = UIActivityViewController(activityItems: [detailScholarship.url, text], applicationActivities: nil)
            let allScenes = UIApplication.shared.connectedScenes
            let scene = allScenes.first { $0.activationState == .foregroundActive }
            
            if let windowScene = scene as? UIWindowScene {
                windowScene.windows.first?.rootViewController?.present(activityVC, animated: true, completion: nil)
            }
        }
    }
}

// private 함수들
extension DetailScholarshipViewModel {
    private func getDetailScholarship(_ id: String) {
        let task = Task {
            do {
                self.detailContent = try await managerActor.fetchDetailScholarship(id)
//                detailScholarship = try await managerActor.fetchDetailScholarship(id)
                self.networkStatus = .success
            } catch {
                print(error)
                self.networkStatus = .failed
            }
        }
        tasks.append(task)
    }
}

// 기본 함수들
extension DetailScholarshipViewModel {
    func viewOpened(_ id: String) {
        self.getDetailScholarship(id)
    }
    
    func cancelTasks() {
        tasks.forEach({ $0.cancel()})
        tasks = []
    }
}
