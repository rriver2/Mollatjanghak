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
            HStack {
                TextField("", text: $text)
                    .font(.title_md)
                    .focused($isKeyBoardOn)
                    .overlay {
                        HStack {
                            if !text.isEmpty {
                                Text(text)
                                    .font(.title_md)
                                    .foregroundColor(.mainGray)
                            } else {
                                Text(placeHolder)
                                    .font(.title_md)
                                    .foregroundColor(.gray300)
                            }
                            Spacer()
                            if !text.isEmpty {
                                Button {
                                    text = ""
                                } label: {
                                    Image(systemName: "x.circle.fill")
                                        .font(.system(size: 19.5))
                                        .foregroundColor(.gray600)
                                }
                            }
                        }
                    }
            }
            .accentColor(.black)
            .padding(.leading, 4)
            .onAppear {
                isKeyBoardOn = true
            }
            Rectangle()
                .foregroundStyle(isKeyBoardOn ? .mainGray  : .gray300)
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
