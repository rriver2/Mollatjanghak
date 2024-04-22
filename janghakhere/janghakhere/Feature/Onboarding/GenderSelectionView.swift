//
//  GenderSelectionView.swift
//  janghakhere
//
//  Created by Taehwan Kim on 4/21/24.
//

import SwiftUI

struct GenderMainView: View {
    @State var gender: Gender = .notSelected
    var body: some View {
        VStack {
            GenderSelectionView(gender: $gender)
        }
    }
}

struct GenderSelectionView: View {
    @Binding var gender: Gender
    
    var body: some View {
        HStack(spacing: 12) {
            Button {
                gender = .male
                
            } label: {
                VStack {
                    Image(systemName: "person.fill")
                        .font(.system(size: 60))
                    //                        .frame(width: 54, height: 115)
                    //                        .padding(.horizontal, 58)
                    //                        .padding(.top, 62)
                    //                        .padding(.bottom, 4)
                        .foregroundStyle(
                            gender == .male ? Color.black : .gray400
                        )
                    Text("남자")
                        .foregroundStyle(
                            gender == .male
                            ? Color.black
                            : .gray400
                        )
                }
                .frame(maxWidth: .infinity, maxHeight: 238)
                .background(.gray60)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(gender == .male ? Color.black : .gray60, lineWidth: 1)
                )
            }
            
            Button {
                gender = .female
                print(gender)
            } label: {
                VStack {
                    Image(systemName: "person.fill")
                        .font(.system(size: 60))
                        .foregroundStyle(
                            gender == .female
                            ? .black
                            : .gray400
                        )
                    Text("여자")
                        .foregroundStyle(gender == .female ?  .black : .gray400)
                }
                .frame(maxWidth: .infinity, maxHeight: 238)
                .background(.gray60)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(
                            gender == .female
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
    struct GenderSelectionPreviewContainer: View {
        @State var gender: Gender = .notSelected
        
        var body: some View {
            GenderSelectionView(gender: $gender)
        }
    }
    return GenderSelectionPreviewContainer()
}
