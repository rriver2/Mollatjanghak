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

enum Field: Hashable {
  case first
  case second
}

struct OnboardingItem: Identifiable {
    let id = UUID()
    let title: String
}

extension AnyTransition {
    static var bottomFadeIn: AnyTransition {
        AnyTransition.asymmetric(
            insertion: 
                AnyTransition.offset(x:0, y: 40)
                .combined(with: AnyTransition.opacity.animation(.easeIn(duration: 0.5))),
            removal: AnyTransition.opacity
        )
    }
}

struct OnboardingMainView: View {
    @EnvironmentObject private var pathModel: PathModel
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = OnboardingMainViewModel()
    @FocusState private var isKeyboardOn: Bool
    @AppStorage("userName") private var userName: String = ""
    @FocusState var isNumKeyboardOn: Field?
    @State var currentIndex: Int = 0
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
            GeometryReader {
                let size = $0.size
                HStack(spacing: 0) {
                    ForEach(viewModel.onboardingItems) { item in
                        VStack(alignment: .leading, spacing: 0) {
                            
                            let offset = -CGFloat(currentIndex) * size.width
                            
                            Text(item.title)
                                .font(.title_md)
                                .foregroundStyle(.black)
                                .padding(.top, 60)
                                .offset(x: offset)
                                .animation(.easeInOut(duration: 0.2), value: currentIndex)

                            Group {
                                switch currentIndex {
                                case 0:
                                    nameContent()
                                        .padding(.top, 64)
                                case 1:
                                    sexContent()
                                        .padding(.top, 36)
                                case 2:
                                    birthContent()
                                        .padding(.top, 64)
                                case 3:
                                    studentContent()
                                        .padding(.top, 36)
                                case 4:
                                    schoolContent()
                                        .padding(.top, 36)
                                case 5:
                                    majorContent()
                                        .padding(.top, 48)
                                case 6:
                                    academicInfoContent()
                                        .padding(.top, 34)
                                case 7:
                                    incomeDecileContent()
                                        .padding(.top, 34)
                                default:
                                    EmptyView()
                                }
                            }
                            .transition(.bottomFadeIn)
                            .animation(.easeIn(duration: 0.3), value: currentIndex)
                            
                            Spacer()
                            MainButtonView(
                                title: currentIndex == 7 ? "완료" : "다음",
                                action: {
                                    isKeyboardOn = false
                                    if currentIndex < viewModel.onboardingItems.count - 1 {
                                        currentIndex += 1
                                    }
                                    if currentIndex == 7 {
                                        viewModel.saveUserData()
                                        withAnimation {
                                            pathModel.paths.append(
                                                .onboardingWaitingView(
                                                    userData: viewModel.makeUserData()
                                                )
                                            )
                                        }
                                    }
                                },
                                disabled: {
                                    switch currentIndex {
                                    case 0:
                                        return viewModel.name.isEmpty
                                    case 1:
                                        return viewModel.sex == .notSelected
                                    case 2:
                                        return viewModel.isEmptyDate(viewModel.birthDate)
                                    case 3:
                                        return viewModel.degreesStatus == .notSelected || viewModel.enrollmentStatus == .notSelected
                                    case 4:
                                        return viewModel.schoolName.isEmpty || viewModel.semesterYear == .notSelected || viewModel.semesterStatus == .notSelected
                                    case 5:
                                        return viewModel.majorField == .notSelected
                                    case 6:
                                        return viewModel.previousGrade == 0 || viewModel.entireGrade == 0
                                    case 7:
                                        return viewModel.incomeDecile == .notSelected
                                    default:
                                        return false
                                    }
                                }()
                            )
                            .padding(.vertical, 10)
                        }
                        .paddingHorizontal()
                        .frame(
                            width: size.width,
                            height: size.height
                        )
                    }
                    
                }
                .frame(
                    width: size.width * CGFloat(viewModel.onboardingItems.count), 
                    alignment: .leading
                )
            }
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
                switch currentIndex {
                case 0:
                    withAnimation {
                        dismiss()
                    }
                default:
                    withAnimation {
                        currentIndex -= 1
                    }
                }
            } label: {
                Icon(
                    name: currentIndex == 0
                    ? .exit
                    : .arrowLeft,
                    color: .black, size: 28)
            }
            .padding(.trailing, 8)
            
            ProgressView(value: Double(currentIndex + 1) / 8)
                .tint(.mainGray)
        }
        .padding(.top, 22)
        .padding(.bottom, 2)
        .paddingHorizontal()
    }
    
    @ViewBuilder
    private func nameContent() -> some View {
        VStack(alignment: .leading, spacing: 0) {
            GrayLineTextFieldView(
                text: $viewModel.name,
                placeHolder: "이름",
                isKeyBoardOn: isKeyboardOn
            )
            .focused($isKeyboardOn)
        }
    }
    
    @ViewBuilder
    func sexContent() -> some View {
        VStack(alignment: .leading, spacing: 0) {
            SexSelectionView(sex: $viewModel.sex)
        }
    }
    
    @ViewBuilder
    func birthContent() -> some View {
        VStack(spacing: 4) {
            HStack {
                Text(viewModel.isEmptyDate(viewModel.birthDate)
                      ? "생년월일"
                     : viewModel.birthDate.customDateFomatter())
                .font(.title_md)
                .foregroundStyle(
                    viewModel.isEmptyDate(
                        viewModel.birthDate
                    )
                    ? .gray300
                    : .mainGray)
                Spacer()
                Icon(
                    name: .chevronDown,
                    color: .gray500,
                    size: 20
                )
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
    }
    
    @ViewBuilder
     private func studentContent() -> some View {
         VStack(alignment: .leading, spacing: 0) {
             VStack(alignment: .leading, spacing: 0) {
                 Text("학교")
                     .font(.title_xsm)
                     .foregroundStyle(.mainGray)
                     .padding(.top, 2)
                     .padding(.bottom, 12)
                     .padding(.leading, 4)
                 
                 VerticalButtonGroup<DegreesStatus>(
                    buttonList: DegreesStatus.allCases,
                    selectedElement: $viewModel.degreesStatus
                 )
             }
             .padding(.bottom, 36)
             
             if viewModel.degreesStatus != .notSelected {
                 VStack(alignment: .leading, spacing: 0) {
                     Text("재학상태")
                         .font(.title_xsm)
                         .foregroundStyle(.gray600)
                         .padding(.bottom, 14)
                         .padding(.leading, 4)
                     
                     EnrollmentStatusGrid(
                        titleList: EnrollmentStatus.allCases,
                        selectedElement: $viewModel.enrollmentStatus,
                        degreesStatus: $viewModel.degreesStatus
                     )
                 }
             }
         }
    }
    
    @ViewBuilder
    func schoolContent() -> some View {
        VStack(alignment: .leading, spacing: 20) {
            VStack(alignment: .leading, spacing: 0) {
                Text("학교")
                    .font(.title_xsm)
                    .foregroundStyle(.gray600)
                    .overlay(alignment: .topLeading) {
                        Circle()
                            .fill(.destructiveRed)
                            .frame(width: 6, height: 6)
                            .offset(x: -6, y: -5)
                    }
                    .padding(.top, 2)
                    .padding(.horizontal, 6)
                GrayLineTextFieldView(
                    text: $viewModel.schoolName,
                    placeHolder: "여깄대학교",
                    isKeyBoardOn: isKeyboardOn
                )
                .padding(.top, 2)
                .autocorrectionDisabled()
                .focused($isKeyboardOn)
            }
            
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
                HStack(spacing: 0) {
                    Text(viewModel.semesterYear.description)
                        .font(.title_md)
                        .foregroundStyle(
                            $viewModel.semesterYear.wrappedValue == .notSelected
                            ? .gray300
                            : .mainGray)
                    Spacer()
                    Icon(
                        name: .chevronDown,
                        color: .gray500,
                        size: 20
                    )
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
//                    .padding(.vertical, 10)
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
            }
        }
    }
    
    @ViewBuilder
    private func majorContent() -> some View {
        GrayBoxGridView(
            column: .two,
            titleList: MajorField.allCases,
            action: {},
            selectedElement: $viewModel.majorField
        )
    }
    
    @ViewBuilder
    func academicInfoContent() -> some View {
            VStack(alignment: .leading, spacing: 0) {
                Text("직전학기 성적")
                    .font(.title_xsm)
                    .foregroundStyle(.mainGray)
                    .padding(.vertical, 6)
                
                HStack {
                    GrayLineNumberFieldView(
                        number: $viewModel.previousGrade,
                        maxGradeStatus: $viewModel.maximumGrade, 
                        isKeyboardOn: isNumKeyboardOn == .first
                    )
                    .focused($isNumKeyboardOn, equals: .first)
                    .toolbar {
                        ToolbarItemGroup(placement: .keyboard) {
                            HStack {
                                Spacer()
                                Button("완료") {
                                    isNumKeyboardOn = nil
                                }
                            }
                        }
                    }
                    Text("/")
                        .font(.system(size: 24))
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
                    .foregroundStyle(.mainGray)
                    .padding(.vertical, 7)
                HStack {
                    GrayLineNumberFieldView(
                        number: $viewModel.entireGrade,
                        maxGradeStatus: $viewModel.maximumGrade,
                        isKeyboardOn: isNumKeyboardOn == .second
                    )
                    .focused($isNumKeyboardOn, equals: .second)
                    Text("/")
                        .font(.system(size: 24))
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
            }
    }
    
    @ViewBuilder
    func incomeDecileContent() -> some View {
        VStack(alignment: .leading, spacing: 0) {
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
        }
    }
}

#Preview {
    OnboardingMainView()
}
