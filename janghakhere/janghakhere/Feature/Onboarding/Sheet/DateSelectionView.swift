//
//  DateSelectionView.swift
//  janghakhere
//
//  Created by Taehwan Kim on 4/21/24.
//

import SwiftUI

struct DateSelectionView: View {
    @Binding var date: Date
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            Text("날짜 선택")
                .font(.title_xsm)
                .padding()
            Spacer()
            DatePicker("날짜선택피커", selection: $date, displayedComponents: [.date])
                .datePickerStyle(.wheel)
                .labelsHidden()
                .environment(\.locale, .init(identifier: "ko_KR"))
            Spacer()
            MainButtonView(
                title: "확인",
                action: {
                    dismiss()
                },
                disabled: false
            )
            .padding(.horizontal, 31)
//            Button {
//                dismiss()
//            } label: {
//                Text("확인")
//            }
//            .buttonStyle(MainButtonStyle())
//            .padding(.horizontal, 31)
        }
        .presentationDetents([.medium])
    }
}
//#Preview {
//    DateSelectionView()
//}
