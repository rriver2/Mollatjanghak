//
//  MyScholarshipView.swift
//  janghakhere
//
//  Created by Gaeun Lee on 4/16/24.
//

import SwiftUI

struct MyScholarshipView: View {
    @EnvironmentObject private var pathModel: PathModel
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = MyScholarshipViewModel()
    @EnvironmentObject private var scholarshipStatusViewModel: ScholarshipStatusViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollViewReader { proxy in
                VStack(spacing: 0) {
                    header(proxy: proxy)
                    detailHeader(proxy: proxy)
                    switch viewModel.networkStatus {
                    case .loading:
                        VStack {
                            Spacer()
                            ProgressView()
                            Spacer()
                        }
                    case .success:
                        detailScholarshipBoxListView()
                    case .failed:
                        error()
                    }
                }
            }
        }
        .sheet(isPresented: $viewModel.isShowFilteringSheet) {
            filteringSheet()
        }
        .onChange(of: viewModel.selectedScholarShipList, { oldValue, newValue in
            if let category = viewModel.getStoreChangedtScholarShip() {
                viewModel.scholarshipCategoryButtonPressed(category)
            }
            let newScholarShipList = scholarshipStatusViewModel.getFilteringScholarshipList(list: viewModel.selectedScholarShipList)
            viewModel.selectedScholarShipList = newScholarShipList
        })
        .onAppear {
            viewModel.viewOpened()
            let newScholarShipList = scholarshipStatusViewModel.getFilteringScholarshipList(list: viewModel.totalScholarShipList)
            viewModel.totalScholarShipList = newScholarShipList
        }
        .onDisappear {
            viewModel.cancelTasks()
        }
    }
}

