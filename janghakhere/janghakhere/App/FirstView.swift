//
//  FirstView.swift
//  janghakhere
//
//  Created by Gaeun Lee on 4/15/24.
//

import SwiftUI

struct FirstView: View {
    @StateObject private var pathModel = PathModel()
    @AppStorage("isRegistered") private var isRegisterd: Bool = false
    
    var body: some View {
        NavigationStack(path: $pathModel.paths) {
            Group {
                if isRegisterd {
                    TapView()
                } else {
                    OnboardingBeginView()
                }
            }
            .tint(.black)
            .navigationDestination(for: PathType.self) { pathType  in
                switch pathType {
                case .detailScholarshipView(let id):
                    DetailScholarshipView(id: id)
                case .searchScholarshipView:
                    SearchScholarshipView()
                case .onboardingBeginView:
                    OnboardingBeginView()
                case .onboardingMainView:
                    OnboardingMainView()
                        .navigationBarBackButtonHidden()
                case .onboardingWaitingView(let userData):
                    OnboardingWaitingView(userData: userData)
                        .navigationBarBackButtonHidden()
                case .onboardingCompleteView(let count):
                    OnboardingCompleteView(count: count)
                        .navigationBarBackButtonHidden()
                case .alarmView:
                    AlarmView()
                case .resetInfoView:
                    ResetInfoView()
                case .settingView:
                    SettingView()
                case .myInformationView:
                    MyInformationView()
                        .navigationBarBackButtonHidden()
                case .onboardingExtraView:
                    OnboardingExtraView()
                        .navigationBarBackButtonHidden()
                case .onboardingExtraCompleteView:
                    OnboardingExtraCompleteView()
                        .navigationBarBackButtonHidden()
                case .tapView:
                    TapView()
                        .navigationBarBackButtonHidden()
                case .webView(let title, let url):
                    SettingWebView(title: title, url: url)
                }
            }
        }
        .environmentObject(pathModel)
    }
}

#Preview {
    FirstView()
}
