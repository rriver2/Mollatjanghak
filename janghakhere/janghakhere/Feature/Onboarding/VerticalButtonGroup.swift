//
//  VerticalButtonGroup.swift
//  janghakhere
//
//  Created by Taehwan Kim on 4/28/24.
//

import SwiftUI

struct VerticalButtonGroup<T: Hashable & CustomStringConvertible>: View {
    let buttonList: [T]
    @Binding var selectedElement: T
    
    var body: some View {
        VStack(spacing: 20) {
            ForEach(buttonList.filter { $0.description != "선택 안 됨" }, id: \.self) { button in
                Button {
                    withAnimation {
                        selectedElement = button
                    }
                } label: {
                    HStack {
                        Text(button.description)
                            .padding(.horizontal, 24)
                        Spacer()
                    }
                    .font(.title_xsm)
                    .foregroundStyle(
                        selectedElement == button
                        ? .white
                        : .gray600
                    )
                    .frame(maxWidth: .infinity)
                    .frame(height: 66)
                    .background(
                        RoundedRectangle(cornerRadius: 4)
                            .fill(
                                selectedElement == button
                                  ? .mainGray
                                  : .gray70
                            )
                    )
                }
            }
        }
    }
}
