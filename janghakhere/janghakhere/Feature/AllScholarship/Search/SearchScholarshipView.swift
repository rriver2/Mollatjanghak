//
//  SearchScholarshipView.swift
//  janghakhere
//
//  Created by Gaeun Lee on 4/17/24.
//

import SwiftUI

struct SearchScholarshipView: View {
    @EnvironmentObject private var pathModel: PathModel
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = SearchScholarshipViewModel()
    @FocusState private var isKeyBoardOn: Bool
    @State var isGetMoreScholarshipBox = false
    
    let HeightRatio: CGFloat = (DeviceInfo.getDeviceScreenHeight()-332)/3
    
    var body: some View {
        VStack(spacing: 0) {
            navigation()
            switch viewModel.searchScholarshipStatus {
            case .notSearchedYet:
                recentSearched()
            case .loading:
                loading()
            case .searchedWithData:
                ScholarshipBoxListView(isGetMoreScholarshipBox: $isGetMoreScholarshipBox, scholarshipList: $viewModel.scholarshipList, boxCategory: .SearchScholarship, isShowPassStatus: false)
                    .onChange(of: viewModel.isGetMoreScholarshipBox, { _, _ in
                        userTouchedBottomOfTheScroll()
                    })
            case .searchedNoData:
                searchAgain()
            case .failed:
                error()
            }
        }
        .background(.gray50)
        .onAppear {
            isKeyBoardOn = true
            viewModel.viewOpened()
        }
        .onDisappear {
            viewModel.cancelTasks()
        }
        .navigationBarBackButtonHidden()
    }
}

extension SearchScholarshipView {
    @ViewBuilder
    func navigation() -> some View {
        HStack(spacing: 0) {
            Icon(name: .arrowLeft, color: .black, size: 28)
                .padding(.trailing, 10)
                .onTapGesture {
                    dismiss()
                }
            HStack(spacing: 0) {
                TextField(text: $viewModel.searchContent, label: {
                    Text("어떤 장학금을 찾으시나요?")
                        .font(.text_md)
                        .foregroundStyle(.gray500)
                })
                .font(.text_md)
                .foregroundStyle(.black)
                .submitLabel(.done)
                .frame(height: 24)
                .onSubmit {
                    viewModel.searchButtonPressed()
                }
                
                let isEmpty = viewModel.searchContent.isEmpty
                Icon(name: isEmpty ? .magnifyingGlass : .erace, color: .gray500, size: 24)
                    .onTapGesture {
                        if !isEmpty {
                            viewModel.searchbarXButtonPressed()
                        }
                    }
                    .padding(.leading, 8)
            }
            .focused($isKeyBoardOn)
            .accentColor(.black)
            .padding(.vertical, 12)
            .padding(.horizontal, 20)
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .background(.gray70)
            .cornerRadius(100)
        }
        .paddingHorizontal()
        .padding(.top, 12)
        .padding(.bottom, 16)
        .background(.white)
    }
    @ViewBuilder
    func recentSearched() -> some View {
        ZStack {
            VStack(spacing: 0) {
                HStack(spacing: 0) {
                    Text("최근 검색어")
                        .font(.semi_title_md)
                        .foregroundStyle(.gray800)
                    Spacer()
                    Button {
                        viewModel.removeAllSearchedScholarshipTextHistory()
                    } label: {
                        Text("전체 삭제")
                            .font(.text_sm)
                            .foregroundStyle(.gray500)
                    }
                }
                .padding(.bottom, 14)
                ChipsGroupView(viewModel: viewModel)
                
                Spacer()
            }
            .padding(.top, 17)
            IconAndAlert(icon: .paper, alertText: "전체 장학금 목록에서\n찾으시는 걸 보여드릴게요")
        }
        .paddingHorizontal()
    }
    @ViewBuilder
    func loading() -> some View {
        VStack(spacing: 0) {
            Spacer()
            ProgressView()
            Spacer()
        }
    }
    @ViewBuilder
    func searchAgain() -> some View {
        IconAndAlert(icon: .nothing, alertText:"공고를 발견하지 못했어요\n다른 키워드로 검색해 보는 건 어떨까요?")
    }
    @ViewBuilder
    func IconAndAlert(icon: ImageResource, alertText: String) -> some View {
        VStack(spacing: 0) {
            Icon(name: icon, color: .gray400, size: 122)
                .padding(.bottom, 8)
                .padding(.top, HeightRatio)
            Text(alertText)
                .font(.text_md)
                .foregroundStyle(.gray600)
                .multilineTextAlignment(.center)
            Spacer()
        }
    }
    @ViewBuilder
    func error() -> some View {
        VStack(spacing: 0) {
            Spacer()
            Icon(name: .graduation, size: 122)
                .padding(.bottom, 8)
            Text("정보를 불러오지 못하고 있어요")
                .font(.title_xsm)
                .padding(.bottom, 8)
                .foregroundStyle(.gray600)
            Text("인터넷 접속이 원활하지 않아요\n잠시 후에 다시 시도해 주세요")
                .font(.text_sm)
                .foregroundStyle(.gray600)
            Spacer()
        }
    }
}

extension SearchScholarshipView {
    /// 만약 currentCellCount이 5가 되면, 다음 View 불러오기
    private func userTouchedBottomOfTheScroll() {
        if viewModel.isGetMoreScholarshipBox {
            viewModel.bottomPartScrolled()
        }
    }
}

#Preview {
    SearchScholarshipView()
}
