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
//    @Published private(set) var detailScholarship: DetailScholarship? = nil
      let successFailActor: ScholarshipStatusActor = ScholarshipStatusActor()
      @Published var isStatusSheet: Bool = false
    private var tasks: [Task<Void, Never>] = []
    
//    func shareButtonPressed() {
//        if let detailContent = detailContent {
//            let date = convertToKoreanDate(detailContent.endDate) ?? detailContent.endDate
//            let DDay = Date().calculationDday(endDateString: detailContent.endDate)
//            let DDayString = DDay == "0" ? "오늘 마감" : "D\(DDay)"
//            //FIXME: 켄 \(노력지수) 이거 상 중 하 로 넣으면 됩니다.
//            let text = "\(detailContent.productName)\n(\(detailContent.organization))\n\n✅ 마감일: \(date) (\(DDayString))\n✅ 지원 금액: \(detailContent.supportDetails)\n✅ 노력 지수: 노력지수\n\n나에게 꼭 맞는 장학금 여깄장학이 다 찾아드릴게요"
//            let activityVC = UIActivityViewController(activityItems: [ detailContent.homePageUrl, text], applicationActivities: nil)
//            let allScenes = UIApplication.shared.connectedScenes
//            let scene = allScenes.first { $0.activationState == .foregroundActive }
//            
//            if let windowScene = scene as? UIWindowScene {
//                windowScene.windows.first?.rootViewController?.present(activityVC, animated: true, completion: nil)
//            }
//        }
//    }
    
    func statusButtonPressed(status: PublicAnnouncementStatusCategory, id: String) {
        self.status = status
        if let id = Int(id) {
            // 네트워크 여부와 상관 없이 현재 상태 저장
            self.postScholarshipStatus(id: id, status: status.rawValue)
        }
        if let detailContent = detailContent {
//            if status == .saved {
//                let dateString = detailContent.endDate
//                let dateFormatter = DateFormatter()
//                dateFormatter.dateFormat = "yyyy-MM-dd"
//                if let date = dateFormatter.date(from: dateString) {
//                    NotificationManager.instance.scheduleNotification(.DDayAlarm(id: String(detailContent.id), title: detailContent.productName, date: date))
//                }
//            } else if status == .nothing {
//                NotificationManager.instance.cancelSpecificNotification(id: id)
//            }
           
            self.isStatusSheet = false
        }
    }
}

// private 함수들
extension DetailScholarshipViewModel {
    private func getDetailScholarship(_ id: String) {
        let task = Task {
            do {
                self.detailContent = try await managerActor.fetchDetailScholarship(id)
                self.networkStatus = .success
            } catch {
                print(error)
                self.networkStatus = .failed
            }
        }
        tasks.append(task)
    }
    
    private func postScholarshipStatus(id: Int, status: String) {
        let task = Task {
            do {
                _ = try await successFailActor.postScholarshipStatus(id: id, status: status)
            } catch {
                print(error)
            }
        }
        tasks.append(task)
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
    func viewOpened(_ id: String) {
        self.getDetailScholarship(id)
    }
    
    func cancelTasks() {
        tasks.forEach({ $0.cancel()})
        tasks = []
    }
}
