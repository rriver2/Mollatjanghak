//
//  ScholarshipBoxView.swift
//  janghakhere
//
//  Created by Gaeun Lee on 4/16/24.
//

import SwiftUI

struct ScholarshipBoxView: View {
    let scholarshipBox: ScholarshipBox
    
    var body: some View {
        HStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 0) {
                Text(scholarshipBox.sponsor)
                    .font(.semi_title_sm)
                    .foregroundStyle(Color.gray400)
                    .padding(.bottom, 4)
                Text(scholarshipBox.title)
                    .font(.title_xsm)
                    .foregroundStyle(Color.black)
                    .padding(.bottom, 25)
                HStack(spacing: 0) {
                    Text("D-\(scholarshipBox.DDay)")
                        .font(.semi_title_sm)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(.destructiveRed.opacity(0.08))
                        .cornerRadius(4)
                        .foregroundStyle(.destructiveRed)
                        .padding(.trailing, 8)
                    HStack(spacing: 0) {
                        Icon(name: .exempleIcon, color: .subGreen, size: 11)
                            .padding(.trailing, 5)
                        Text(scholarshipBox.prize)
                            .font(.semi_title_sm)
                    }
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(.subGreen.opacity(0.08))
                        .cornerRadius(50)
                        .foregroundStyle(.subGreen)
                }
            }
            Spacer()
            HStack(spacing: 0) {
                Icon(name: .exempleIcon, color: .gray700, size: 11)
                    .padding(.trailing, 4)
                Text("저장")
                    .font(.semi_title_sm)
            }
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(.gray70)
                .cornerRadius(50)
                .foregroundStyle(.gray700)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 19)
        .padding(.bottom, 16)
        .padding(.horizontal, 20)
        .background(.white)
        .cornerRadius(8)
        .shadow(color: Color(red: 0.51, green: 0.55, blue: 0.58).opacity(0.1), radius: 4, x: 0, y: 0)
        .padding(.bottom, 16)
    }
}

#Preview {
    ScholarshipBoxView(scholarshipBox: .mockAllData)
}
