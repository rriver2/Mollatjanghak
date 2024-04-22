//
//  SemesterYearSelectionView.swift
//  janghakhere
//
//  Created by Taehwan Kim on 4/21/24.
//

import SwiftUI

struct SemesterYearSelectionView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var year: SemesterYear
    @State private var selectedYear: SemesterYear? = nil // 선택된 학년 추적을 위한 상태 변수
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Spacer()
                Text("학년 선택")
                    .font(.title_xsm)
                    .padding(.vertical, 20)
                Spacer()
            }
            ForEach(SemesterYear.allCases, id: \.self) { year in
                if year != .notSelected {
                    
                    Button {
                        self.selectedYear = year // 선택된 학년 업데이트
                        self.year = year
                    } label: {
                        HStack {
                            Text(year.getYearText())
                                .font(.title_xsm)
                                .foregroundColor(selectedYear == year ? .subGreen : .gray700)
                                .padding(.horizontal, 28)
                                .padding(.vertical, 21)
                            
                            Spacer()
                            if selectedYear == year {
                                Image(systemName: "checkmark")
                                    .foregroundStyle(.green)
                                    .font(.system(size: 16))
                                    .padding()
                            }
                        }
                        .background {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(.clear)
                        }
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
        .presentationDetents([.fraction(0.9)])
    }
}


//#Preview {
//    SemesterYearSelectionView()
//    SheetMainView()
//}
