//
//  MaxGradeSheet.swift
//  janghakhere
//
//  Created by Taehwan Kim on 4/23/24.
//

import SwiftUI

enum MaxGradeStatus: String, CaseIterable, CustomStringConvertible, Codable {
    case four = "4.0"
    case fourDotThree = "4.3"
    case fourDotFive = "4.5"
    case notApplicable = "해당 없음"
    case notSelected = "선택 안 됨"
    
    var description: String {
        self.rawValue
    }
}

struct MaxGradeSheet: View {
    @Environment(\.dismiss) var dismiss
    @Binding var maxGrade: MaxGradeStatus
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Spacer()
                Text("총학점")
                    .font(.title_xsm)
                    .padding(.vertical, 20)
                Spacer()
            }
            ForEach(MaxGradeStatus.allCases, id: \.self) { grade in
                if grade != .notSelected {
                    HStack {
                        Text(grade.description)
                            .font(.title_xsm)
                            .foregroundColor(maxGrade == grade ? .subGreen : .gray700)
                            .padding(.horizontal, 28)
                            .padding(.vertical, 21)
                        
                        Spacer()
                        if maxGrade == grade {
                            Image(systemName: "checkmark")
                                .foregroundStyle(.green)
                                .font(.system(size: 16))
                                .padding()
                        }
                    }
                    .contentShape(RoundedRectangle(cornerRadius: 10))
                    .onTapGesture {
                        maxGrade = grade
                    }
                }
            }
            Spacer()
            MainButtonView(
                title: "확인",
                action: {
                    dismiss()
                },
                disabled: false
            )
            .padding(.top, 20)
            .padding()
        }
        .presentationDetents([.fraction(0.6)])
    }
}

#Preview {
    struct MaxGradeSheetPreviewContainer: View {
        @State var maxGrade: MaxGradeStatus = .notSelected
        
        var body: some View {
            MaxGradeSheet(maxGrade: $maxGrade)
        }
    }
    return MaxGradeSheetPreviewContainer()
}
