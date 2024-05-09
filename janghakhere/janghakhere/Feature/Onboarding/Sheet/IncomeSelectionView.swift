//
//  IncomeSelectionView.swift
//  janghakhere
//
//  Created by Taehwan Kim on 5/10/24.
//

import SwiftUI

struct IncomeSelectionView: View {
    @Binding var income: IncomeDecile
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(spacing: 0) {
            Text("소득구간")
                .font(.title_xsm)
                .padding(.vertical, 20)
            
            GrayBoxGridView<IncomeDecile>(
                column: .two,
                titleList: IncomeDecile.allCases,
                action: {},
                selectedElement: $income
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
        .presentationDetents([.fraction(0.8)])
    }
}

// #Preview {
//    IncomeSelectionView(
//        income: .constant(IncomeDecile.allCases)
//    )
// }
