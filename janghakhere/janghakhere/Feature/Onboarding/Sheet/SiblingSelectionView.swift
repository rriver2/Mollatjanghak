//
//  SiblingSelectionView.swift
//  janghakhere
//
//  Created by Taehwan Kim on 5/10/24.
//

import SwiftUI

struct SiblingSelectionView: View {
    @Binding var siblingStatus: SiblingStatus
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(spacing: 0) {
            Text("형제")
                .font(.title_xsm)
                .padding(.vertical, 20)
            
            ForEach(SiblingStatus.allCases, id: \.self) { sibling in
                if sibling != .notSelected {
                    HStack {
                        Text(sibling.description)
                            .font(.title_xsm)
                            .foregroundColor(siblingStatus == sibling ? .subGreen : .gray700)
                            .padding(.vertical, 21)
                        
                        Spacer()
                        if siblingStatus == sibling {
                            Image(systemName: "checkmark")
                                .foregroundStyle(.green)
                                .font(.system(size: 16))
                                .padding(.vertical, 21)
                        }
                    }
                    .contentShape(RoundedRectangle(cornerRadius: 10))
                    .onTapGesture {
                        siblingStatus = sibling
                    }
                }
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
        .presentationDetents([.fraction(0.37)])
    }
}

// #Preview {
//    SiblingSelectionView()
// }
