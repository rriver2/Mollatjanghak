//
//  NotificationManager.swift
//  janghakhere
//
//  Created by Gaeun Lee on 4/30/24.
//

import SwiftUI
import UserNotifications

class NotificationManager {
    static let instance = NotificationManager()
    
    /// 제일 처음에 알림 설정을 하기 위한 함수
    func requestAuthorization() {
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        UNUserNotificationCenter.current().requestAuthorization(options: options) { [self] suceess, error in
            if let error {
                print("ERROR: \(error)")
            } else if suceess {
                UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
                    if !requests.contains(where: {  $0.identifier == "EveryFriday" }) {
                        self.scheduleNotification(.weeklyAlarm)
                    }
                }
            }
        }
    }
    
    enum Notificationcategory {
        case weeklyAlarm
        case DDayAlarm(id: String, title: String, date: Date)
    }
    
    /// 알림 설정하기
    /// - Parameter category: weeklyAlarm: 매주 금요일 6시에, DDayAlarm: DDay, 3일, 7일 전 알림
    func scheduleNotification(_ category: Notificationcategory) {
        switch category {
        case .weeklyAlarm:
            // 매주 금요일 6시에
            scheduleNotificationEveryFriday()
        case .DDayAlarm(let id, let title, let date):
            // DDay, 3일, 7일 전 알림
            let (baseDate, threeDaysAgo, sevenDaysAgo) = calculateDates(from: date)
            
            if isPassed(baseDate) { break }
            scheduleNotification_0_3_7_before(id: id, title: title, subTitle: "오늘까지 지원할 수 있어요.", date: baseDate, hour: 12, DDay: "D-Day")
            
            if isPassed(threeDaysAgo) { break }
            scheduleNotification_0_3_7_before(id: id, title: title, subTitle: "마감 기한이 얼마 남지 않았어요.", date: threeDaysAgo, hour: 18, DDay: "D-3")
            
            if isPassed(sevenDaysAgo) { break }
            scheduleNotification_0_3_7_before(id: id, title: title, subTitle: "마감 기한이 일주일 남았어요.", date: sevenDaysAgo, hour: 18, DDay: "D-7")
        }
    }
    
    /// 전체 알림 삭제하기
    func cancelAllNotification() {
        // 곧 다가올 알림 지우기
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        // 현재 사용자 폰에 떠 있는 알림 지우기
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
    }
    
    /// 특정 알림 삭제하기
    func cancelSpecificNotification(id: String) {
        UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: [id])
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [id])
    }
    
    /// badge 삭제하기
    func deleteBadgeNumber() {
        UNUserNotificationCenter.current().setBadgeCount(0)
    }
}

// private 함수 모음
extension NotificationManager {
    /// 매주 금요일 오후 6시에 알림
    private func scheduleNotificationEveryFriday() {
        let content = UNMutableNotificationContent()
        let ranNum = Int.random(in: 1...10)
        if let name = UserDefaults.getValueFromDevice(key: .userName, String.self) {
            content.title = "\(name)님이 지원 가능한 공고가 \(ranNum)개 올라왔어요"
        } else {
            content.title = "지원 가능한 공고가 \(ranNum)개 올라왔어요"
        }
        content.subtitle = "여깄장학에서 확인하고 지원해보세요"
        content.sound = .default
        //TODO: badge 누적되게
        content.badge = 1
        
        var dateComponents = DateComponents()
        // 월1 화2 수3 목4 금5 토6 일7
        dateComponents.weekday = 5
        dateComponents.hour = 18
        dateComponents.minute = 00
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        let request = UNNotificationRequest(
            identifier: "EveryFriday",
            content: content,
            trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }
    
    /// 지정한 일자에 알림
    private func scheduleNotification_0_3_7_before(id: String, title: String, subTitle: String, date: Date, hour: Int, DDay: String) {
        let content = UNMutableNotificationContent()
        content.title = "[\(title)] \(DDay)"
        content.subtitle = subTitle
        content.sound = .default
        //TODO: badge 누적되게
        content.badge = 1
        
        let (year, month, day) = extractYearMonthDay(from: date)
        
        var dateComponents = DateComponents()
        dateComponents.year = year
        dateComponents.month = month
        dateComponents.day = day
        dateComponents.hour = hour
        dateComponents.minute = 00
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        let request = UNNotificationRequest(
            identifier: id,
            content: content,
            trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }
}

// 일자 계산을 위한 extension 함수
extension NotificationManager {
    private func calculateDates(from date: Date) -> (Dday: Date, threeDaysAgo: Date, sevenDaysAgo: Date) {
        let calendar = Calendar.current
        
        // 현재 날짜의 오후 6시를 기준으로
        var dateComponents = calendar.dateComponents([.year, .month, .day], from: date)
        dateComponents.hour = 18 // 오후 6시
        dateComponents.minute = 0
        dateComponents.second = 0
        let baseDate = calendar.date(from: dateComponents)!
        
        // 3일 전
        let threeDaysAgo = calendar.date(byAdding: .day, value: -3, to: baseDate)!
        
        // 7일 전
        let sevenDaysAgo = calendar.date(byAdding: .day, value: -7, to: baseDate)!
        
        return (baseDate, threeDaysAgo, sevenDaysAgo)
    }
    
    private func extractYearMonthDay(from date: Date) -> (year: Int, month: Int, day: Int) {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: date)
        
        guard let year = components.year,
              let month = components.month,
              let day = components.day else {
            fatalError("Failed to extract year, month, and day from the date.")
        }
        
        return (year, month, day)
    }
    
    private func isPassed(_ date: Date) -> Bool {
        let currentDate = Date()
        
        return date < currentDate
    }
}
