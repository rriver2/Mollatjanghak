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
                VStack(spacing: 0) {
                    header(proxy: proxy)
                    detailHeader(proxy: proxy)
                    detailScholarshipBoxListView()
                }
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
            ForEach(MyScholarshipCategory.allCases, id: \.self) { category in
                Button {
                    viewModel.scholarshipCategoryButtonPressed(category)
                    withAnimation {
                        for data in viewModel.detailCategoryDictionaryData {
                            proxy.scrollTo(data.scholarshipBoxList.first?.id, anchor: .top)
                        }
                    }
                } label: {
                    Text(category.name)
                        .font(.title_md)
                        .foregroundStyle(category == viewModel.scholarshipCategory ? .mainGray : .gray300)
                        .padding(.trailing, 16)
                }
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
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .top, spacing: 0) {
                    ForEach(viewModel.detailCategoryDictionaryData, id: \.self) { category in
                        Button(action: {
                            viewModel.selectedDetailCategoryName = category.name
                            withAnimation {
                                for data in viewModel.detailCategoryDictionaryData {
                                    proxy.scrollTo(data.scholarshipBoxList.first?.id, anchor: .top)
                                }
                            }
                        }) {
                            VStack(spacing: 0) {
                                Text(category.name)
                                    .font(.title_xsm)
                                    .foregroundStyle( viewModel.selectedDetailCategoryName == category.name ? .black : .gray400)
                                    .padding(.bottom, 8)
                                    .frame(width: 77)
                                    .overlay(alignment: .bottom) {
                                        Rectangle()
                                            .foregroundStyle( viewModel.selectedDetailCategoryName == category.name ? .black : .clear)
                                            .frame(height: 2)
                                    }
                            }
                        }
                    }
                }
            }
            .paddingHorizontal()
            Rectangle()
                .foregroundStyle(.gray100.opacity(0.5))
                .frame(height: 2)
                .frame(maxWidth: .infinity)
        }
    }
    @ViewBuilder
    func detailScholarshipBoxListView() -> some View {
        TabView(selection: $viewModel.selectedDetailCategoryName) {
            ForEach(viewModel.detailCategoryDictionaryData, id: \.self.name) { scholarship in
                let supportedCategory: SupportedCategory? = viewModel.scholarshipCategory == .storaged ? nil : SupportedCategory.allCases.first { $0.name == scholarship.name }
                ScholarshipBoxListView(isGetMoreScholarshipBox: .constant(false), scholarshipList: scholarship.scholarshipBoxList, supportedCategory: supportedCategory)
                    .tag(scholarship.name)
            }
        }
        .animation(.easeIn, value: viewModel.scholarshipCategory)
        .tabViewStyle(.page)
        .onAppear {
            UIPageControl.appearance().currentPageIndicatorTintColor = .clear
            UIPageControl.appearance().pageIndicatorTintColor = .clear
        }
    }
}

#Preview {
    MyScholarshipView()
}
