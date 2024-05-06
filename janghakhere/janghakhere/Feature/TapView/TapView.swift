//
//  TapView.swift
//  janghakhere
//
//  Created by Taehwan Kim on 5/4/24.
//

import SwiftUI

struct TapView: View {
    @State private var selection = 0
    
    var body: some View {
        TabView (selection: $selection) {
            AllScholarshipView(selection: $selection)
                .tabItem {
                    Icon(name: .newspaperClipping, color: selection == 0 ? .black : .gray400, size: 28)
                    Text("전체공고")
                        .font(.caption)
                }
                .tag(0)
//            MyScholarshipView()
//                .tabItem {
//                    Icon(name: .newspaperChecks, color: selection == 1 ? .black : .gray400, size: 28)
//                    Text("내공고")
//                        .font(.caption)
//                }
//                .tag(1)
            MyPageView()
                .tabItem {
                    Icon(name: .user, color: selection == 2 ? .black : .gray400, size: 28)
                    Text("마이페이지")
                        .font(.caption)
                }
                .tag(2)
        }
    }
}

#Preview {
    TapView()
}
