//
//  OnboardingMainView.swift
//  janghakhere
//
//  Created by Taehwan Kim on 4/21/24.
//

import SwiftUI

import SwiftUI

struct OnboardingMainView: View {
    @EnvironmentObject private var pathModel: PathModel
    @StateObject private var viewModel = OnboardingMainViewModel()
    @State private var value: Double = 0.166 * 1
    @State private var name: String = ""
    @State private var gender: Gender = .notSelected
    @State private var date: Date = .now
    @State private var isShowSheet = false
    @State private var isShowSemesterSheet = false
    @State private var schoolName: String = ""
    @State private var semesterStatus: SemesterYear = .notSelected
    var body: some View {
#if DEBUG
        if #available (iOS 17.1, *) {
            Self._printChanges()
        }
#endif
        return VStack(spacing: 0) {
            customNavigationToolbar(value: value)
            //                        nameContent(name: name)
            //                        genderContent(gender: gender)
            //                        birthContent(date: $date, isShowSheet: $isShowSheet)
            schoolContent(
                schoolName: $schoolName,
                semesterStatus: $semesterStatus,
                isShowSheet: $isShowSemesterSheet
            )
        }
        .task {
            viewModel.createView()
        }
        .onDisappear {
            viewModel.cancelTasks()
        }
    }
}

extension OnboardingMainView {
    
    @ViewBuilder
    func schoolContent(
        schoolName: Binding<String>,
        semesterStatus: Binding<SemesterYear>,
        isShowSheet: Binding<Bool>
    ) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("학교 정보를 입력해 주세요")
                .font(.title_md)
                .foregroundStyle(.mainGray)
                .padding(.top, 60)
                .padding(.bottom, 31)
            
            GeometryReader { geometry in
                VStack(alignment: .leading, spacing: 0) {
                    HStack {
                        Circle()
                            .fill(.destructiveRed)
                            .frame(
                                width: geometry.size.width * 0.03,
                                height: geometry.size.height * 0.03
                            )
                            .offset(
                                x: geometry.size.width * 0.02,
                                y: -geometry.size.height * 0.07
                            )
                        Text("학교")
                            .font(.title_xsm)
                            .foregroundStyle(.gray600)
                    }
                    GrayLineTextFieldView(
                        text: $schoolName,
                        placeHolder: "여깄대학교"
                    )
                    .padding(.horizontal, 10)
                    .padding(.vertical, 8)
                }
            }
            
