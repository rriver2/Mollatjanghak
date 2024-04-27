//
//  CustomAlertView.swift
//  janghakhere
//
//  Created by Gaeun Lee on 4/27/24.
//

import SwiftUI

// ResetInfoView 외의 다른 View에서 사용하게 될 시 Custom 필요함
struct CustomAlertView: View {
    
    var mainButtonPressed: (() -> Void)
    var subButtonPressed: (() -> Void)
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            VStack(spacing: 0) {
                Icon(name: .imgwarning, size: 44)
                    .padding(.top, 32)
                    .padding(.bottom, 20)
                Text("정말 초기화하시겠어요?")
                    .font(.title_sm)
                    .padding(.bottom, 16)
                Text("초기화된 정보는 복구될 수 없어요")
                    .font(.text_sm)
                    .padding(.bottom, 24)
                Text("초기화")
                    .foregroundStyle(.white)
                    .padding(.vertical, 14)
                    .font(.title_xsm)
                    .padding(.horizontal, 96.5)
                    .background(.destructiveRed)
                    .cornerRadius(130)
                    .padding(.bottom, 20)
                    .onTapGesture {
                        mainButtonPressed()
                    }
                    .padding(.horizontal, 20)
                Text("취소")
                    .foregroundStyle(.gray400)
                    .font(.title_xsm)
                    .padding(.bottom, 32)
                    .onTapGesture {
                        subButtonPressed()
                    }
            }
            .background(.white)
            .cornerRadius(16)
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .background(.alertBackground)
    }
}

#Preview {
    CustomAlertView(mainButtonPressed: {}, subButtonPressed: {})
}
