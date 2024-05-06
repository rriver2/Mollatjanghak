//
//  AllScholarshipView.swift
//  janghakhere
//
//  Created by Gaeun Lee on 4/16/24.
//

import SwiftUI

struct AllScholarshipView: View {
    @EnvironmentObject private var pathModel: PathModel
    @StateObject private var viewModel = AllScholarshipViewModel()
    @State private var isUserSwipedBanner = false
    
    @Binding var selection: Int
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollViewReader { proxy in
                VStack(spacing: 0) {
                    VStack(spacing: 0) {
                        header(proxy: proxy)
                        advertisement()
                        sortingScholarship()
                    }
                    .paddingHorizontal()
                    switch viewModel.networkStatus {
                    case .loading:
                        loading()
                    case .success:
                        ScholarshipBoxListView(isGetMoreScholarshipBox: $viewModel.isGetMoreScholarshipBox, scholarshipList: $viewModel.scholarshipList, isShowPassStatus: false)
                            .onChange(of: viewModel.isGetMoreScholarshipBox, { _, _ in
                                userTouchedBottomOfTheScroll()
                            })
                    case .failed:
                        error()
                    }
                }
            }
        }
        .onAppear {
            viewModel.viewOpened()
            NotificationManager.instance.requestAuthorization()
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
            Icon(name: viewModel.isNewAlarm ? .alarmActive : .alarmDefault, size: 28)
                .onTapGesture {
                    pathModel.paths.append(.alarmView)
                }
        }
        .padding(.bottom, 16)
        .padding(.top, 16)
    }
    
    @ViewBuilder
    func advertisement() -> some View {
        TabView(selection: $viewModel.advertisementSelection) {
            Image(.banner0)
                .resizable()
                .scaledToFit()
                .onTapGesture {
                    selection = 2
                    pathModel.paths.append(.myInformationView)
                }
                .tag(0)
            Image(.banner1)
                .resizable()
                .scaledToFit()
                .tag(1)
            Image(.banner2)
                .resizable()
                .scaledToFit()
                .onTapGesture {
                    pathModel.paths.append(.webView(title: "복지로 청년월세 ", url: bockjiroURL))
                }
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
                    .foregroundStyle(.gray800)
                RoundedRectangle(cornerRadius: 5)
                    .frame(width: viewModel.advertisementSelectionWidth, height: 2)
                    .foregroundStyle(.gray60)
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
        .onChange(of: viewModel.advertisementSelection, { _, _ in
            viewModel.timerinit()
        })
        .animation(.easeInOut, value: viewModel.advertisementSelection)
        .transition(.slide)
    }
    
    @ViewBuilder
    func sortingScholarship() -> some View {
        HStack(spacing: 0) {
            switch viewModel.scholarshipCategory {
            case .all:
                Text("전체 장학금 \(viewModel.totalScholarshipCount)개")
                    .font(.semi_title_md)
            case .custom:
                Text("\(viewModel.name)님을 위한 장학금 \(viewModel.totalScholarshipCount)개")
                    .font(.semi_title_md)
            }
            Spacer()
//            Button {
//                
//            } label: {
//                HStack(spacing: 0) {
//                    Text("최신순")
//                        .font(.semi_title_md)
//                        .padding(.trailing, 4)
//                    Icon(name: .arrowsUpDown, color: .gray500, size: 20)
//                }
//                .foregroundStyle(.gray500)
//            }
        }
        .padding(.top, 4)
        .padding(.bottom, 16)
        .animation(.default, value: viewModel.totalScholarshipCount)
    }
    
    @ViewBuilder
    func loading() -> some View {
        VStack(spacing: 0) {
            Spacer()
            ProgressView()
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .background(Color.gray50)
    }
    
    @ViewBuilder
    func error() -> some View {
        ZStack(alignment: .bottom) {
            VStack(spacing: 0) {
                Spacer()
                Button {
                    viewModel.scholarshipCategoryButtonPressed(viewModel.scholarshipCategory)
                } label: {
                    VStack(spacing: 0) {
                        Icon(name: .graduation, size: 122)
                            .padding(.bottom, 8)
                        Text("잠시 후에 다시 시도해주세요")
                            .font(.title_xsm)
                            .padding(.bottom, 16)
                            .foregroundStyle(.gray600)
                        HStack {
                            Icon(name: .reload, color: .mainGray, size: 22)
                                .padding(.leading, 8)
                            Text("새로 고침")
                                .foregroundStyle(.mainGray)
                        }
                        .padding(.vertical, 14)
                        .padding(.horizontal, 24)
                        .background(.gray70)
                        .cornerRadius(130)
                    }
                }
                Spacer()
            }
            ErrorToastView(.network)
        }
        .frame(maxWidth: .infinity)
        .background(Color.gray50)
    }
}

extension AllScholarshipView {
    /// 만약 currentCellCount이 5가 되면, 다음 View 불러오기
    private func userTouchedBottomOfTheScroll() {
        if viewModel.isGetMoreScholarshipBox {
            viewModel.bottomPartScrolled()
        }
    }
}
