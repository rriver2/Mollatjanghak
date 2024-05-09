//
//  OnboardingExtraView.swift
//  janghakhere
//
//  Created by Taehwan Kim on 5/1/24.
//

import SwiftUI

enum MilitaryStatus: String, CaseIterable, CustomStringConvertible, Codable {
    case served = "군필"
    case notServed = "미필"
    case exempt = "면제자"
    case notSelected = "선택 안 됨"
    
    var description: String {
        self.rawValue
    }
}

enum SiblingStatus: String, CaseIterable, CustomStringConvertible, Codable {
    case exist = "있음"
    case notExist = "없음"
    case notSelected = "선택 안 됨"
    
    var description: String {
        self.rawValue
    }
}


// FIXME: 온보딩 엑스트라 수정
struct OnboardingExtraView: View {
    @EnvironmentObject private var pathModel: PathModel
    @StateObject private var viewModel = OnboardingExtraViewModel()
    @Environment(\.dismiss) private var dismiss
    @State private var currentPage = 0
    var body: some View {
#if DEBUG
        if #available (iOS 17.1, *) {
            Self._printChanges()
        }
#endif
        return VStack(spacing: 0) {
            customNavigationToolbar()
            TabView(selection: $viewModel.currentPage) {
                militaryServiceContent()
                    .tag(0)
                siblingContent()
                    .tag(1)
                etcContent()
                    .tag(2)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
        }
        .task {
            viewModel.createView()
        }
        .onDisappear {
            viewModel.cancelTasks()
        }
    }
}

extension OnboardingExtraView {
    
    @ViewBuilder
    func etcContent() -> some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Spacer()
                Button {
                    // TODO: 다음에 입력
                } label: {
                    Text("다음에 입력할래요")
                        .foregroundStyle(.gray400)
                        .font(.text_sm)
                        .underline()
                }
            }
            .padding(.top, 16)
            Text("해당사항을 모두 선택해주세요")
                .font(.title_md)
                .foregroundStyle(.mainGray)
                .padding(.top, 23)
                .padding(.bottom, 30)
            ScrollView(.vertical) {
                OnboardingChipsGroup(viewModel: viewModel)
                    .padding(.top, 2)
            }
            Spacer()
            MainButtonView(
                title: "완료",
                action: {
                    withAnimation {
                        pathModel.paths.append(.onboardingExtraCompleteView)
                    }
                },
                disabled: false
            )
        }
        .paddingHorizontal()
    }
    
    @ViewBuilder
    func siblingContent() -> some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Spacer()
                Button {
                    // TODO: 다음에 입력
                } label: {
                    Text("다음에 입력할래요")
                        .foregroundStyle(.gray400)
                        .font(.text_sm)
                        .underline()
                }
            }
            .padding(.top, 16)
            Text("형제가 있으신가요?")
                .font(.title_md)
                .foregroundStyle(.mainGray)
                .padding(.top, 23)
                .padding(.bottom, 60)
            
            VerticalButtonGroup<SiblingStatus>(
                buttonList: SiblingStatus.allCases, selectedElement: $viewModel.siblingStatus
            )
            .padding(.vertical, 8)
            Spacer()
            MainButtonView(
                title: "다음",
                action: {
                    withAnimation {
                        viewModel.currentPage = 4
                    }
                },
                disabled: viewModel.siblingStatus == .notSelected
            )
        }
        .paddingHorizontal()
    }
    
    @ViewBuilder
    func militaryServiceContent() -> some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Spacer()
                Button {
                    // TODO: 다음에 입력
                } label: {
                    Text("다음에 입력할래요")
                        .foregroundStyle(.gray400)
                        .font(.text_sm)
                        .underline()
                }
            }
            .padding(.top, 16)
            
            Text("군대를 다녀오셨나요?")
                .font(.title_md)
                .foregroundStyle(.mainGray)
                .padding(.top, 23)
                .padding(.bottom, 60)
            
            VerticalButtonGroup<MilitaryStatus>(
                buttonList: MilitaryStatus.allCases, selectedElement: $viewModel.militaryStatus
            )
            .padding(.vertical, 8)
            Spacer()
            MainButtonView(
                title: "다음",
                action: {
                    withAnimation {
                        viewModel.currentPage = 3
                    }
                },
                disabled: viewModel.militaryStatus == .notSelected
            )
        }
        .paddingHorizontal()
    }
    
    @ViewBuilder
    func customNavigationToolbar() -> some View {
        HStack(spacing: 0) {
            Button {
                switch viewModel.currentPage {
                case 0:
                    withAnimation {
                        dismiss()
                    }
                default:
                    withAnimation {
                        viewModel.currentPage -= 1
                    }
                }
            } label: {
                Icon(
                    name: viewModel.currentPage == 0
                    ? .exit
                    : .arrowLeft,
                    color: .black, size: 28)
            }
            .padding(.trailing, 8)
            
            ProgressView(value: Double(viewModel.currentPage) * 0.25)
                .tint(.mainGray)
        }
        .paddingHorizontal()
    }
}

#Preview {
    OnboardingExtraView()
}
