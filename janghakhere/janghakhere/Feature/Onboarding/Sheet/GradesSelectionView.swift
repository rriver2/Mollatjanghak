//
//  GradesSelectionView.swift
//  janghakhere
//
//  Created by Taehwan Kim on 5/11/24.
//

import SwiftUI

struct GradesSelectionView: View {
    @Binding var previousGrade: Double
    @Binding var entireGrade: Double
    @Binding var maxGrade: MaxGradeStatus
    @Environment(\.dismiss) var dismiss
    @FocusState var isNumKeyboardOn: Field?
    
    var body: some View {
        VStack(spacing: 0) {
            Text("학점")
                .font(.title_xsm)
                .padding(.vertical, 20)
            
            VStack(alignment: .leading, spacing: 0) {
                Text("직전학기 성적")
                    .font(.title_xsm)
                    .foregroundStyle(.gray600)
                    .padding(.vertical, 6)
                HStack {
                    GrayLineNumberFieldView(
                        number: $previousGrade,
                        maxGradeStatus: $maxGrade,
                        isKeyboardOn: isNumKeyboardOn == .first
                    )
                    .focused($isNumKeyboardOn, equals: .first)
                    .toolbar {
                        ToolbarItemGroup(placement: .keyboard) {
                            HStack {
                                Spacer()
                                Button("완료") {
                                    isNumKeyboardOn = nil
                                }
                            }
                        }
                    }
                    Text("점")
                        .font(.title_xmd)
                        .foregroundStyle(.black)
                }
                .padding(.bottom, 46)
                
                Text("전체학기 성적")
                    .font(.title_xsm)
                    .foregroundStyle(.gray600)
                    .padding(.vertical, 6)
                HStack {
                    GrayLineNumberFieldView(
                        number: $entireGrade,
                        maxGradeStatus: $maxGrade,
                        isKeyboardOn: isNumKeyboardOn == .second
                    )
                    .focused($isNumKeyboardOn, equals: .second)
                    .toolbar {
                        ToolbarItemGroup(placement: .keyboard) {
                            HStack {
                                Spacer()
                                Button("완료") {
                                    isNumKeyboardOn = nil
                                }
                            }
                        }
                    }
                    Text("점")
                        .font(.title_xmd)
                        .foregroundStyle(.black)
                }
                .padding(.bottom, 46)
            }
            
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
