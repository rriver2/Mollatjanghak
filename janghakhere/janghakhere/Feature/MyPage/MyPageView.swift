//
//  MyPageView.swift
//  janghakhere
//
//  Created by Gaeun Lee on 4/16/24.
//

import SwiftUI

struct MyPageView: View {
    @EnvironmentObject var pathModel: PathModel
    @StateObject var viewModel = MyPageViewModel()
    var body: some View {
        ZStack {
            Color.gray50
            VStack(spacing: 0) {
                navigation()
                nameContent()
                totalScholarshipMoneyContent()
                myScholarshipStatisticsContent()
                Spacer()
            }
            .paddingHorizontal()
        }
        .ignoresSafeArea()
    }
}

extension MyPageView {
    
    @ViewBuilder
    private func myScholarshipStatisticsContent() -> some View {
        
        HStack() {
            Spacer()
            VStack(alignment: .center, spacing: 0) {
                Icon(name: .stack, color: .mainGray, size: 28)
                    .padding(.bottom, 16)
                Text("지원한 공고 수")
                    .font(.semi_title_md)
                    .foregroundColor(.gray600)
                    .padding(.bottom, 12)
                Text("\(viewModel.applyCount)개")
                    .font(.title_xsm)
                    .foregroundStyle(.black)
                    .padding(.bottom, 10)
            }
            .frame(maxWidth: .infinity)
            Spacer()
            Rectangle()
                .frame(width: 1)
                .foregroundColor(.gray200)
            Spacer()
            VStack(alignment: .center, spacing: 0) {
                Icon(name: .chartDonut, color: .mainGray, size: 28)
                    .padding(.bottom, 16)
                Text("합격비율")
                    .font(.semi_title_md)
                    .foregroundColor(.gray600)
                    .padding(.bottom, 12)
                Text("\(viewModel.successRatio)%")
                    .font(.title_xsm)
                    .foregroundStyle(.black)
                    .padding(.bottom, 10)
            }
            .frame(maxWidth: .infinity)
            Spacer()
        }
        .padding(.vertical, 28)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(.white)
        )
        .fixedSize(horizontal: false, vertical: true)
    }
    
    @ViewBuilder
    private func totalScholarshipMoneyContent() -> some View {
        HStack(spacing: 0) {
            Icon(name: .currencyKrw, color: .subGreen, size: 28)
                .padding(.trailing, 8)
            Text("총 수혜 금액")
            Spacer()
            Text("\(viewModel.totalScholarshipMoney)원")
        }
        .font(.title_xsm)
        .foregroundStyle(.black)
        .padding(.vertical, 24)
        .padding(.horizontal, 24)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(.white)
        )
        .padding(.bottom, 16)
    }
    
    @ViewBuilder
    private func nameContent() -> some View {
        VStack(alignment: .center, spacing: 0) {
            Text("\(viewModel.name)님")
                .font(.title_md)
                .foregroundStyle(.black)
                .padding(.bottom, 12)
            Button {
                pathModel.paths.append(.myInformationView)
            } label: {
                HStack(spacing: 3) {
                    Icon(name: .pencilLine, color: .mainGray, size: 15)
                    Text("내 정보 보기")
                        .font(.semi_title_md)
                }
                .padding(.vertical, 4)
                .padding(.horizontal, 12)
                .foregroundStyle(.mainGray)
                .background(
                    Capsule()
                        .fill(.gray100)
                )
            }
        }
        .padding(.bottom, 48)
    }
    
    
    @ViewBuilder
    private func navigation() -> some View {
        HStack(spacing: 0) {
            Text("마이페이지")
                .font(.title_md)
                .foregroundStyle(.black)
            Spacer()
            Icon(name: .gear, color: .black, size: 28)
                .onTapGesture {
                    pathModel.paths.append(.settingView)
                }
        }
        .padding(.vertical, 56)
    }
}

#Preview {
    MyPageView()
}
