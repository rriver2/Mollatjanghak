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
    
    func Icon(name: IconCategory, color: Color? = .black, size: CGFloat) -> some View {
        Image(name.rawValue)
            .renderingMode(.template)
            .resizable()
            .foregroundColor(color)
            .scaledToFit()
            .frame(width: size, height: size)
    }
}

// MARK: - Font
extension Font {
    static let title_lg = Font.system(size: 30, weight: .semibold, design: .default)
    static let title_md = Font.system(size: 26, weight: .semibold, design: .default)
    static let title_sm = Font.system(size: 20, weight: .semibold, design: .default)
    static let title_xsm = Font.system(size: 17, weight: .semibold, design: .default)
    
    static let semi_title_md = Font.system(size: 15, weight: .semibold, design: .default)
    static let semi_title_sm = Font.system(size: 12, weight: .semibold, design: .default)
    
    static let text_md = Font.system(size: 16, weight: .regular, design: .default)
    static let text_sm = Font.system(size: 14, weight: .regular, design: .default)
    static let caption = Font.system(size: 12, weight: .regular, design: .default)
}
