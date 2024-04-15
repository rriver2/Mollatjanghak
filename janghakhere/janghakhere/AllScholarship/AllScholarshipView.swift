//
//  AllScholarshipView.swift
//  janghakhere
//
//  Created by Gaeun Lee on 4/16/24.
//

import SwiftUI

struct AllScholarshipView: View {
    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 0) {
                // 헤더
                header()
                // 광고
                advertisement()
                // 필터
                filter()
            }
            .paddingHorizontal()
            
            VStack(spacing: 0) {
                ScrollView {
                    // 장학금 박스들
                    ForEach([1,2,3,4,5,6,7,8,9,10], id: \.self) { index in
                        Button {
                            
                        } label: {
                            ScholarshipBoxView()
                        }
                    }
                }
                .scrollIndicators(.hidden)
                .padding(.top, 16)
                .paddingHorizontal()
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .background(Color.gray50)
        }
    }
}

extension AllScholarshipView {
    @ViewBuilder
    func header() -> some View {
        HStack(spacing: 0) {
            Text("맞춤")
                .font(.title_md)
                .foregroundStyle(.mainGray)
                .padding(.trailing, 16)
            Text("전체")
                .font(.title_md)
                .foregroundStyle(.gray300)
            Spacer()
            Icon(name: .exempleIcon, size: 28)
                .padding(.trailing, 12)
            Icon(name: .exempleIcon, size: 28)
        }
        .padding(.bottom, 16)
        .padding(.top, 16)
    }
    
    //FIXME: 디자인 자세하게 어떻게 될 지 모르겠어서 반영 안 했습니다.
    @ViewBuilder
    func advertisement() -> some View {
        RoundedRectangle(cornerRadius: 8)
            .fill(Color.gray50)
            .frame(height: 93)
            .padding(.bottom, 16)
    }
    @ViewBuilder
    func filter() -> some View {
        HStack(spacing: 0) {
            Text("영서님을 위한 장학금 63개")
                .font(.semi_title_md)
            Spacer()
            Button {
                
            } label: {
                HStack(spacing: 0) {
                    Text("최신순")
                        .font(.semi_title_md)
                        .padding(.trailing, 4)
                    Icon(name: .exempleIcon, size: 20)
                }
                .tint(.gray500)
            }
        }
        .padding(.bottom, 16)
    }
}

#Preview {
    AllScholarshipView()
}
