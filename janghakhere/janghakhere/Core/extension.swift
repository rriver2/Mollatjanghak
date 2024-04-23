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
}

// MARK: - UIFont
extension UIFont {
    static let title_lg = UIFont.systemFont(ofSize: 30, weight: .semibold)
    static let title_md = UIFont.systemFont(ofSize: 26, weight: .semibold)
    static let title_sm = UIFont.systemFont(ofSize: 20, weight: .semibold)
    static let title_xsm = UIFont.systemFont(ofSize: 17, weight: .semibold)
    
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
