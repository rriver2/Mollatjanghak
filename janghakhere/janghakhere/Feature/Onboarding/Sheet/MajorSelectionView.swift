//
//  MajorSelectionView.swift
//  janghakhere
//
//  Created by Taehwan Kim on 5/11/24.
//

import SwiftUI

struct MajorSelectionView: View {
    @Binding var major: MajorField
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            Text("전공계열")
                .foregroundStyle(.black)
                .font(.title_xsm)
                .padding(.vertical, 20)
            
            GrayBoxGridView<MajorField>(
                column: .three,
                titleList: MajorField.allCases,
                action: {},
                selectedElement: $major
            )
            .padding(.vertical, 8)
            
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
