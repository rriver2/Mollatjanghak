//
//  MainButtonView.swift
//  janghakhere
//
//  Created by Gaeun Lee on 4/17/24.
//

import SwiftUI

struct MainButtonView: View {
    private let title: String
    private let action: (() -> Void)
    private var disabled: Bool = false
    
    init(title: String, action: @escaping () -> Void, disabled: Bool = false) {
        self.title = title
        self.action = action
        self.disabled = disabled
    }
    
    var body: some View {
        Button {
            action()
        } label: {
            Text(title)
        }
        .buttonStyle(MainButtonStyle(disabled: disabled))
        .disabled(disabled)
    }
}

struct MainButtonStyle: ButtonStyle {
    let disabled: Bool
    
  func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .font(.title_xsm)
      .padding(.vertical, 16)
      .foregroundStyle(disabled ? .black : .white)
      .frame(maxWidth: .infinity)
      .frame(height: 58)
      .background(
        Capsule()
            .fill(disabled ? .gray70 : .mainGray)
      )
      .scaleEffect(
        configuration.isPressed && !disabled
        ? 0.95
        : 1.0
      )
  }
}

#Preview {
    MainButtonView(title: "다음", action: {})
}
