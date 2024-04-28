//
//  GrayLineNumberFieldView.swift
//  janghakhere
//
//  Created by Taehwan Kim on 4/22/24.
//

import SwiftUI

// TODO: 0이 입력되면 보여주는 로직 처리 아직 안 함
struct GrayLineNumberFieldView: View {
    @Binding var number: Double
    @Binding var maxGradeStatus: MaxGradeStatus
    @FocusState var isKeyboardOn: Bool
    
    @State private var inputText: String = ""
    @State private var displayText: String = "0.00"
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(displayText)
                    .font(.title_md)
                    .foregroundColor(displayText == "0.00" ? .gray300 : .black)
                    .overlay {
                        TextField("", text: $inputText)
                            .font(.title_xmd)
                            .focused($isKeyboardOn)
                            .keyboardType(.numberPad)
                            .toolbar {
                                ToolbarItemGroup(placement: .keyboard) {
                                    Spacer()
                                    Button("완료") {
                                        isKeyboardOn = false
                                    }
                                }
                            }
                            .onChange(of: inputText) { _, newValue in
                                if newValue.count <= 3 {
                                    displayText = formatNumber(newValue)
                                    number = Double(displayText) ?? 0
                                } else {
                                    inputText = String(inputText.prefix(3))
                                }
                            }
                            .accentColor(.clear)
                            .foregroundColor(.clear)
                    }
            }
            .padding(.leading, 4)
            
            Rectangle()
                .foregroundStyle(isKeyboardOn ? .black : .gray300)
                .frame(height: 1)
        }
    }
    
    private func formatNumber(_ input: String) -> String {
        if let number = Double(input) {
            let maxValue: Double
            switch maxGradeStatus {
            case .four:
                maxValue = 4.0
            case .fourDotThree:
                maxValue = 4.3
            case .fourDotFive:
                maxValue = 4.5
            case .notApplicable, .notSelected:
                maxValue = 999.0 // 임의의 큰 값
            }
            
            let limitedNumber = min(number / pow(10, Double(input.count - 1)), maxValue)
            
            let formatter = NumberFormatter()
            formatter.minimumFractionDigits = 2
            formatter.maximumFractionDigits = 2
            return formatter.string(from: NSNumber(value: limitedNumber)) ?? "0.00"
        } else {
            return "0.00"
        }
    }
}


#Preview {
    struct GrayLineNumberFieldPreviewContainer : View {
        @State var number: Double = 0.0
        @State var maxGrade: MaxGradeStatus = .fourDotThree
        var body: some View {
            GrayLineNumberFieldView(number: $number, maxGradeStatus: $maxGrade)
        }
    }
    return GrayLineNumberFieldPreviewContainer()
}

