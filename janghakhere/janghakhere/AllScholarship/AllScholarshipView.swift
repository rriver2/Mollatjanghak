//
//  AllScholarshipView.swift
//  janghakhere
//
//  Created by Gaeun Lee on 4/16/24.
//

import SwiftUI

struct AllScholarshipView: View {
    @StateObject private var viewModel = AllScholarshipViewModel()
    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 0) {
                header()
                advertisement()
                sortingScholarship()
            }
            .paddingHorizontal()
            
            scholarshipBoxList()
        }
        .onAppear {
            viewModel.viewOpened()
        }
        .onDisappear {
            viewModel.cancelTasks()
        }
    }
}

extension AllScholarshipView {
    @ViewBuilder
    func header() -> some View {
        HStack(spacing: 0) {
            ForEach(ScholarshipCategory.allCases, id: \.self) { category in
                Button {
                    viewModel.scholarshipCategoryButtonPressed(category)
                } label: {
                    Text(category.name)
                        .font(.title_md)
                        .foregroundStyle(category == viewModel.scholarshipCategory ? .mainGray : .gray300)
                        .padding(.trailing, 16)
                }
            }
            
            Spacer()
            Icon(name: .exempleIcon, size: 28)
                .padding(.trailing, 12)
            Icon(name: .exempleIcon, size: 28)
        }
        .padding(.bottom, 16)
        .padding(.top, 16)
    }
    
    //FIXME: 디자인 자세하게 어떻게 될 지 모르겠어서 아직 반영 안 했습니다.
    @ViewBuilder
    func advertisement() -> some View {
        RoundedRectangle(cornerRadius: 8)
            .fill(Color.gray50)
            .frame(height: 93)
            .padding(.bottom, 16)
    }
    @ViewBuilder
    func sortingScholarship() -> some View {
        HStack(spacing: 0) {
            Text("영서님을 위한 장학금 \(viewModel.scholarshipList.count)개")
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
    @ViewBuilder
    func scholarshipBoxList() -> some View {
        //FIXME: 맞춤 <-> 전체 시 제일 위로 스크롤 되도록
        VStack(spacing: 0) {
            ScrollView {
                // 장학금 박스들
                ForEach(viewModel.scholarshipList, id: \.self) { scholarship in
                    Button {
                        viewModel.scholarshipButtonPressed(id: scholarship.id)
                    } label: {
                        ScholarshipBoxView(scholarshipBox: scholarship)
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

#Preview {
    AllScholarshipView()
}
