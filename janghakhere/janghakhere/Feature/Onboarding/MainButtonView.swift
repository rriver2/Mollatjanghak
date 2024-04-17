//
//  MainButtonView.swift
//  janghakhere
//
//  Created by Gaeun Lee on 4/17/24.
//

import SwiftUI

struct MainButtonView: View {
    private let title: String
    private let clickedButton: (() -> Void)
    
    init(title: String, clickedButton: @escaping () -> Void) {
        self.title = title
        self.clickedButton = clickedButton
    }
    
    var body: some View {
        Button {
            clickedButton()
        } label: {
            Text(title)
                .font(.title_xsm)
                .padding(.vertical, 16)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .background(Color.mainGray)
                .cornerRadius(100)
                .padding(.horizontal, 11)
        }
    }
}

#Preview {
    MainButtonView(title: "다음", clickedButton: {})
}
