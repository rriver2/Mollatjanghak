//
//  ResetInfoView.swift
//  janghakhere
//
//  Created by Gaeun Lee on 4/27/24.
//

import SwiftUI

struct ResetInfoView: View {
    @EnvironmentObject private var pathModel: PathModel
    @State private var isShowResetAlert = false
    @StateObject private var viewModel: ResetInfoViewModel = ResetInfoViewModel()
    @AppStorage("isRegistered") private var isRegisterd: Bool = false
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                NavigationDefaultView(title: "정보 초기화")
                Icon(name: .handDisappear, size: 144)
                    .padding(.top, 40)
                    .padding(.bottom, 47)
                Text("정말로 초기화 하시겠어요?")
                    .font(.title_sm)
                    .padding(.bottom, 40)
                Rectangle()
                    .foregroundStyle(.gray50)
                    .frame(height: 6)
                    .padding(.bottom, 29)
                HStack(spacing: 0) {
                    VStack(alignment: .leading, spacing: 0) {
                        Text("다음과 같은 정보들이 사라져요")
                            .font(.title_xsm)
                            .padding(.bottom, 28)
                        resetContentInfo(content: "입력해 둔 내 정보")
                        resetContentInfo(content: "나를 위한 장학금 추천")
                        resetContentInfo(content: "저장해 둔 내 공고 리스트")
                        resetContentInfo(content: "이 외 모든 정보")
                    }
                    Spacer()
                }
                .paddingHorizontal()
                Spacer()
                Button {
                    isShowResetAlert = true
                } label: {
                    Text("초기화")
                        .foregroundStyle(.white)
                        .padding(.vertical, 14)
                        .font(.title_xsm)
                        .padding(.horizontal, 49)
                        .background(.destructiveRed)
                        .cornerRadius(130)
                }
                .padding(.bottom, 50)
            }
            if isShowResetAlert {
                CustomAlertView(mainButtonPressed: {
                    viewModel.resetButtonPressed()
                    isShowResetAlert = false
                    pathModel.paths.append(.onboardingBeginView)
                }, subButtonPressed: {
                    isShowResetAlert = false
                })
            }
        }
        .navigationBarBackButtonHidden()
        .onDisappear {
            viewModel.cancelTasks()
        }
    }
    
    private func cancelButtonPressed() {
        isShowResetAlert = false
    }
}

extension ResetInfoView {
    @ViewBuilder
    func resetContentInfo(content: String) -> some View {
        HStack(spacing: 8) {
            Icon(name: .trash, color: .gray600, size: 24)
            Text(content)
                .font(.text_md)
        }
        .padding(.bottom, 20)
    }
}

#Preview {
    ResetInfoView()
}
