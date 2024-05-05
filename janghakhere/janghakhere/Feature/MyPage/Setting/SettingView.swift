//
//  SettingView.swift
//  janghakhere
//
//  Created by Gaeun Lee on 4/27/24.
//

import SwiftUI

struct SettingView: View {
    @EnvironmentObject private var pathModel: PathModel
    
    var body: some View {
        VStack(spacing: 0) {
            NavigationDefaultView(title: "설정")
            
            VStack(spacing: 0) {
                settingCell(title: "문의하기")
                    .onTapGesture {
                        pathModel.paths.append(.webView(title: "문의하기", url: inquiryURL))
                    }
                settingCell(title: "정보 초기화")
                    .onTapGesture {
                        pathModel.paths.append(.resetInfoView)
                    }
            }
            .paddingHorizontal()
            
            Spacer()
        }
        .navigationBarBackButtonHidden()
    }
}

extension SettingView {
    @ViewBuilder
    func settingCell(title: String) -> some View {
        HStack(spacing: 0) {
            Text(title)
            Spacer()
            Icon(name: .chevronRight, size: 20)
                .padding(.trailing, 2)
        }
        .padding(.vertical, 19)
        .contentShape(Rectangle())
    }
}

#Preview {
    SettingView()
}
