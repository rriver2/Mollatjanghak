//
//  IncomeConfirmView.swift
//  janghakhere
//
//  Created by Taehwan Kim on 4/22/24.
//

import SwiftUI

struct IncomeConfirmView: View {
    @EnvironmentObject var pathModel: PathModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(alignment: .center) {
            Text("소득구간 확인")
                .font(.title_xsm)
                .padding(.vertical, 20)
            
            Text("한국장학재단에서 학자금 지원 대상자 선정을 위해\n가구마다 적용한 소득구간이에요.")
                .font(.text_md)
                .foregroundStyle(.gray600)
                .multilineTextAlignment(.center)
                .padding(.bottom, 20)
            
            Button {
                dismiss()
                pathModel.paths.append(
                    .webView(title: "한국장학재단", url: janghakURL))
                
            } label: {
                Text("한국장학재단 방문해서 확인하기")
                    .foregroundStyle(.subGreen)
                    .font(.text_md)
                    .underline()
            }
            .padding(.bottom, 44)
            
            MainButtonView(
                title: "닫기",
                action: {
                    dismiss()
                },
                disabled: false
            )
            .padding(.horizontal, 31)
        }
        .presentationDetents([.fraction(0.4)])
    }
}

#Preview {
    IncomeConfirmView()
}
