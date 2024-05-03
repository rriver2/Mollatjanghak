//
//  extension.swift
//  janghakhere
//
//  Created by Gaeun Lee on 4/16/24.
//

import SwiftUI

// MARK: - View
extension View {
    //FIXME: 켄 padding enum으로 변경하기
    func paddingHorizontal() -> some View {
        self
            .padding(.horizontal, 20)
    }
    
    func font(_ font: UIFont) -> some View {
        var fontSpacing: CGFloat {
            if font == .text_sm {
                return font.lineHeight / 100 * 80 / 4
            } else {
                return font.lineHeight / 100 * 50 / 4
            }
        }
        return self
            .font(Font(font))
            .padding(.top, fontSpacing)
            .padding(.bottom, fontSpacing)
            .lineSpacing(fontSpacing * 2)
    }
    
    func Icon(name: ImageResource, color: Color, size: CGFloat) -> some View {
        Image(name)
            .renderingMode(.template)
            .resizable()
            .foregroundColor(color)
            .scaledToFit()
            .frame(width: size, height: size)
    }
    
    func Icon(name: ImageResource, size: CGFloat) -> some View {
        Image(name)
            .resizable()
            .scaledToFit()
            .frame(width: size, height: size)
    }
    /// Applies the given transform if the given condition evaluates to `true`.
    /// - Parameters:
    ///   - condition: The condition to evaluate.
    ///   - transform: The transform to apply to the source `View`.
    /// - Returns: Either the original `View` or the modified `View` if the condition is `true`.
    @ViewBuilder func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}

// MARK: - UIFont
extension UIFont {
    static let title_lg = UIFont.systemFont(ofSize: 30, weight: .semibold)
    static let title_md = UIFont.systemFont(ofSize: 26, weight: .semibold)
    static let title_sm = UIFont.systemFont(ofSize: 20, weight: .semibold)
    static let title_xsm = UIFont.systemFont(ofSize: 17, weight: .semibold)
    static let title_xmd = UIFont.systemFont(ofSize: 24, weight: .semibold) 
    
    static let semi_title_md = UIFont.systemFont(ofSize: 15, weight: .semibold)
    static let semi_title_sm = UIFont.systemFont(ofSize: 12, weight: .semibold)
    
    static let text_md = UIFont.systemFont(ofSize: 16, weight: .regular)
    static let text_sm = UIFont.systemFont(ofSize: 14, weight: .regular)
    static let text_caption = UIFont.systemFont(ofSize: 12, weight: .regular)
}

// MARK: - UserDefault
extension UserDefaults {
    static func saveObjectInDevice<T: Encodable>(key: UserDefaultKey, content: T) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(content) {
            UserDefaults.standard.setValue(encoded, forKey: key.rawValue)
        }
    }
    
    static func getObjectFromDevice<T:Decodable>(key: UserDefaultKey, _ type: T.Type) -> T? {
        if let object = UserDefaults.standard.object(forKey: key.rawValue) as? Data {
            return try? JSONDecoder().decode(T.self, from: object)
        } else {
            return nil
        }
    }
    
    static func saveValueInDevice<T>(key: UserDefaultKey, content: T) {
        UserDefaults.standard.setValue(content, forKey: key.rawValue)
    }
    
    static func getValueFromDevice<T>(key: UserDefaultKey, _ type: T.Type) -> T? {
        return UserDefaults.standard.object(forKey: key.rawValue) as? T
    }
    
    static func removeSomething(key: UserDefaultKey) {
        UserDefaults.standard.removeObject(forKey: key.rawValue)
    }
}

// MARK: - Date
extension Date {
    func customDateFomatter() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월 dd일"
        return formatter.string(from: self)
    }
    
    /// 오늘로부터 endDateString까지 D-Day 도출하는 함수
    /// - Parameter endDateString: "2024-04-12"
    /// - Returns: "-4" / "0" / "+6"
    func calculationDday(endDateString: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        if let language = UserDefaults.standard.array(forKey: "Language")?.first as? String {
            formatter.locale = Locale(identifier: language)
        }
        
        let startDate = self
        
        guard let endDate = formatter.date(from: endDateString) else {
            return "#"
        }
        
        var result = Calendar.current.dateComponents(
            [.day],
            from: startDate,
            to: endDate
        ).day!
        
        let resultHour = Calendar.current.dateComponents(
            [.hour],
            from: startDate,
            to: endDate
        ).hour!
        
        if resultHour > 0 {
            result += 1
        }
        
        if result == 0 {
            return "0"
        } else if result < 0 {
            return "+\(abs(result))"
        } else {
            return "-\(abs(result))"
        }
    }
}

// MARK: - Date
extension Color {
    init?(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        var rgb: UInt64 = 0
        var red: CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue: CGFloat = 0.0
        var opacity: CGFloat = 1.0
        let length = hexSanitized.count
        guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else { return nil }
        if length == 6 {
            red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
            green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
            blue = CGFloat(rgb & 0x0000FF) / 255.0
        } else if length == 8 {
            red = CGFloat((rgb & 0xFF000000) >> 24) / 255.0
            green = CGFloat((rgb & 0x00FF0000) >> 16) / 255.0
            blue = CGFloat((rgb & 0x0000FF00) >> 8) / 255.0
            opacity = CGFloat(rgb & 0x000000FF) / 255.0
        } else {
            return nil
        }
        self.init(red: red, green: green, blue: blue, opacity: opacity)
    }
}
