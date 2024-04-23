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
            ScrollViewReader { proxy in
                VStack(spacing: 0) {
                    header(proxy: proxy)
                    advertisement()
                    sortingScholarship()
                }
                .paddingHorizontal()
                ScholarshipBoxListView(scholarshipList: viewModel.scholarshipList)
            }
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
    func header(proxy: ScrollViewProxy) -> some View {
        HStack(spacing: 0) {
            ForEach(ScholarshipCategory.allCases, id: \.self) { category in
                Button {
                    viewModel.scholarshipCategoryButtonPressed(category)
                    withAnimation {
                        proxy.scrollTo(viewModel.scholarshipList.first?.id, anchor: .top)
                    }
                } label: {
                    Text(category.name)
                        .font(.title_md)
                        .foregroundStyle(category == viewModel.scholarshipCategory ? .mainGray : .gray300)
                        .padding(.trailing, 16)
                }
            }
            
            Spacer()
            Icon(name: .magnifyingGlass, size: 28)
                .padding(.trailing, 12)
                .onTapGesture {
                    pathModel.paths.append(.searchScholarshipView)
                }
            //FIXME: alarm active <-> default
            Icon(name: .alarmActive, size: 28)
                .onTapGesture {
                    pathModel.paths.append(.alarmView)
                }
        }
        .padding(.bottom, 16)
        .padding(.top, 16)
    }
    
    //FIXME: 디자인 자세하게 어떻게 될 지 모르겠어서 아직 반영 안 했습니다.
    @ViewBuilder
    func advertisement() -> some View {
        TabView(selection: $viewModel.advertisementSelection) {
            Rectangle()
                .fill(Color.red)
                .tag(0)
            Rectangle()
                .fill(Color.green)
                .tag(1)
            Rectangle()
                .fill(Color.yellow)
                .tag(2)
        }
        .frame(height: 93)
        .clipShape(
            RoundedRectangle(cornerRadius: 8)
        )
        .overlay(alignment: .bottomTrailing) {
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 5)
                    .frame(width: 113, height: 2)
                    .foregroundStyle(.gray200)
                RoundedRectangle(cornerRadius: 5)
                    .frame(width: viewModel.advertisementSelectionWidth, height: 2)
                    .foregroundStyle(.gray500)
                    .animation(.linear, value: viewModel.advertisementSelectionWidth)
            }
            .padding(.bottom, 7)
            .padding(.trailing, 12)
        }
        .padding(.bottom, 12)
        .tabViewStyle(.page)
        .onAppear {
            UIPageControl.appearance().currentPageIndicatorTintColor = .clear
            UIPageControl.appearance().pageIndicatorTintColor = .clear
        }
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
                    Icon(name: .arrowsUpDown, color: .gray500, size: 20)
                }
                .foregroundStyle(.gray500)
            }
        }
        .padding(.top, 4)
        .padding(.bottom, 16)
    }
}

#Preview {
    AllScholarshipView()
}
