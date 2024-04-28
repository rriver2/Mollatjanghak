//
//  OnboardingCompleteView.swift
//  janghakhere
//
//  Created by Taehwan Kim on 4/26/24.
//

import SwiftUI

struct OnboardingCompleteView: View {
    @State var disable: Bool = false
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            HStack {
                Spacer()
                Button {} label: {
                    Image(systemName: "xmark")
                        .foregroundStyle(.mainGray)
                        .font(.system(size: 28))
                }
            }
            .padding(.vertical, 28)
            
            Image(systemName: "bell")
                .resizable()
                .frame(width: 122, height: 122)
                .padding(.top, 40)
                .padding(.bottom, 8)
            Text("환영합니다!")
                .font(.title_lg)
                .foregroundStyle(.black)
                .padding(.vertical, 20)
            Text("윤영서님에게 맞는 장학금")
                .font(.title_sm)
                .foregroundStyle(.gray600)
                .padding(.bottom, 12)
            HStack(spacing: 5) {
                Text("개")
                    .font(.title_sm)
                    .foregroundStyle(.gray600)
            }
            Spacer()
            Text("추가정보를 입력하면\n더 적절한 장학금을 추천드릴수 있어요")
                .font(.text_md)
                .foregroundStyle(.gray500)
                .multilineTextAlignment(.center)
                .padding(.vertical, 20)
            
            NonMaxButton(
                title: "더 입력할래요",
                action: {
                    
                }
            )
            
            .padding(.horizontal, 11)
        }
        .padding(.horizontal, 20)
    }
}

#Preview {
    OnboardingCompleteView()
}
