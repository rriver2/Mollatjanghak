//
//  SchoolNameSheet.swift
//  janghakhere
//
//  Created by Taehwan Kim on 5/11/24.
//

import SwiftUI

struct SchoolNameSheet: View {
    @Binding var schoolName: String
    @FocusState var isKeyboardOn: Bool
    @Environment(\.dismiss) var dismiss
    var body: some View {
        VStack(spacing: 0) {
            Text("학교")
                .foregroundStyle(.black)
                .font(.title_xsm)
                .padding(.vertical, 20)
            
            GrayLineTextFieldView(
                text: $schoolName,
                placeHolder: schoolName,
                isKeyBoardOn: isKeyboardOn
            )
            .focused($isKeyboardOn)
            
            Spacer()
            MainButtonView(
                title: "선택",
                action: {
                    dismiss()
                },
                disabled: false
            )
        }
        .paddingHorizontal()
        .presentationDetents([.fraction(0.81)])
    }
}