            GeometryReader { geometry in
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Circle()
                            .fill(.destructiveRed)
                            .frame(
                                width: geometry.size.width * 0.03,
                                height: geometry.size.height * 0.03
                            )
                            .offset(
                                x: geometry.size.width * 0.02,
                                y: -geometry.size.height * 0.07
                            )
                        Text("학년(석/박사)")
                            .font(.title_xsm)
                            .foregroundStyle(.gray600)
                    }
                    HStack {
                        Text(semesterStatus.wrappedValue.getYearText())
                            .font(.title_md)
                            .foregroundStyle(
                                semesterStatus.wrappedValue == .notSelected
                                ? .gray300
                                : .mainGray)
                        Spacer()
                        Image(systemName: "chevron.down")
                            .font(.system(size: 20))
                            .foregroundStyle(.gray500)
                    }
                    .padding(.horizontal, 10)
                    .padding(.top, 8)
                    .padding(.bottom, 4)
                    .background {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(.clear)
                            .contentShape(Rectangle())
                    }
                    .onTapGesture {
                        isShowSemesterSheet = true
                    }
                    .sheet(isPresented: $isShowSemesterSheet) {
                        SemesterYearSelectionView(
                            year: $semesterStatus
                        )
                    }
                    Rectangle()
                        .foregroundStyle(
                            semesterStatus.wrappedValue == .notSelected
                            ? .gray300
                            : .mainGray)
                        .frame(height: 1)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 0)
                }
            }
            
            GeometryReader { geometry in
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Circle()
                            .fill(.destructiveRed)
                            .frame(
                                width: geometry.size.width * 0.03,
                                height: geometry.size.height * 0.03
                            )
                            .offset(
                                x: geometry.size.width * 0.02,
                                y: -geometry.size.height * 0.07
                            )
                        Text("학기")
                            .font(.title_xsm)
                            .foregroundStyle(.gray600)
                    }
                    GrayBoxGridView(column: .three, titleList: ["1학기", "2학기"], clickedButton: {}, selectedElement: $name)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 8)
                }
            }
            
            GeometryReader { geometry in
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Circle()
                            .fill(.destructiveRed)
                            .frame(
                                width: geometry.size.width * 0.03,
                                height: geometry.size.height * 0.03
                            )
                            .offset(
                                x: geometry.size.width * 0.02,
                                y: -geometry.size.height * 0.07
                            )
                        Text("재학여부")
                            .font(.title_xsm)
                            .foregroundStyle(.gray600)
                    }
                    GrayBoxGridView(column: .three, titleList: ["재학", "휴학", "유예"], clickedButton: {}, selectedElement: $name)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 8)
                }
            }
            
            Spacer()
            
            MainButtonView(
                title: "다음",
                action: {},
                disabled: false
            )
            .padding(.horizontal, 11)
        }
        .padding()
    }
    
    @ViewBuilder
    func birthContent(
        date: Binding<Date>,
        isShowSheet : Binding<Bool>
    ) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("태어난 날짜를 입력해 주세요")
                .font(.title_md)
                .foregroundStyle(.mainGray)
                .padding(.top, 60)
                .padding(.bottom, 64)
            VStack(spacing: 4) {
                HStack {
                    Text( viewModel.isEmptyDate(date.wrappedValue)
                          ? "생년월일"
                          : date.wrappedValue.customDateFomatter())
                    .font(.title_md)
                    .foregroundStyle(
                        viewModel.isEmptyDate(
                            date.wrappedValue
                        )
                        ? .gray300
                        : .mainGray)
                    Spacer()
                    Image(systemName: "chevron.down")
                        .font(.system(size: 20))
                        .foregroundStyle(.gray500)
                }
                .background {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(.clear)
                        .contentShape(Rectangle())
                }
                .onTapGesture {
                    isShowSheet.wrappedValue = true
                }
                .sheet(isPresented: $isShowSheet) {
                    DateSelectionView(date: $date)
                }
                Rectangle()
                    .foregroundStyle(
                        viewModel.isEmptyDate(
                            date.wrappedValue
                        )
                        ? .gray300
                        : .mainGray)
                    .frame(height: 1)
            }
            Spacer()
            MainButtonView(
                title: "다음",
                action: {},
                disabled: viewModel.isEmptyDate(date.wrappedValue)
            )
            .padding(.horizontal, 11)
        }
        .padding()
    }
    
    @ViewBuilder
    func customNavigationToolbar(value: Double) -> some View {
        HStack(spacing: 0) {
            Button {
                // pathModel.paths.removeLast()
            } label: {
                Image(systemName: "arrow.left")
                    .foregroundStyle(.mainGray)
                    .font(.system(size: 28))
                    .padding(.leading, 20)
            }
            ProgressView(value: value)
                .tint(.mainGray)
                .padding()
        }
    }
    @ViewBuilder
    private func nameContent(name: String) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("이름을 입력해 주세요")
                .font(.title_md)
                .foregroundStyle(.mainGray)
                .padding(.top, 60)
                .padding(.bottom, 64)
            
            GrayLineTextFieldView(text: $name, placeHolder: "이름")
            Spacer()
            MainButtonView(
                title: "다음",
                action: {},
                disabled: name == ""
            )
            .padding(.horizontal, 11)
        }
        .padding()
    }
    
    @ViewBuilder
    func genderContent(gender: Gender) -> some View {
        
        VStack(alignment: .leading, spacing: 0) {
            Text("성별이 어떻게 되시나요?")
                .font(.title_md)
                .foregroundStyle(.mainGray)
                .padding(.top, 60)
                .padding(.bottom, 36)
            GenderSelectionView(gender: $gender)
            Spacer()
            
            MainButtonView(
                title: "다음",
                action: {},
                disabled: gender == .notSelected
            )
            .padding(.horizontal, 11)
        }
        .padding()
    }
    
    @ViewBuilder
    func subView() -> some View {
        VStack(spacing: 0) {
            Text("OnboardingMainView")
        }
    }
}

#Preview {
    OnboardingMainView()
}
