//
//  ContentView.swift
//  janghakhere
//
//  Created by Gaeun Lee on 4/15/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            AllScholarshipView()
                .tabItem {
                    // FIXME: Icon 인거 아이콘 나오면 모두 변경해야 함
                    Icon(name: .exempleIcon, size: 28)
                    Text("전체공고")
                }
            MyScholarshipView()
                .tabItem {
                    Icon(name: .exempleIcon, size: 28)
                    Text("내공고")
                }
            MyPageView()
                .tabItem {
                    Icon(name: .exempleIcon, size: 28)
                    Text("마이페이지")
                }
        }
        .tint(.black)
    }
}

#Preview {
    ContentView()
}
