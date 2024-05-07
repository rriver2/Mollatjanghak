//
//  OnboardingMainView.swift
//  janghakhere
//
//  Created by Taehwan Kim on 4/21/24.
//

import SwiftUI

enum SemesterStatus: String, CaseIterable, CustomStringConvertible, Codable {
    case first = "1학기"
    case second = "2학기"
    case extraSemester = "초과학기"
    case prospectiveStudent = "입학예정"
    case notSelected = "선택 안 됨"
    
    var description: String {
        self.rawValue
    }
}

enum MajorField: String, CaseIterable, CustomStringConvertible, Codable {
    case humanities = "인문"
    case socialsciences = "사회"
    case naturalSciences = "자연"
    case engineering = "공학"
    case arts = "예체능"
    case education = "교육"
    case medicalSciences = "의약"
    case others = "기타"
    case notSelected = "선택 안 됨"
    
    var description: String {
        self.rawValue
    }
}

enum DegreesStatus: String, CaseIterable, CustomStringConvertible, Codable {
    case bachelor = "학사"
    case master = "석사"
    case doctor = "박사"
    case notSelected = "선택 안 됨"
    
    var description: String {
        self.rawValue
    }
}

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

struct OnboardingMainView: View {
    @EnvironmentObject private var pathModel: PathModel
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = OnboardingMainViewModel()
    @FocusState private var isKeyboardOn: Bool
    @AppStorage("userName") private var userName: String = ""
    
    var filteredSemesterStatuses: [SemesterStatus] {
        switch viewModel.semesterYear {
        case .freshman:
            return [.first, .second, .prospectiveStudent]
        case .senior, .fifthYear:
            return [.first, .second, .extraSemester]
        default:
            return [.first, .second]
        }
    }
    
