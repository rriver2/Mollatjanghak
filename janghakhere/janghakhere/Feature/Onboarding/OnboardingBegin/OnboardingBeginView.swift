//
//  OnboardingBeginView.swift
//  janghakhere
//
//  Created by Taehwan Kim on 4/21/24.
//

import SwiftUI

struct OnboardingBeginView: View {
    @EnvironmentObject var pathModel: PathModel
    @State private var showSheet: Bool = false
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            Spacer()
            Image("grabPaper")
                .font(.system(size: 144))
            Text("평균 258개의 장학금을 \n추천받을 수 있어요!")
                .font(.title_md)
                .foregroundStyle(.black)
                .multilineTextAlignment(.center)
                .padding()
            
            Text("나를 위한 장학금을 추천받으려면\n몇 가지 정보가 필요해요")
                .font(.title_xsm)
                .foregroundStyle(.gray600)
                .multilineTextAlignment(.center)
                .padding()
            
            Spacer()
            
            HStack(spacing: 0) {
                Image(systemName: "exclamationmark.circle.fill")
                    .padding(.trailing, 8)
                    .foregroundStyle(.subGreen)
                Text("정보는 장학금 추천 외에는 사용되지 않아요")
                    .font(.semi_title_md)
                    .foregroundStyle(.gray500)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(.gray60)
            )
            .padding(.vertical, 28)
            
            MainButtonView(
                title: "입력하고 추천받기",
                action: {
                    showSheet.toggle()
                },
                disabled: false
            )
            .padding(.horizontal, 11)
        }
        .padding()
        .sheet(isPresented: $showSheet) {
            ServiceAgreementView()
        }
    }
}

#Preview {
    OnboardingBeginView()
}
