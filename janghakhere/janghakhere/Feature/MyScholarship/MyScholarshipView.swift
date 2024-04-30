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


//
//  MyScholarshipViewModel.swift
//  janghakhere
//
//  Created by Gaeun Lee on 4/28/24.
//

import SwiftUI

enum MyScholarshipCategory: CaseIterable {
    case storaged
    case supported
    
    var name: String {
        switch self {
        case .storaged:
            "저장 공고"
        case .supported:
            "지원 공고"
        }
    }
}

enum StorageCategory: String, CaseIterable {
    case all
    case inProgress
    case closing

    var id: String {
        self.rawValue
    }
    
    var name: String {
        switch self {
        case .all:
            "전체"
        case .inProgress:
            "진행중"
        case .closing:
            "마감"
        }
    }
    
    func getCategory(_ id: String) -> StorageCategory {
        return StorageCategory.allCases.first { category in
            category.id == self.id
        }!
    }
    
    var allCasesId: [String] {
        return StorageCategory.allCases.map { $0.rawValue }
    }
    
    var allCasesName: [String] {
        return StorageCategory.allCases.map { $0.name }
    }
}

enum SupportedCategory: String, CaseIterable {
    case completedApplication
    case passed
    case failed
    
    var id: String {
        self.rawValue
    }
    
    var name: String {
        switch self {
        case .completedApplication:
            "지원완료"
        case .passed:
            "합격"
        case .failed:
            "불합격"
        }
    }
    
    var buttonTextColor: Color {
        switch self {
        case .completedApplication:
                Color.black
        case .passed:
            Color.subGreen
        case .failed:
            Color(hex: "FF6464") ?? .black
        }
    }
    
    var buttonBackgroundColor: Color {
        switch self {
        case .completedApplication:
                Color.black
        case .passed:
            Color(hex: "37C084")?.opacity(0.08) ?? .black
        case .failed:
            Color(hex: "FF6464")?.opacity(0.08) ?? .black
        }
    }
    
    func getCategory(_ id: String) -> SupportedCategory {
        return SupportedCategory.allCases.first { category in
            category.id == self.id
        }!
    }
    
    var allCasesId: [String] {
        return SupportedCategory.allCases.map { $0.rawValue }
    }
    
    var allCasesName: [String] {
        return SupportedCategory.allCases.map { $0.name }
    }
}

@MainActor
final class MyScholarshipViewModel: ObservableObject {
    let scholarshipBoxListActor: ScholarshipBoxListActor = ScholarshipBoxListActor()
    
    @Published private(set) var scholarshipCategory: MyScholarshipCategory = .storaged
    // 임의의 수 넣어줘야 함
    @Published var detailCategoryDictionaryData: [categoryData] = categoryData.mockData1
    @Published var selectedDetailCategoryName: String = "전체"
    
    struct categoryData: Hashable {
        let name: String
        let scholarshipBoxList: [ScholarshipBox]
        
        static let mockData1 = [
            categoryData(name: "전체", scholarshipBoxList: [ScholarshipBox.mockAllData, ScholarshipBox.mockAllData, ScholarshipBox.mockAllData, ScholarshipBox.mockAllData, ScholarshipBox.mockAllData, ScholarshipBox.mockAllData]),
            categoryData(name: "진행중", scholarshipBoxList: [ScholarshipBox.mockCustomData, ScholarshipBox.mockCustomData, ScholarshipBox.mockCustomData, ScholarshipBox.mockCustomData, ScholarshipBox.mockCustomData, ScholarshipBox.mockCustomData]),
            categoryData(name: "마감", scholarshipBoxList: [ScholarshipBox.mockAllData, ScholarshipBox.mockAllData, ScholarshipBox.mockAllData, ScholarshipBox.mockAllData, ScholarshipBox.mockAllData, ScholarshipBox.mockAllData])
        ]
        
        static let mockData2 = [
            categoryData(name: "지원완료", scholarshipBoxList: [ScholarshipBox.mockAllData, ScholarshipBox.mockAllData, ScholarshipBox.mockAllData, ScholarshipBox.mockAllData, ScholarshipBox.mockAllData, ScholarshipBox.mockAllData]),
            categoryData(name: "합격", scholarshipBoxList: [ScholarshipBox.mockCustomData, ScholarshipBox.mockCustomData, ScholarshipBox.mockCustomData, ScholarshipBox.mockCustomData, ScholarshipBox.mockCustomData, ScholarshipBox.mockCustomData]),
            categoryData(name: "불합격", scholarshipBoxList: [ScholarshipBox.mockAllData, ScholarshipBox.mockAllData, ScholarshipBox.mockAllData, ScholarshipBox.mockAllData, ScholarshipBox.mockAllData, ScholarshipBox.mockAllData])
        ]
    }
    
    private var tasks: [Task<Void, Never>] = []
    
    /// header의 저장, 지원 공고 버튼 클릭
    func scholarshipCategoryButtonPressed(_ category : MyScholarshipCategory) {
        // detailCategoryDictionaryData 값 변경 시키기
        switch category {
        case .storaged:
            self.detailCategoryDictionaryData = categoryData.mockData1
        case .supported:
            self.detailCategoryDictionaryData = categoryData.mockData2
        }
        self.scholarshipCategory = category
        self.selectedDetailCategoryName = detailCategoryDictionaryData.first?.name ?? "지원완료"
    }
    
    // sorting 최신,
    func sortingButtonPressed() {
        
    }
}

// private 함수들
extension MyScholarshipViewModel {
    private func getScholarShipList(_ category : MyScholarshipCategory) {
        
        
    }
}

// 기본 함수들
extension MyScholarshipViewModel {
    func viewOpened() {
        self.getScholarShipList(scholarshipCategory)
    }
    
    func cancelTasks() {
        tasks.forEach({ $0.cancel()})
        tasks = []
    }
}
