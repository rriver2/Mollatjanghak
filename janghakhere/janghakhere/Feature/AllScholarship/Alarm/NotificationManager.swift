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
            
            var alarmScholarshipList: [AlarmScholarship] = []
            
            if !isPassed(baseDate) {
                scheduleNotification_0_3_7_before(id: id, title: title, subTitle: "오늘까지 지원할 수 있어요.", date: baseDate, hour: 12, DDay: "D-Day")
                alarmScholarshipList.append(AlarmScholarship(id: id, content: "\(title) D-Day\n마감기한이 얼마 남지 않았어요!", DDayDate: baseDate, category: .saved))            }
            if !isPassed(threeDaysAgo) {
                scheduleNotification_0_3_7_before(id: id, title: title, subTitle: "마감 기한이 얼마 남지 않았어요.", date: threeDaysAgo, hour: 18, DDay: "D-3")
                alarmScholarshipList.append(AlarmScholarship(id: id, content: "\(title) D-3\n마감기한이 얼마 남지 않았어요!", DDayDate: threeDaysAgo, category: .saved))
            }
            if !isPassed(sevenDaysAgo) {
                scheduleNotification_0_3_7_before(id: id, title: title, subTitle: "마감 기한이 일주일 남았어요.", date: sevenDaysAgo, hour: 18, DDay: "D-7")
                    alarmScholarshipList.append(AlarmScholarship(id: id, content: "\(title) D-7\n마감기한이 얼마 남지 않았어요!", DDayDate: sevenDaysAgo, category: .saved))
            }

            var alarmList = UserDefaults.getObjectFromDevice(key: .alertInfoList, [AlarmScholarship].self) ?? []
            
            for alarm in alarmScholarshipList {
                if !alarmList.contains(where: { $0.id == alarm.id && $0.DDayDate == alarm.DDayDate }) {
                    alarmList.append(alarm)
                }
            }
            
            UserDefaults.saveObjectInDevice(key: .alertInfoList, content: alarmList)
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
        
        if let alarmScholarshipList = UserDefaults.getObjectFromDevice(key: .alertInfoList, [AlarmScholarship].self) {
            let newAlarmScholarshipList = alarmScholarshipList.filter { $0.id != id }
            UserDefaults.saveObjectInDevice(key: .alertInfoList, content: newAlarmScholarshipList)
        }
    }
    
    /// 현재 존재하는 알림들 불러오기
    func getCurrentAlarmScholarshipList() -> [AlarmScholarship] {
        
        // 저장공고 알림
        var newAlarmList = UserDefaults.getObjectFromDevice(key: .alertInfoList, [AlarmScholarship].self) ?? []

        // 새공고 알림
        if let startDate = UserDefaults.getValueFromDevice(key: .alertFirstDate, Date.self) {
            let dateList = getFridaysFrom(startDate: startDate)
            let dateFormatterResult = DateFormatter()
            dateFormatterResult.dateFormat = "yyyy-MM-dd HH:mm:ss"
            for date in dateList {
                let ranNum = Int.random(in: 1...10)
                let name = UserDefaults.getValueFromDevice(key: .userName, String.self) ?? "💖"
                newAlarmList.append(AlarmScholarship(id: UUID().uuidString, content: "\(name)님이 지원 가능한 장학금 공고가 \(ranNum)개 올라왔어요!", DDayDate: date, category: .new))
            }
        }
        
        return newAlarmList.filter { $0.DDayDate <= Date() }
    }
    
    /// badge 삭제하기
    func deleteBadgeNumber() {
        UNUserNotificationCenter.current().setBadgeCount(0)
    }
}

// private 함수 모음
extension NotificationManager {
    /// startDate 기준으로 현재까지의 모든 금요일 6시 일자 list 추출하기
    private func getFridaysFrom(startDate: Date) -> [Date] {
        var currentDate = startDate
        var dateList = [Date]()

        let calendar = Calendar.current

        // 시작일 이후의 첫 번째 금요일로 이동
        while calendar.component(.weekday, from: currentDate) != 6 {
            currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate)!
        }

        // 현재 날짜까지의 모든 금요일을 찾아가면서 추가
        while currentDate <= Date() {
            // 오후 6시로 설정
            let fridaySixPM = calendar.date(bySettingHour: 18, minute: 0, second: 0, of: currentDate)!
            dateList.append(fridaySixPM)
            // 다음 주 금요일로 이동
            currentDate = calendar.date(byAdding: .day, value: 7, to: currentDate)!
        }

        return dateList
    }
    
    /// 매주 금요일 오후 6시에 알림
    private func scheduleNotificationEveryFriday() {
        let content = UNMutableNotificationContent()
        let ranNum = Int.random(in: 1...10)
        let name = UserDefaults.getValueFromDevice(key: .userName, String.self) ?? "💖"
        content.title = "\(name)님이 지원 가능한 공고가 \(ranNum)개 올라왔어요"
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
        
        UserDefaults.saveValueInDevice(key: .alertFirstDate, content: Date())
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
        
        return date > currentDate
    }
}
