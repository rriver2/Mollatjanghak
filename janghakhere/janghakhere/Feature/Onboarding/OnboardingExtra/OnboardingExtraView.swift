//
//  OnboardingExtraView.swift
//  janghakhere
//
//  Created by Taehwan Kim on 5/1/24.
//

import SwiftUI

struct OnboardingExtraView: View {
    @EnvironmentObject private var pathModel: PathModel
    @StateObject private var viewModel = OnboardingExtraViewModel()
    @Environment(\.dismiss) private var dismiss
    var body: some View {
#if DEBUG
        if #available (iOS 17.1, *) {
            Self._printChanges()
        }
#endif
        return VStack(spacing: 0) {
            customNavigationToolbar()
//            academicInfoContent()
//            incomeDecileContent()
//            militaryServiceContent()
//            siblingContent()
            
            Spacer()
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
                action: {},
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
                action: {},
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
            .padding(0)
            
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
                action: {},
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
                .padding(0)
                
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
//                VStack(alignment: .leading, spacing: 0) {
//                    Text("전공계열")
//                        .font(.title_xsm)
//                        .foregroundStyle(.gray600)
//                        .padding(.vertical, 12)
//                    
//                    GrayBoxGridView<MajorField>(
//                        column: .three,
//                        titleList: MajorField.allCases,
//                        action: {},
//                        selectedElement: $viewModel.majorField
//                    )
//                    .padding(.vertical, 8)
//                }
                Spacer()
                MainButtonView(
                    title: "다음",
                    action: {},
                    disabled: false
                )
            }
            .paddingHorizontal()
    }
    
    
    @ViewBuilder
    func customNavigationToolbar() -> some View {
        HStack(spacing: 0) {
            Icon(name: .arrowLeft, color: .black, size: 28)
                .padding(.trailing, 8)
                .onTapGesture {
                    dismiss()
                }
            
            ProgressView(value: Double(viewModel.progressValue) * 0.2)
                .tint(.mainGray)
        }
        .paddingHorizontal()
    }
    
}

#Preview {
    OnboardingExtraView()
}
