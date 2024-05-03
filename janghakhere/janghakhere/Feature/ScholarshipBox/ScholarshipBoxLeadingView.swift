//
//  ScholarshipBoxLeadingView.swift
//  janghakhere
//
//  Created by Gaeun Lee on 5/3/24.
//

import SwiftUI

struct ScholarshipBoxLeadingView: View {
    let scholarshipBox: ScholarshipBox
    
    init(_ scholarshipBox: ScholarshipBox) {
        self.scholarshipBox = scholarshipBox
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(scholarshipBox.sponsor)
                .font(.semi_title_sm)
                .foregroundStyle(Color.gray400)
                .padding(.bottom, 4)
            Text(scholarshipBox.title)
                .font(.title_xsm)
                .foregroundStyle(Color.black)
                .padding(.bottom, 24)
            HStack(spacing: 0) {
                Text("D\(scholarshipBox.DDay)")
                    .font(.semi_title_sm)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(.destructiveRed.opacity(0.08))
                    .cornerRadius(4)
                    .foregroundStyle(.destructiveRed)
                    .padding(.trailing, 8)
                HStack(spacing: 0) {
                    Icon(name: .currencyKrw, color: .gray700, size: 16)
                        .padding(.trailing, 5)
                    Text(scholarshipBox.prize)
                        .font(.semi_title_sm)
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(.gray60)
                .cornerRadius(4)
                .foregroundStyle(.gray700)
            }
        }
    }
}
