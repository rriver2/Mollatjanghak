//
//  ScholarshipPostingSheet.swift
//  janghakhere
//
//  Created by Taehwan Kim on 4/29/24.
//

import SwiftUI

struct ScholarshipPostingSheet: View {
    @Binding var category: PublicAnnouncementStatusCategory
    
    let id: String
    var statusButtonPressed: ((_ category: PublicAnnouncementStatusCategory) -> Void)
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("공고 상태")
                .font(.title_xsm)
                .padding(.vertical, 20)
                .frame(maxWidth: .infinity)
            statusButton(status: .saved)
            statusButton(status: .applied)
            statusButton(status: .planned)
            .padding(.bottom, 53)
            Text("저장 취소")
                .font(.title_xsm)
                .foregroundStyle(.mainGray)
                .padding(.vertical, 16)
                .frame(maxWidth: .infinity)
                .background(.gray70)
                .cornerRadius(100)
                .padding(.horizontal, 31)
                .padding(.bottom, 14)
                .onTapGesture {
                    statusChanged(.nothing)
                }
        }
        .foregroundStyle(.black)
        .presentationDetents([.medium])
    }
}

extension ScholarshipPostingSheet {
    @ViewBuilder
    private func statusButton(status: PublicAnnouncementStatusCategory) -> some View {
        HStack(spacing: 16) {
            if let name = status.IconNameButton {
                Icon(name: name, size: 42)
            }
            Text(status.title)
                .foregroundStyle(category == status ? status.detailViewButtonColor : .black)
                .font(.title_xsm)
            Spacer()
        }
        .padding(.leading, 28)
        .padding(.vertical, 14)
        .contentShape(Rectangle())
        .onTapGesture {
            statusChanged(status)
        }
    }
    
    private func statusChanged(_ category: PublicAnnouncementStatusCategory) {
        statusButtonPressed(category)
        self.category = category
    }
}
