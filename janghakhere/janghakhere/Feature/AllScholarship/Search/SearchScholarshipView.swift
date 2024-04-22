//
//  SearchScholarshipView.swift
//  janghakhere
//
//  Created by Gaeun Lee on 4/17/24.
//

import SwiftUI

struct SearchScholarshipView: View {
    @EnvironmentObject private var pathModel: PathModel
    @StateObject private var viewModel = SearchScholarshipViewModel()
    @FocusState private var isKeyBoardOn: Bool
    
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
                ScholarshipBoxListView(scholarshipList: viewModel.scholarshipList)
            case .searchedNoData:
                searchAgain()
            case .failed:
                Text("알 수 없는 에러가 발생했습니다.")
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
                    pathModel.paths.removeLast()
                }
            HStack(spacing: 0) {
                TextField(text: $viewModel.searchContent, label: {
                    Text("어떤 장학금을 찾으시나요?")
                })
                .font(.text_md)
                .foregroundStyle(.black)
                .submitLabel(.done)
                .onSubmit {
                    viewModel.searchButtonPressed()
                }
                if !viewModel.searchContent.isEmpty {
                    Icon(name: .erace, color: .gray500, size: 24)
                        .onTapGesture {
                            viewModel.searchbarXButtonPressed()
                        }
                        .padding(.leading, 8)
                } else {
                    Icon(name: .magnifyingGlass, color: .gray500, size: 24)
                }
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
                .padding(.bottom, 19)
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
            Icon(name: icon, color: .gray500, size: 122)
                .padding(.bottom, 8)
                .padding(.top, HeightRatio)
            Text(alertText)
                .font(.text_md)
                .foregroundStyle(.gray600)
                .multilineTextAlignment(.center)
            Spacer()
        }
    }
}

#Preview {
    SearchScholarshipView()
}
