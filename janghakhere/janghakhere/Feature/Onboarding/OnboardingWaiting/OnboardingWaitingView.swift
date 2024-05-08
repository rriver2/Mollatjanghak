//
//  OnboardingWaitingView.swift
//  janghakhere
//
//  Created by Taehwan Kim on 4/23/24.
//

import SwiftUI

struct OnboardingWaitingView: View {
    var userData: UserDataMinimum
    
    @StateObject var viewModel: OnboardingWaitingViewModel = OnboardingWaitingViewModel()
    @EnvironmentObject private var pathModel: PathModel
    @State var isCompleted = false
    @State var isStopped = false
    @State var finalNumberList: [Int] = [1,2,3]
    
    var body: some View {
        VStack(spacing: 0) {
            Icon(name: isStopped ? .hooray: .hat, size: 122)
                .padding(.top, 150)
                .padding(.bottom, 16)
                VStack(spacing: 0) {
                    Text("환영합니다!")
                        .font(.title_lg)
                        .foregroundStyle(.black)
                        .padding(.vertical, 20)
                    Text( isStopped ? "\(userData.name)님에게 맞는 장학금" : "장학금을 찾고 있어요...")
                        .font(.title_sm)
                        .foregroundStyle(.gray600)
                }
                .animation(.linear(duration: 0.3), value: isStopped)
                .frame(height: 132)
                .padding(.bottom, 16)
            
            HStack(alignment: .center, spacing: 0) {
                SlotMachineView(finalNumberList: $finalNumberList, isFinished: $isCompleted, isStopped: $isStopped)
                Text("개")
                    .foregroundStyle(.gray600)
                    .font(.title_sm)
                    .padding(.leading, 8)
            }
            
            Spacer()
            if isStopped {
                NonMaxButton(
                    title: "공고 보러가기",
                    action: {
                        withAnimation {
                            pathModel.paths.append(.tapView)
                        }
                    }
                )
                .padding(.bottom, 83)
            }
        }
        .onAppear {
            viewModel.beginSignIn(userData: userData)
            viewModel.createView(userData: userData)
        }
        .onDisappear {
            viewModel.cancelTasks()
        }
        .onChange(of: viewModel.matchedScholarships) {
            print(userData.id)
            self.finalNumberList = separateDigits(viewModel.matchedScholarships)
            self.isCompleted = true
            print("finalNumberList", finalNumberList)
        }
    }
    
    private func separateDigits(_ number: Int) -> [Int] {
        return String(number).compactMap { Int(String($0)) }
    }
}

#Preview {
    OnboardingWaitingView(userData: UserDataMinimum(id: "1", name: "123", sex: "123", birth: "123", schoolName: "123", enrolled: "!23", semester: "123", majorCategory: "!23", previousGrade: 0, entireGrade: 0, maximumGrade: "", incomeDecile: ""))
}
