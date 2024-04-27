//
//  SettingWebView.swift
//  janghakhere
//
//  Created by Gaeun Lee on 4/27/24.
//

import SwiftUI

struct SettingWebView: View {
    let title: String
    let url: URL
    
    var body: some View {
        VStack(spacing: 0) {
            NavigationDefaultView(title: title)
            WebTotalView(url: url)
        }
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    SettingWebView(title: "제목입니다", url: inquiryURL)
}