extension MyScholarshipView {
    @ViewBuilder
    func header(proxy: ScrollViewProxy) -> some View {
        HStack(spacing: 0) {
            Button {
                viewModel.scholarshipCategoryButtonPressed(.stored(.all))
                withAnimation {
                    proxy.scrollTo(viewModel.selectedScholarShipList.first?.id, anchor: .top)
                }
            } label: {
                Text(MyScholarshipCategory.storedName)
                    .font(.title_md)
                    .foregroundStyle(viewModel.selectedCategoryName == MyScholarshipCategory.storedName ? .black : .gray300)
                    .padding(.trailing, 16)
            }
            Button {
                viewModel.scholarshipCategoryButtonPressed(.supported(.applied))
                withAnimation {
                    proxy.scrollTo(viewModel.selectedScholarShipList.first?.id, anchor: .top)
                }
            } label: {
                Text(MyScholarshipCategory.supportedName)
                    .font(.title_md)
                    .foregroundStyle(viewModel.selectedCategoryName == MyScholarshipCategory.supportedName ? .black : .gray300)
                    .padding(.trailing, 16)
            }
            Spacer()
        }
        .padding(.bottom, 16)
        .padding(.top, 16)
        .paddingHorizontal()
    }
    @ViewBuilder
    func detailHeader(proxy: ScrollViewProxy) -> some View {
        ZStack(alignment: .bottom) {
            Rectangle()
                .foregroundStyle(.gray100)
                .frame(height: 2)
                .frame(maxWidth: .infinity)
            HStack(alignment: .top, spacing: 0) {
                switch viewModel.selectedCategory {
                case .supported(_):
                    HStack(alignment: .top, spacing: 0) {
                        ForEach(SupportedCategory.allCases, id: \.self) { category in
                            Button(action: {
                                viewModel.scholarshipCategoryButtonPressed(.supported(category))
                                withAnimation {
                                    proxy.scrollTo(viewModel.selectedScholarShipList.first?.id, anchor: .top)
                                }
                            }) {
                                detailHeaderButton(name: category.name, proxy: proxy)
                            }
                        }
                        Spacer()
                    }
                case .stored(_):
                    HStack(alignment: .top, spacing: 0) {
                        ForEach(StorageCategory.allCases, id: \.self) { category in
                            Button(action: {
                                viewModel.scholarshipCategoryButtonPressed(.stored(category))
                                withAnimation {
                                    proxy.scrollTo(viewModel.selectedScholarShipList.first?.id, anchor: .top)
                                }
                            }) {
                                detailHeaderButton(name: category.name, proxy: proxy)
                            }
                        }
                        Spacer()
                        Button {
                            viewModel.isShowFilteringSheet = true
                        } label: {
                            HStack(spacing: 0) {
                                Text(viewModel.filteringCategory.title)
                                    .font(.semi_title_md)
                                    .padding(.trailing, 4)
                                Icon(name: .arrowsUpDown, color: .gray500, size: 20)
                            }
                            .foregroundStyle(.gray500)
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            .paddingHorizontal()
        }
    }
    @ViewBuilder
    func detailHeaderButton(name: String, proxy: ScrollViewProxy) -> some View {
        VStack(spacing: 0) {
            Text(name)
                .font(.title_xsm)
                .foregroundStyle(viewModel.selectedCategoryDetailName == name ? .black : .gray400)
                .padding(.bottom, 8)
                .frame(width: 77)
                .overlay(alignment: .bottom) {
                    Rectangle()
                        .foregroundStyle(viewModel.selectedCategoryDetailName == name ? .black : .gray100)
                        .frame(height: 2)
                }
        }
    }
    @ViewBuilder
    func detailScholarshipBoxListView() -> some View {
        //TODO: TabView
        VStack(spacing: 0) {
            if viewModel.selectedScholarShipList.isEmpty {
                switch viewModel.selectedCategory {
                case.stored(_):
                    emptyView(title: "여깄장학과 함께 저장하고\n지원해보세요", content: "여깄장학과 함께 저장하고\n지원해보세요")
                case.supported(let category):
                    switch category {
                    case .applied:
                        emptyView(title: "아직 지원한 장학금이 없어요", content: "여깄장학과 함께 지원하고\n합격해보세요")
                    case .passed:
                        emptyView(title: "아직 합격한 장학금이 없어요", content: "여깄장학과 함께 지원하고\n합격해보세요")
                    case .non_passed:
                        emptyView(title: "불합격한 장학금이 없어요", content: nil)
                    }
                }
            } else {
                ScholarshipBoxListView(isGetMoreScholarshipBox: .constant(false), scholarshipList: $viewModel.selectedScholarShipList, boxCategory: .MyScholarship)
            }
            Spacer()
        }
    }
    @ViewBuilder
    private func filteringButton(category: MyScholarshipFilteringCategory) -> some View {
        HStack(spacing: 16) {
            Text(category.title)
                .foregroundStyle(category == viewModel.filteringCategory ? .subGreen : .gray700)
                .font(.title_xsm)
            Spacer()
            if category == viewModel.filteringCategory {
                Icon(name: .checkFat, color: .subGreen, size: 16)
            }
        }
        .padding(.vertical, 18)
        .contentShape(Rectangle())
        .onTapGesture {
            viewModel.sortingButtonPressed(category)
            viewModel.isShowFilteringSheet = false
        }
    }
    @ViewBuilder
    private func emptyView(title: String, content: String?) -> some View {
        VStack(spacing: 8) {
            Spacer()
            Icon(name: .grabPaper, color: .gray400, size: 122)
            Text(title)
                .multilineTextAlignment(.center)
                .font(.title_xsm)
                .foregroundStyle(.gray600)
            if let content {
                Text(content)
                    .multilineTextAlignment(.center)
                    .font(.text_sm)
                    .foregroundStyle(.gray600)
            }
            Spacer()
        }
    }
    @ViewBuilder
    private func filteringSheet() -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("정렬")
                .font(.title_xsm)
                .padding(.top, 20)
                .frame(maxWidth: .infinity)
            ForEach(MyScholarshipFilteringCategory.allCases, id: \.self) { category in
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
    @ViewBuilder
    private func error() -> some View {
        ZStack(alignment: .bottom) {
            VStack(spacing: 0) {
                Spacer()
                Button {
                    viewModel.reloadButtonPressed()
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

#Preview {
    MyScholarshipView()
}
