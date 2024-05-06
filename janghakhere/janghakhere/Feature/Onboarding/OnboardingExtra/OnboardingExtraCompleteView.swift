//
//  OnboardingExtraCompleteView.swift
//  janghakhere
//
//  Created by Taehwan Kim on 5/1/24.
//

import SwiftUI

struct OnboardingExtraCompleteView: View {
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                Spacer()
                Button {
//                    dismiss()
                } label: {
                    Icon(name: .exit, color: .black, size: 28)
                }
            }
            .padding(.vertical, 28)
            .padding(.bottom, 68)
            
            Icon(name: .wand, size: 122)
                .padding(.bottom, 28)
            
            Text("입력이 끝났어요!")
                .font(.title_lg)
                .foregroundStyle(.black)
                .padding(.bottom, 20)
            Text("정보를 바탕으로 더 적절한 장학금을\n안내해 드릴게요")
                .font(.title_sm)
                .foregroundStyle(.gray500)
                .multilineTextAlignment(.center)
            Spacer()
        }
        .paddingHorizontal()
    }
}

#Preview {
    OnboardingExtraCompleteView()
}
