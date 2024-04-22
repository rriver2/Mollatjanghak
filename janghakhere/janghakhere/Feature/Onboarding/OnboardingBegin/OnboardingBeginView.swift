//
//  OnboardingBeginView.swift
//  janghakhere
//
//  Created by Taehwan Kim on 4/21/24.
//

import SwiftUI

struct OnboardingBeginView: View {
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            Spacer()
            Image(systemName: "bell")
                .font(.system(size: 144))
            Text("평균 123개의 장학금을 \n추천받을 수 있어요!")
                .font(.title_md)
                .foregroundStyle(.primary)
                .padding()
            
            Text("나를 위한 장학금을 추천받으려면\n몇 가지 정보가 필요해요")
                .font(.title_xsm)
                .foregroundStyle(.gray500)
                .padding()
            
            Spacer()
            
            Button {} label: {
                Text("입력하고 추천받기")
                    .font(.title_xsm)
            }
            .buttonStyle(MainButtonStyle(disabled: false))
            .padding()
        }
    }
}

#Preview {
    OnboardingBeginView()
}
