//
//  AllScholarshipView.swift
//  janghakhere
//
//  Created by Gaeun Lee on 4/16/24.
//

import SwiftUI

struct AllScholarshipView: View {
    @EnvironmentObject private var pathModel: PathModel
    @EnvironmentObject private var scholarshipStatusViewModel: ScholarshipStatusViewModel
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
                        if viewModel.scholarshipCategory == .custom && viewModel.scholarshipList.isEmpty {
                            emptyCustomScholarshipView(proxy: proxy)
                        } else {
                            ScholarshipBoxListView(isGetMoreScholarshipBox: $viewModel.isGetMoreScholarshipBox, scholarshipList: $viewModel.scholarshipList, boxCategory: .AllScholarship)
                                .onChange(of: viewModel.isGetMoreScholarshipBox, { _, _ in
                                    userTouchedBottomOfTheScroll()
                                })
                        }
                    case .failed:
                        error()
                    }
                }
            }
        }
        .onAppear {
            viewModel.viewOpened()
            let newScholarShipList = scholarshipStatusViewModel.getFilteringScholarshipList(list: viewModel.scholarshipList)
            viewModel.scholarshipList = newScholarShipList
            print("viewModel.scholarshipList", viewModel.scholarshipList)
            NotificationManager.instance.requestAuthorization()
        }
        .onDisappear {
            viewModel.cancelTasks()
        }
    }
}

extension AllScholarshipView {
    @ViewBuilder
    func emptyCustomScholarshipView(proxy: ScrollViewProxy) -> some View {
        VStack(spacing: 8) {
            Spacer()
            Icon(name: .graduation, size: 122)
            Text("맞춤 공고가 없어요")
                .font(.title_xsm)
                .foregroundStyle(.gray600)
                .padding(.bottom, 8)
            Text("전체 공고 보기")
                .padding(.horizontal, 24)
                .padding(.vertical, 14)
                .foregroundColor(.mainGray)
                .background(.gray70)
                .cornerRadius(130)
                .onTapGesture {
                    viewModel.scholarshipCategoryButtonPressed(.all)
                    withAnimation {
                        proxy.scrollTo(viewModel.scholarshipList.first?.id, anchor: .top)
                    }
                }
            Spacer()
        }
    }
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
            Button {
                viewModel.isShowFilteringSheet = true
            } label: {
                HStack(spacing: 0) {
                    Text(viewModel.filteringcategory.title)
                        .font(.semi_title_md)
                        .padding(.trailing, 4)
                    Icon(name: .arrowsUpDown, color: .gray500, size: 20)
                }
                .foregroundStyle(.gray500)
            }
        }
        .padding(.top, 4)
        .padding(.bottom, 16)
        .animation(.default, value: viewModel.totalScholarshipCount)
        .sheet(isPresented: $viewModel.isShowFilteringSheet) {
            VStack(alignment: .leading, spacing: 0) {
                Text("정렬")
                    .font(.title_xsm)
                    .padding(.top, 20)
                    .frame(maxWidth: .infinity)
                ForEach(ScholarshipBoxListFliteringCategory.allCases, id: \.self) { category in
                    filteringButton(category: category)
                }
                Spacer()
                Text("닫기")
                    .font(.title_xsm)
                    .foregroundStyle(.white)
                    .padding(.vertical, 16)
                    .frame(maxWidth: .infinity)
                    .background(.mainGray)
                    .cornerRadius(100)
                    .padding(.bottom, 14)
                    .onTapGesture {
                        viewModel.isShowFilteringSheet = false
                    }
            }
            .padding(.horizontal, 28)
            .foregroundStyle(.black)
            .presentationDetents([.medium])
        }
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
    @ViewBuilder
    private func filteringButton(category: ScholarshipBoxListFliteringCategory) -> some View {
        HStack(spacing: 16) {
            Text(category.title)
                .foregroundStyle(category == viewModel.filteringcategory ? .subGreen : .gray700)
                .font(.title_xsm)
            Spacer()
            if category == viewModel.filteringcategory {
                Icon(name: .checkFat, color: .subGreen, size: 16)
            }
        }
        .padding(.vertical, 18)
        .contentShape(Rectangle())
        .onTapGesture {
            viewModel.sortingButtonPressed(viewModel.scholarshipCategory, category)
            viewModel.isShowFilteringSheet = false
        }
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
