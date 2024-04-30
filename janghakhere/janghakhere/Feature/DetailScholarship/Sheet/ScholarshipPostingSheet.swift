//
//  ScholarshipPostingSheet.swift
//  janghakhere
//
//  Created by Taehwan Kim on 4/29/24.
//

import SwiftUI

enum ScholarshipApplicationStatus: String, CaseIterable, CustomStringConvertible {
    case saved = "공고 저장"
    case prepare = "지원 예정"
    case complete = "지원 완료"
    case notSelected = "선택 안 됨"
    
    var description: String {
        self.rawValue
    }
}

struct ScholarshipPostingSheet: View {
    //    @Binding var date: Date
    //    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            Text("공고 상태")
                .font(.title_xsm)
                .foregroundStyle(.black)
                .padding()
            Spacer()
            Button {
                
            } label: {
                HStack(spacing: 0) {
                    Icon(name: .saveScholarship, size: 42)
                        .padding(.trailing, 16)
                        .padding(.vertical, 14)
                    Text("공고 저장")
                        .font(.title_xsm)
                        .foregroundStyle(.black)
                    Spacer()
                }
            }
            .padding(.horizontal, 28)
            
            Button {
                
            } label: {
                HStack(spacing: 0) {
                    Icon(name: .prepareScholarship, size: 42)
                        .padding(.trailing, 16)
                        .padding(.vertical, 14)
                    Text("공고 저장")
                        .font(.title_xsm)
                        .foregroundStyle(.black)
                    Spacer()
                }
            }
            .padding(.horizontal, 28)
            
            Button {
                
            } label: {
                HStack(spacing: 0) {
                    Icon(name: .doneScholarship, size: 42)
                        .padding(.trailing, 16)
                        .padding(.vertical, 14)
                    Text("공고 저장")
                        .font(.title_xsm)
                        .foregroundStyle(.black)
                }
                Spacer()
            }
            .padding(.horizontal, 28)
            
            MainButtonView(
                title: "저장 취소",
                action: {
                    //                    dismiss()
                },
                disabled: false
            )
            
        }
        .presentationDetents([.medium])
    }
}

#Preview {
    ScholarshipPostingSheet()
}