    var body: some View {
#if DEBUG
        if #available (iOS 17.1, *) {
            Self._printChanges()
        }
#endif
        return VStack(spacing: 0) {
            customNavigationToolbar()
            TabView(selection: $viewModel.currentPage) {
                nameContent()
                    .tag(0)
                sexContent()
                    .tag(1)
                birthContent()
                    .tag(2)
                studentContent()
                    .tag(3)
                schoolContent()
                    .tag(4)
                majorContent()
                    .tag(5)
                academicInfoContent()
                    .tag(6)
                incomeDecileContent()
                    .tag(7)
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

extension OnboardingMainView {
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
            
            ProgressView(value: Double(viewModel.currentPage) / 7)
                .tint(.mainGray)
        }
        .paddingHorizontal()
    }
    
    @ViewBuilder
    private func nameContent() -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("이름을 입력해 주세요")
                .font(.title_md)
                .foregroundStyle(.mainGray)
                .padding(.top, 60)
                .padding(.bottom, 64)
            
            GrayLineTextFieldView(
                text: $viewModel.name,
                placeHolder: "이름",
                isKeyBoardOn: isKeyboardOn
            )
            .focused($isKeyboardOn)
            Spacer()
            MainButtonView(
                title: "다음",
                action: {
                    isKeyboardOn = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        withAnimation {
                            viewModel.currentPage = 1
                        }
                    }
                },
                disabled: viewModel.name == ""
            )
            .padding(.vertical, 10)
        }
        .paddingHorizontal()
    }
    
    @ViewBuilder
    func sexContent() -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("성별이 어떻게 되시나요?")
                .font(.title_md)
                .foregroundStyle(.mainGray)
                .padding(.top, 60)
                .padding(.bottom, 36)
            SexSelectionView(sex: $viewModel.sex)
            Spacer()
            MainButtonView(
                title: "다음",
                action: {
                    withAnimation {
                        viewModel.currentPage = 2
                    }
                },
                disabled: viewModel.sex == .notSelected
            )
        }
        .paddingHorizontal()
    }
    
    @ViewBuilder
    func birthContent() -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("태어난 날짜를 입력해 주세요")
                .font(.title_md)
                .foregroundStyle(.black)
                .padding(.top, 60)
                .padding(.bottom, 64)
            VStack(spacing: 4) {
                HStack {
                    Text(viewModel.isEmptyDate(viewModel.birthDate)
                          ? "생년월일"
                         :  viewModel.birthDate.customDateFomatter())
                    .font(.title_md)
                    .foregroundStyle(
                        viewModel.isEmptyDate(
                            viewModel.birthDate
                        )
                        ? .gray300
                        : .mainGray)
                    Spacer()
                    Image("chevronDown")
                        .font(.system(size: 16))
                        .foregroundStyle(.gray500)
                }
                .background {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(.clear)
                        .contentShape(Rectangle())
                }
                .onTapGesture {
                    $viewModel.isShowBirthdaySheet.wrappedValue = true
                }
                .sheet(isPresented: $viewModel.isShowBirthdaySheet) {
                    DateSelectionView(date: $viewModel.birthDate)
                }
                Rectangle()
                    .foregroundStyle(
                        viewModel.isEmptyDate(
                            $viewModel.birthDate.wrappedValue
                        )
                        ? .gray300
                        : .mainGray)
                    .frame(height: 1)
            }
            Spacer()
            MainButtonView(
                title: "다음",
                action: {
                    withAnimation {
                        viewModel.currentPage = 3
                    }
                },
                disabled: viewModel.isEmptyDate(
                    $viewModel.birthDate.wrappedValue
                )
            )
        }
        .paddingHorizontal()
    }
    
    @ViewBuilder
     private func studentContent() -> some View {
         VStack(alignment: .leading, spacing: 20) {
             Text("학교를 다니는 중이신가요?")
                 .font(.title_md)
                 .foregroundStyle(.mainGray)
                 .padding(.top, 60)
                 .padding(.bottom, 21)
             
             VStack(alignment: .leading, spacing: 0) {
                 Text("학교")
                     .font(.title_xsm)
                     .foregroundStyle(.gray600)
                     .padding(.bottom, 12)
                     .padding(.leading, 4)
                 
                 VerticalButtonGroup<DegreesStatus>(
                    buttonList: DegreesStatus.allCases,
                    selectedElement: $viewModel.degreesStatus
                 )
             }
             
             if viewModel.degreesStatus != .notSelected {
                 VStack(alignment: .leading, spacing: 0) {
                     Text("재학상태")
                         .font(.title_xsm)
                         .foregroundStyle(.gray600)
                         .padding(.top, 36)
                         .padding(.bottom, 12)
                         .padding(.leading, 4)
                     
                     EnrollmentStatusGrid(
                        titleList: EnrollmentStatus.allCases,
                        selectedElement: $viewModel.enrollmentStatus,
                        degreesStatus: $viewModel.degreesStatus
                     )
                 }
             }
             
             Spacer()
             MainButtonView(
                 title: "다음",
                 action: {
                     withAnimation {
                         viewModel.currentPage = 4
                     }
                 },
                 disabled: viewModel.degreesStatus == .notSelected || viewModel.enrollmentStatus == .notSelected
             )
         }
         .paddingHorizontal()
    }
    
    @ViewBuilder
    func schoolContent() -> some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("학교 정보를 입력해 주세요")
                .font(.title_md)
                .foregroundStyle(.mainGray)
                .padding(.top, 60)
                .padding(.bottom, 21)
            
            VStack(alignment: .leading, spacing: 0) {
                Text("학교")
                    .font(.title_xsm)
                    .foregroundStyle(.gray600)
                    .overlay(alignment: .topLeading) {
                        Circle()
                            .fill(.destructiveRed)
                            .frame(width: 6, height: 6)
                            .offset(x: -6, y: -6)
                    }
                    .padding(.horizontal, 6)
                GrayLineTextFieldView(
                    text: $viewModel.schoolName,
                    placeHolder: "여깄대학교",
                    isKeyBoardOn: isKeyboardOn
                )
                .padding(.vertical, 10)
                .autocorrectionDisabled()
                .focused($isKeyboardOn)
            }
            .padding(.vertical, 10)
            
            VStack(alignment: .leading, spacing: 0) {
                Text("학년")
                    .font(.title_xsm)
                    .foregroundStyle(.gray600)
                    .overlay(alignment: .topLeading) {
                        Circle()
                            .fill(.destructiveRed)
                            .frame(width: 6, height: 6)
                            .offset(x: -6, y: -6)
                    }
                    .padding(.horizontal, 6)
                HStack {
                    Text(viewModel.semesterYear.description)
                        .font(.title_md)
                        .foregroundStyle(
                            $viewModel.semesterYear.wrappedValue == .notSelected
                            ? .gray300
                            : .mainGray)
                    Spacer()
                    Image("chevronDown")
                        .font(.system(size: 20))
                        .foregroundStyle(.gray500)
                }
                .padding(.horizontal, 4)
                .padding(.top, 8)
                .padding(.bottom, 4)
                .background {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(.clear)
                        .contentShape(Rectangle())
                }
                .onTapGesture {
                    isKeyboardOn = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        viewModel.isShowSemesterSheet = true
                    }
                    
                }
                .sheet(isPresented: $viewModel.isShowSemesterSheet) {
                    SemesterYearSelectionView(
                        year: $viewModel.semesterYear
                    )
                }
                Rectangle()
                    .foregroundStyle(
                        .gray300)
                    .frame(height: 1)
                    .padding(.vertical, 10)
            }
            .padding(.vertical, 10)
            
            
            VStack(alignment: .leading, spacing: 0) {
                Text("학기")
                    .font(.title_xsm)
                    .foregroundStyle(.gray600)
                    .overlay(alignment: .topLeading) {
                        Circle()
                            .fill(.destructiveRed)
                            .frame(width: 6, height: 6)
                            .offset(x: -6, y: -6)
                    }
                    .padding(.horizontal, 6)
                
                LazyVGrid(
                    columns: Array(repeating: GridItem(.flexible(), spacing: 16, alignment: .leading), count: 3),
                    spacing: 16
                ) {
                    ForEach(filteredSemesterStatuses, id: \.self) { title in
                        Button {
                            viewModel.semesterStatus = title // 상태 변경
                        } label: {
                            Text(title.description)
                                .font(.title_xsm)
                                .padding(.vertical, 13)
                                .foregroundColor(
                                    viewModel.semesterStatus == title
                                    ? .white
                                    : .gray600)
                                .frame(maxWidth: .infinity)
                                .background(
                                    viewModel.semesterStatus == title
                                    ? Color.mainGray
                                    : Color.gray70)
                                .cornerRadius(4)
                        }
                    }
                }
                .padding(.vertical, 10)
            }
            .padding(.vertical, 10)
            
            Spacer()
            
            MainButtonView(
                title: "다음",
                action: {
                    withAnimation {
                        viewModel.currentPage = 5
                    }
                },
                disabled: viewModel.schoolName == "" || viewModel.semesterYear == .notSelected || viewModel.semesterStatus == .notSelected
            )
        }
        .paddingHorizontal()
    }
    
    @ViewBuilder
    private func majorContent() -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("전공계열을 알려주세요")
                .font(.title_md)
                .foregroundStyle(.mainGray)
                .padding(.top, 60)
                .padding(.bottom, 64)
            
            GrayBoxGridView(
                column: .two,
                titleList: MajorField.allCases,
                action: {},
                selectedElement: $viewModel.majorField
            )
            
            Spacer()
            
            MainButtonView(
                title: "다음",
                action: {
                    withAnimation {
                        viewModel.currentPage = 6
                    }
                },
                disabled: false
            )
        }
        .paddingHorizontal()
    }
    
    
