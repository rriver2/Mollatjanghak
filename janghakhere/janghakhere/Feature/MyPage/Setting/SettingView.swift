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
    @StateObject private var viewModel = SettingViewModel()
    @State private var result: Result<MFMailComposeResult, Error>? = nil
    @State private var isShowingMailView = false
    @State private var showEmailAlert = false
    private let deviceInfo = DeviceInfo()
//    @AppStorage("userName") private var userName: String = ""
    
    var body: some View {
        VStack(spacing: 0) {
            NavigationDefaultView(title: "설정")
            VStack(spacing: 0) {
                settingCell(title: "문의하기")
                    .onTapGesture {
                        tapAskButton()
                    }
                settingCell(title: "정보 초기화")
                    .onTapGesture {
                        pathModel.paths.append(.resetInfoView)
                    }
            }
            .paddingHorizontal()
            
            Spacer()
        }
        .onAppear {
            viewModel.createView()
        }
        .sheet(isPresented: $isShowingMailView) {
            MailView(result: $result) { composer in
                composer.setSubject("여깄장학 문의")
                var messageBody: String = ""
                
                if let decodedData = viewModel.decodedData {
                    messageBody = """
    ===============
    해당 내용을 지우지 마세요!
    문의사항 반영에 도움이 됩니다.

    Device: \(deviceInfo.deviceModel)
    OS Version: \(deviceInfo.systemVersion)
    App Version: \(deviceInfo.appVersion)
    ID: \(decodedData.id)
    ===============

    앱에 대한 문의 내용을 입력해주세요.

    """
                } else {
                    messageBody = """
    ===============
    해당 내용을 지우지 마세요!
    문의사항 반영에 도움이 됩니다.

    Device: \(deviceInfo.deviceModel)
    OS Version: \(deviceInfo.systemVersion)
    App Version: \(deviceInfo.appVersion)
    닉네임: (추가부탁드립니다)
    ===============

    앱에 대한 문의 내용을 입력해주세요.

    """
                }
                
                composer.setMessageBody(messageBody, isHTML: false)
                composer.setToRecipients(["janghakhere@gmail.com"])
            }
        }
        .alert(isPresented: $showEmailAlert) {
            Alert(
                title: Text("이메일 설정 필요"),
                message: Text("문의를 하기 위해서는 기기에 이메일 계정을 설정해야 합니다."),
                dismissButton: .default(Text("확인"))
            )
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
            showEmailAlert.toggle()
        }
    }
}

#Preview {
    SettingView()
}



