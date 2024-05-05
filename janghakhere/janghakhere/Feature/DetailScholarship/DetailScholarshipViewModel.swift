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
    
    let successFailActor: ScholarshipStatusActor = ScholarshipStatusActor()
    
    @Published private(set) var detailScholarship: DetailScholarship? = nil
    @Published private(set) var id: String = "123"
    @Published private(set) var organization: String = "(재)한국장학재단"
    @Published private(set) var viewCount: String = "183"
    @Published private(set) var productName: String = "인문100년장학금"
    @Published private(set) var deadline: String = "D-3"
    @Published private(set) var money: String = "200만원+"
    @Published private(set) var startDate: String = "2023-05-06"
    @Published private(set) var endDate: String = "2024-05-10"
    @Published private(set) var selectionCountDetails: String = "학교마다 선발하는 인원이 상이하므로 장학부서에 확인 필수"
    @Published private(set) var supportDetails: String = "신규장학생 어쩌구 저쩌구"
    @Published private(set) var requiredDocumentDetails: String = "학업계획서 전인적 성장계획서"
    @Published private(set) var selectionMethodDetails: String = "대학별 배정인원 범위 내에서 선발기준에 따라 대학별..."
    @Published private(set) var universityCategory: String = "4년제(5~6년제포함)"
    @Published private(set) var grade: String = "대학 5학기/대학신입생"
    @Published private(set) var majorCategory: String = "교육계열/사회계열/인문계열"
    @Published private(set) var incomeDetails: String = "해당없음"
    @Published private(set) var specificQualificationDetails: String = "대한민국 국적소지자로서 국내 4년제 어쩌구"
    @Published private(set) var gradeDetails: String = "백분위 90점 이상"
    @Published private(set) var localResidencyDetails: String = "해당없음"
    @Published private(set) var recommendationRequiredDetails: String = "해당없음"
    @Published private(set) var eligibilityRestrictionDetails: String = "인문100년 장학금 장핵생 자격 유지자 또는 기준 인문 100년 장학생으로 선발된 후 영구탈락 된 학생"
    @Published var status: PublicAnnouncementStatusCategory = .nothing
    
    @Published var isStatusSheet: Bool = false
    
    private var tasks: [Task<Void, Never>] = []
    
    func shareButtonPressed() {
        if let detailScholarship = detailScholarship {
            let date = convertToKoreanDate(endDate) ?? endDate
            let DDay = Date().calculationDday(endDateString: endDate)
            let DDayString = DDay == "0" ? "오늘 마감" : "D\(DDay)"
            //FIXME: 켄 \(노력지수) 이거 상 중 하 로 넣으면 됩니다.
            let text = "\(productName)\n(\(organization))\n\n✅ 마감일: \(date) (\(DDayString))\n✅ 지원 금액: \(money)\n✅ 노력 지수: 노력지수\n\n나에게 꼭 맞는 장학금 여깄장학이 다 찾아드릴게요"
            
            let activityVC = UIActivityViewController(activityItems: [detailScholarship.url, text], applicationActivities: nil)
            let allScenes = UIApplication.shared.connectedScenes
            let scene = allScenes.first { $0.activationState == .foregroundActive }
            
            if let windowScene = scene as? UIWindowScene {
                windowScene.windows.first?.rootViewController?.present(activityVC, animated: true, completion: nil)
            }
        }
    }
    
    func statusButtonPressed(status: PublicAnnouncementStatusCategory, id: String) {
        self.status = status
        if let id = Int(id) {
            // 네트워크 여부와 상관 없이 현재 상태 저장
            self.postScholarshipStatus(id: id, status: status.rawValue)
        }
        
        if status == .storage {
            let dateString = endDate
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            if let date = dateFormatter.date(from: dateString) {
                NotificationManager.instance.scheduleNotification(.DDayAlarm(id: id, title: productName, date: date))
            }
        } else if status == .nothing {
            NotificationManager.instance.cancelSpecificNotification(id: id)
        }
       
        self.isStatusSheet = false
    }
}

// private 함수들
extension DetailScholarshipViewModel {
    private func getDetailScholarship(_ id: String) {
        let task = Task {
            do {
                detailScholarship = try await managerActor.fetchDetailScholarship(id)
            } catch {
                print(error)
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
