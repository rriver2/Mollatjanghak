//
//  GenderSelectionView.swift
//  janghakhere
//
//  Created by Taehwan Kim on 4/21/24.
//

import SwiftUI

struct SexSelectionView: View {
    @Binding var sex: Sex
    
    var body: some View {
        HStack(spacing: 12) {
            Button {
                sex = .male
            } label: {
                VStack(spacing: 0) {
                    Spacer()
                    Icon(name: .male, color: sex == .male ? Color.black : .gray400, size: 78)
                        .padding(.bottom, 40)
                    Text("남자")
                        .font(.title_sm)
                        .foregroundStyle(.black)
                        .padding(.bottom, 28)
                }
                .frame(maxWidth: .infinity, maxHeight: 238)
                .background(.gray60)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(sex == .male ? Color.black : .gray60, lineWidth: 2)
                )
            }
            
            Button {
                sex = .female
            } label: {
                VStack(spacing: 0) {
                    Spacer()
                    Icon(name: .female, color: sex == .female ? Color.black : .gray400, size: 78)
                        .padding(.bottom, 40)
                    Text("여자")
                        .font(.title_sm)
                        .foregroundStyle(.black)
                        .padding(.bottom, 28)
                }
                .frame(maxWidth: .infinity, maxHeight: 238)
                .background(.gray60)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(
                            sex == .female
                            ? .black
                            : .gray60,
                            lineWidth: 2
                        )
                )
            }
        }
    }
}

#Preview {
    struct SexSelectionPreviewContainer: View {
        @State var sex: Sex = .notSelected
        
        var body: some View {
            SexSelectionView(sex: $sex)
        }
    }
    return SexSelectionPreviewContainer()
}
