//
//  OnboardingWaitingView.swift
//  janghakhere
//
//  Created by Taehwan Kim on 4/23/24.
//

import SwiftUI

struct OnboardingWaitingView: View {
    var name: String
    
    var body: some View {
        VStack {
            Image("hat")
                .frame(width: 122, height: 122)
                .padding(.top, 150)
            Text("환영합니다!")
                .font(.title_lg)
                .foregroundStyle(.black)
                .padding(.vertical, 20)
            Text("\(name)님에게 맞는\n장학금 정보를 찾고 있어요...")
                .font(.title_sm)
                .foregroundStyle(.gray600)
                .multilineTextAlignment(.center)
            Spacer()
        }
    }
}

#Preview {
    OnboardingWaitingView(name: "윤영서")
}
