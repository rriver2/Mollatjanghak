//
//  AllScholarshipView.swift
//  janghakhere
//
//  Created by Gaeun Lee on 4/16/24.
//

import SwiftUI

struct MainButtonStyle: ButtonStyle {
  func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .font(.title3)
      .foregroundStyle(.white)
      .padding()
      .frame(maxWidth: .infinity)
      .frame(height: 50)
      .background(
        RoundedRectangle(cornerRadius: 5)
          .fill(.mainGray.opacity(0.8))
      )
      .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
  }
}

struct AllScholarshipView: View {
    @EnvironmentObject private var pathModel: PathModel
    @StateObject private var viewModel = AllScholarshipViewModel()
    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 0) {
                header()
                advertisement()
                sortingScholarship()
            }
            .paddingHorizontal()
            
            ScholarshipBoxListView(scholarshipList: viewModel.scholarshipList)
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
                .foregroundStyle(.gray500)
            }
        }
        .padding(.bottom, 16)
    }
}

#Preview {
    AllScholarshipView()
}