//    @ViewBuilder
//    private func extraContent() -> some View {
//        VStack(alignment: .leading, spacing: 0) {
//            HStack {
//                Spacer()
//                Button {
//                    // TODO: 다음에 입력
//                } label: {
//                    Text("다음에 입력할래요")
//                        .foregroundStyle(.gray400)
//                        .font(.text_sm)
//                        .underline()
//                }
//            }
//            .padding(.top, 16)
//            
//            Text("해당사항을 모두 선택해주세요")
//                .font(.title_md)
//                .foregroundStyle(.mainGray)
//                .padding(.top, 24)
//                .padding(.bottom, 64)
//            Spacer()
//            MainButtonView(
//                title: "완료",
//                action: {
//                    isKeyboardOn = false
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//                        withAnimation {
//                            viewModel.currentPage = 1
//                        }
//                    }
//                },
//                disabled: viewModel.name == ""
//            )
//        }
//        .paddingHorizontal()
//    }
    
    @ViewBuilder
    func academicInfoContent() -> some View {
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    Spacer()
                    Button {
                        withAnimation {
                            viewModel.currentPage += 1
                        }
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
                            viewModel.currentPage = 7
                        }
                    },
                    disabled: viewModel.previousGrade == 0 || viewModel.entireGrade == 0
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
                    viewModel.saveUserData()
                    withAnimation {
                        pathModel.paths.append(.onboardingWaitingView(
                            userData: viewModel.makeUserData()
                        )
                        )
                    }
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
                    viewModel.saveUserData()
                    withAnimation {
                        pathModel.paths.append(.onboardingWaitingView(
                            userData: viewModel.makeUserData()
                        )
                        )
                    }
                    
                },
                disabled: viewModel.incomeDecile == .notSelected
            )
        }
        .paddingHorizontal()
    }
}

#Preview {
    OnboardingMainView()
}
