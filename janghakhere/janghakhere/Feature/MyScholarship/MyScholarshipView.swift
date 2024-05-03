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
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollViewReader { proxy in
                header(proxy: proxy)
                detailHeader(proxy: proxy)
                detailScholarshipBoxListView()
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
                viewModel.scholarshipCategoryButtonPressed(.supported(.supportCompleted))
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
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .top, spacing: 0) {
                    switch viewModel.selectedCategory {
                    case .supported(_):
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
                    case .stored(_):
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
                    }
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
            ScholarshipBoxListView(isGetMoreScholarshipBox: .constant(false), scholarshipList: $viewModel.selectedScholarShipList)
            Spacer()
        }
    }
}

#Preview {
    MyScholarshipView()
}
