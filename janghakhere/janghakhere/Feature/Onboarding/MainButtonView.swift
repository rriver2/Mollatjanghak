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

struct MainButtonStyle: ButtonStyle {
  func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .font(.title_xsm)
      .padding(.vertical, 16)
      .foregroundStyle(.white)
      .frame(maxWidth: .infinity)
      .frame(height: 58)
      .background(
        Capsule()
          .fill(.mainGray)
      )
      .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
  }
}

#Preview {
    MainButtonView(title: "다음", clickedButton: {})
}
