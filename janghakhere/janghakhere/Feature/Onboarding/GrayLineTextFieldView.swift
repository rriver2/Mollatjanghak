//
//  GrayLineTextFieldView.swift
//  janghakhere
//
//  Created by Gaeun Lee on 4/17/24.
//

import SwiftUI

struct GrayLineTextFieldView: View {
    @Binding var text: String
    @FocusState private var isKeyBoardOn: Bool
    
    let placeHolder: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            TextField(text: $text) {
                Text(placeHolder)
            }
            .focused($isKeyBoardOn)
            .accentColor(.black)
            .padding(.leading, 4)
            .onAppear {
                isKeyBoardOn = true
            }
            Rectangle()
                .foregroundStyle(.gray300)
                .frame(height: 1)
        }
    }
}

#Preview {
    struct BindingViewExamplePreviewContainer : View {
        @State var text: String = ""
        
        var body: some View {
            GrayLineTextFieldView(text: $text, placeHolder: "이름")
        }
    }
    return BindingViewExamplePreviewContainer()
}
