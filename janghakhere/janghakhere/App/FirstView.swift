//
//  FirstView.swift
//  janghakhere
//
//  Created by Gaeun Lee on 4/15/24.
//

import SwiftUI

struct FirstView: View {
    @StateObject private var pathModel = PathModel()
    @State private var selection = 0
    
    var body: some View {
        NavigationStack(path: $pathModel.paths) {
            TabView (selection: $selection) {
                AllScholarshipView()
                    .tabItem {
                        Icon(name: .newspaperClipping, color: selection == 0 ? .black : .gray400, size: 28)
                        Text("전체공고")
                            .font(.caption)
                    }
                    .tag(0)
                MyScholarshipView()
                    .tabItem {
                        Icon(name: .newspaperChecks, color: selection == 1 ? .black : .gray400, size: 28)
                        Text("내공고")
                            .font(.caption)
                    }
                    .tag(1)
                MyPageView()
                    .tabItem {
                        Icon(name: .user, color: selection == 2 ? .black : .gray400, size: 28)
                        Text("마이페이지")
                            .font(.caption)
                    }
                    .tag(2)
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
                case .onboardingWaitingView(let name):
                      OnboardingWaitingView(name: name)
                        .navigationBarBackButtonHidden()
                case .alarmView:
                    AlarmView()
                case .settingWebView(let title, let url):
                    SettingWebView(title: title, url: url)
                case .resetInfoView:
                    ResetInfoView()
                }
            }
        }
        .environmentObject(pathModel)
    }
}

#Preview {
    FirstView()
}
