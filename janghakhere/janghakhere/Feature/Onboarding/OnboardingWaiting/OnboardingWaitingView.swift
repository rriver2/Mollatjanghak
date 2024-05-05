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
    
    var body: some View {
        VStack {
            Image("hat")
                .frame(width: 122, height: 122)
                .padding(.top, 150)
            Text("환영합니다!")
                .font(.title_lg)
                .foregroundStyle(.black)
                .padding(.vertical, 20)
            Text("\(userData.name)님에게 맞는\n장학금 정보를 찾고 있어요...")
                .font(.title_sm)
                .foregroundStyle(.gray600)
                .multilineTextAlignment(.center)
            Spacer()
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
            pathModel.paths.append(.onboardingCompleteView(count: viewModel.matchedScholarships))
        }
    }
}

#Preview {
    OnboardingWaitingView(userData: UserDataMinimum(id: "1", name: "123", sex: "123", birth: "123", schoolName: "123", enrolled: "!23", semester: "123", majorCategory: "!23"))
}
