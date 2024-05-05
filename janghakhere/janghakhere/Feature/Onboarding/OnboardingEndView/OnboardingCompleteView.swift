//
//  OnboardingCompleteView.swift
//  janghakhere
//
//  Created by Taehwan Kim on 4/26/24.
//

import SwiftUI

struct OnboardingCompleteView: View {
    let count: Int
    @EnvironmentObject private var pathModel: PathModel
    
    @State var disable: Bool = false
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            HStack {
                Spacer()
                Button {
                    withAnimation {
                        pathModel.paths.append(.tapView)
                    }
                } label: {
                    Icon(
                        name: .exit,
                        color: .mainGray,
                        size: 28
                    )
                }
            }
            .padding(.vertical, 28)
            
            Icon(name: .hooray, size: 122)
                .padding(.top, 40)
                .padding(.bottom, 8)
            
            Text("환영합니다!")
                .font(.title_lg)
                .foregroundStyle(.black)
                .padding(.vertical, 20)
            Text("윤영서님에게 맞는 장학금")
                .font(.title_sm)
                .foregroundStyle(.gray600)
                .padding(.bottom, 12)
            HStack(alignment: .top, spacing: 8) {
                SlotMachineView(finalNumberList: separateDigits(count))
                Text("개")
                    .font(.title_sm)
                    .padding(.top, 6)
                    .foregroundStyle(.gray600)
            }
            Spacer()
            
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
        .padding(.horizontal, 20)
    }
    
    func separateDigits(_ number: Int) -> [Int] {
        return String(number).compactMap { Int(String($0)) }
    }
}

#Preview {
    OnboardingCompleteView(count: 123)
}
