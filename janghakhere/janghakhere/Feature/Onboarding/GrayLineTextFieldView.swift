//
//  GrayLineTextFieldView.swift
//  janghakhere
//
//  Created by Gaeun Lee on 4/17/24.
//

import SwiftUI

struct GrayLineTextFieldView: View {
    @Binding var text: String
    let placeHolder: String
    var isKeyBoardOn: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(spacing: 0) {
                TextField(placeHolder, text: $text)
                    .onChange(of: text) { _, value in
                        limitText(value)
                    }
                    .font(.title_md)
                
                if !text.isEmpty {
                    Button(action: {
                        text = ""
                    }) {
                        Image(systemName: "x.circle.fill")
                            .font(.system(size: 19.5))
                            .foregroundColor(.gray600)
                    }
                    .padding(.leading, 8)
                }
            }
            .padding(.vertical, 6)
            .padding(.horizontal, 4)
            .accentColor(.black)
            .overlay(
                Rectangle()
                    .foregroundColor(isKeyBoardOn ? .mainGray : .gray300)
                    .frame(height: 1),
                alignment: .bottom
            )
        }
    }
    
    private func limitText(_ value: String) {
        if text.count > 13 {
            text = String(text.prefix(13))
        }
    }
}

#Preview {
    struct BindingViewExamplePreviewContainer : View {
        @State var text: String = ""
        @FocusState var isKey: Bool
        var body: some View {
            GrayLineTextFieldView(text: $text, placeHolder: "이름", isKeyBoardOn: isKey)
        }
    }
    return BindingViewExamplePreviewContainer()
}
