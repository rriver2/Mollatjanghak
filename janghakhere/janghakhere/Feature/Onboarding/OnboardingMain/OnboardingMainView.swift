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
    
    var body: some View {
#if DEBUG
        if #available (iOS 17.1, *) {
            Self._printChanges()
        }
#endif
        return VStack(spacing: 0) {
            customNavigationToolbar(value: value)
//            nameContent(name: name)
//            genderContent(gender: gender)
//            birthContent(date: $date, isShowSheet: $isShowSheet)
            schoolContent()
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
    func schoolContent() -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("학교 정보를 입력해 주세요")
                .font(.title_md)
                .foregroundStyle(.mainGray)
                .padding(.top, 60)
                .padding(.bottom, 31)
            GeometryReader { geometry in
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
            }
            
            GeometryReader { geometry in
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
            }
            
            GeometryReader { geometry in
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
            }
            
            GeometryReader { geometry in
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
            }
            
            Spacer()
            
            Button {
                
            } label: {
                Text("다음")
            }
            .buttonStyle(MainButtonStyle())
            .padding(.horizontal, 11)
        }
        .padding()
    }
    
    
    @ViewBuilder
    func birthContent(date: Binding<Date>, isShowSheet : Binding<Bool> ) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("태어난 날짜를 입력해 주세요")
                .font(.title_md)
                .foregroundStyle(.mainGray)
                .padding(.top, 60)
                .padding(.bottom, 64)
            VStack(spacing: 4) {
                HStack {
                    Text( isEmptyDate(date.wrappedValue)
                          ? "생년월일"
                          : date.wrappedValue.customDateFomatter())
                        .font(.title_md)
                        .foregroundStyle(
                            isEmptyDate(date.wrappedValue)
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
                        isEmptyDate(date.wrappedValue)
                        ? .gray300
                        : .mainGray)
                    .frame(height: 1)
            }
            Spacer()
            Button {
                // MARK: 다음 화면 콜하기
            } label: {
                Text("다음")
            }
            .buttonStyle(MainButtonStyle())
            .padding(.horizontal, 11)
        }
        .padding()
    }
    private func isEmptyDate(_ date: Date) -> Bool {
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.year, .month, .day], from: date)
        let today = calendar.dateComponents([.year, .month, .day], from: Date())
        return dateComponents.year == today.year && dateComponents.month == today.month && dateComponents.day == today.day
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
            Button {
                // MARK: 다음 화면 콜하기
            } label: {
                Text("다음")
            }
            .buttonStyle(MainButtonStyle())
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
            Button {
                // MARK: 다음 화면 콜하기
            } label: {
                Text("다음")
            }
            .buttonStyle(MainButtonStyle())
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

extension Date {
    func customDateFomatter() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월 dd일"
        return formatter.string(from: self)
    }
}
