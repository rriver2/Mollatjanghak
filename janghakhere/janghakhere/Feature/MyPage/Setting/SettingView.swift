//
//  SettingView.swift
//  janghakhere
//
//  Created by Gaeun Lee on 4/27/24.
//

import SwiftUI
import MessageUI

struct SettingView: View {
    @EnvironmentObject private var pathModel: PathModel
    @State private var result: Result<MFMailComposeResult, Error>? = nil
    @State private var isShowingMailView = false

    
    var body: some View {
        VStack(spacing: 0) {
            NavigationDefaultView(title: "설정")
            
            VStack(spacing: 0) {
                settingCell(title: "문의하기")
                    .onTapGesture {
                        isShowingMailView.toggle()
                    }
                settingCell(title: "오픈소스 라이선스")
                    .onTapGesture {
                        pathModel.paths.append(.settingWebView(title: "오픈소스 라이선스", url: opensourceURL))
                    }
                settingCell(title: "정보 초기화")
                    .onTapGesture {
                        pathModel.paths.append(.resetInfoView)
                    }
            }
            .paddingHorizontal()
            
            Spacer()
        }
        .sheet(isPresented: $isShowingMailView) {
            MailView(result: $result) { composer in
                composer.setSubject("여깄장학 문의")
                let messageBody = """
------------------
- 유저: UserDefaults에 있는 유저 스트링
- 일시:
- iOS:
- 기종:
------------------

"""
                composer.setMessageBody(messageBody, isHTML: false)
                composer.setToRecipients(["janghakhere@gmail.com"])
            }
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
    
    func tapAskButton() {
        if MFMailComposeViewController.canSendMail() {
            isShowingMailView.toggle()
        } else {
            // TODO: 사용자의 이메일이 등록되어 있지 않는 경우 아무런 상호작용 발생하지 않음. 팝업? 어떤 식으로 알려주는 과정이 필요
        }
    }
}

#Preview {
    SettingView()
}
