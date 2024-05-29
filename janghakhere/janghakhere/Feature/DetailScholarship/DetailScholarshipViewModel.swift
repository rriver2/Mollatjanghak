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
    @Published var status: PublicAnnouncementStatusCategory = .nothing
    @Published var isStatusSheet: Bool = false
    private var tasks: [Task<Void, Never>] = []
    
    func shareButtonPressed() {
        if let detailContent = detailContent,
        let url = detailContent.homePageUrl {
            let productName = detailContent.productName
            let organization = detailContent.organization
            let endDate = convertToKoreanDate(detailContent.endDate ?? "")
            let supportDetails = detailContent.formattedSupportDetails
            let effortLabel = detailContent.effortLabel
            
            let formattedProductName = productName != nil ? productName! + "\n" : ""
            let formattedOrganization = organization != nil ? organization! + "\n\n" : ""
            let formattedEndDate = endDate != nil ? ("✅ 마감일: " + endDate! + "\n"): ""
            let formattedSupportDetails = supportDetails != nil ? ("✅ 지원 금액: " + supportDetails! + "\n") : ""
            let formattedEffortLabel = effortLabel != nil ? ("✅ 노력 지수: " + effortLabel!) : ""

            let text = "\n\(formattedProductName)\(formattedOrganization)\(formattedEndDate)\(formattedSupportDetails)\(formattedEffortLabel)\n\n나에게 꼭 맞는 장학금 여깄장학이 다 찾아드릴게요"
            let activityVC = UIActivityViewController(activityItems: [ url, text], applicationActivities: nil)
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
    private func getDetailScholarship(_ id: String, _ status: PublicAnnouncementStatusCategory) {
        let task = Task {
            do {
                self.detailContent = try await managerActor.fetchDetailScholarship(id)
                //FIXME: 백엔드에서 status 값 주면 변경하기
                self.status = status
                self.networkStatus = .success
            } catch {
                print(error)
                self.networkStatus = .failed
            }
        }
        tasks.append(task)
    }
    
    private func postScholarshipStatus(id: Int, status: String) {
        
    }
    
    private func convertToKoreanDate(_ dateString: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        if let date = dateFormatter.date(from: dateString) {
            dateFormatter.dateFormat = "yyyy년 MM월 dd일"
            return dateFormatter.string(from: date)
        } else {
            return nil
        }
    }
}

// 기본 함수들
extension DetailScholarshipViewModel {
    func viewOpened(_ id: String, _ status: PublicAnnouncementStatusCategory) {
        self.getDetailScholarship(id, status)
    }
    
    func cancelTasks() {
        tasks.forEach({ $0.cancel()})
        tasks = []
    }
}
