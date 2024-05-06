//
//  OnboardingExtraView.swift
//  janghakhere
//
//  Created by Taehwan Kim on 5/1/24.
//

import SwiftUI

enum IncomeDecile: String, CaseIterable, CustomStringConvertible, Codable {
    case first = "1분위"
    case second = "2분위"
    case third = "3분위"
    case fourth = "4분위"
    case fifth = "5분위"
    case sixth = "6분위"
    case seventh = "7분위"
    case eighth = "8분위"
    case ninth = "9분위"
    case tenth = "10분위"
    case notSelected = "선택 안 됨"
    
    var description: String {
        self.rawValue
    }
}

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
                academicInfoContent()
                    .tag(0)
                incomeDecileContent()
                    .tag(1)
                militaryServiceContent()
                    .tag(2)
                siblingContent()
                    .tag(3)
                etcContent()
                    .tag(4)
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
    func incomeDecileContent() -> some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Spacer()
                Button {
                    
                } label: {
                    Text("다음에 입력할래요")
                        .foregroundStyle(.gray400)
                        .font(.text_sm)
                        .underline()
                }
            }
            .padding(.top, 16)
            
            Text("소득구간을 선택해 주세요")
                .font(.title_md)
                .foregroundStyle(.mainGray)
                .padding(.top, 23)
                .padding(.bottom, 60)
            
            GrayBoxGridView<IncomeDecile>(
                column: .two,
                titleList: IncomeDecile.allCases,
                action: {},
                selectedElement: $viewModel.incomeDecile
            )
            .padding(.vertical, 8)
            
            Spacer()
            HStack {
                Spacer()
                Button {
                    viewModel.isShowIncomeSheet = true
                } label: {
                    Text("소득구간을 잘 모르겠나요?")
                        .font(.text_md)
                        .foregroundStyle(.gray500)
                        .underline()
                }
                .sheet(isPresented: $viewModel.isShowIncomeSheet) {
                    IncomeConfirmView()
                }
                Spacer()
            }
            Spacer()
            
            MainButtonView(
                title: "다음",
                action: {
                    withAnimation {
                        viewModel.currentPage = 2
                    }
                },
                disabled: viewModel.incomeDecile == .notSelected
            )
        }
        .paddingHorizontal()
    }
    
    @ViewBuilder
    func academicInfoContent() -> some View {
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    Spacer()
                    Button {
                        // MARK: 다음에 입력할래요
                    } label: {
                        Text("다음에 입력할래요")
                            .foregroundStyle(.gray400)
                            .font(.text_sm)
                            .underline()
                    }
                }
                .padding(.top, 16)
                
                Text("학교 성적을 입력해 주세요")
                    .font(.title_md)
                    .foregroundStyle(.black)
                    .padding(.top, 23)
                    .padding(.bottom, 31)
                
                Text("직전학기 성적")
                    .font(.title_xsm)
                    .foregroundStyle(.gray600)
                    .padding(.vertical, 6)
                
                HStack {
                    GrayLineNumberFieldView(
                        number: $viewModel.previousGrade,
                        maxGradeStatus: $viewModel.maximumGrade
                    )
                    Text("/")
                        .font(.title_sm)
                        .foregroundStyle(.gray300)
                    HStack(spacing: 12) {
                        Text(viewModel.maximumGrade == .notApplicable ? "--" : viewModel.maximumGrade.rawValue)
                            .font(.title_sm)
                            .foregroundStyle(.black)
                        Image(systemName: "chevron.down")
                            .foregroundStyle(.gray500)
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(.gray60)
                    )
                    .onTapGesture {
                        viewModel.isShowGradeSheet = true
                    }
                    .sheet(isPresented: $viewModel.isShowGradeSheet) {
                        MaxGradeSheet(maxGrade: $viewModel.maximumGrade)
                    }
                    Text("점")
                        .font(.title_xmd)
                        .foregroundStyle(.black)
                }
                .padding(.bottom, 46)
                
                Text("전체학기 성적")
                    .font(.title_xsm)
                    .foregroundStyle(.gray600)
                    .padding(.vertical, 7)
                HStack {
                    GrayLineNumberFieldView(number: $viewModel.entireGrade, maxGradeStatus: $viewModel.maximumGrade)
                    Text("/")
                        .font(.title_sm)
                        .foregroundStyle(.gray300)
                    HStack(spacing: 12) {
                        Text(viewModel.maximumGrade == .notApplicable ? "--" : viewModel.maximumGrade.rawValue)
                            .font(.title_sm)
                            .foregroundStyle(.black)
                        Image(systemName: "chevron.down")
                            .foregroundStyle(.gray500)
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(.gray60)
                    )
                    .onTapGesture {
                        viewModel.isShowGradeSheet = true
                    }
                    .sheet(isPresented: $viewModel.isShowGradeSheet) {
                        MaxGradeSheet(maxGrade: $viewModel.maximumGrade)
                    }
                    Text("점")
                        .font(.title_xmd)
                        .foregroundStyle(.black)
                }
                .padding(.bottom, 46)
                
                Spacer()
                
                MainButtonView(
                    title: "다음",
                    action: {
                        withAnimation {
                            viewModel.currentPage = 1
                        }
                    },
                    disabled: viewModel.previousGrade == 0 || viewModel.entireGrade == 0
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
