//
//  ScholarshipBoxView.swift
//  janghakhere
//
//  Created by Gaeun Lee on 4/16/24.
//

import SwiftUI

struct ScholarshipBoxView: View {
    @EnvironmentObject private var pathModel: PathModel
    
    @State var scholarshipBox: ScholarshipBox
    
    init(scholarshipBox: ScholarshipBox) {
        self._scholarshipBox = State(initialValue: scholarshipBox)
    }
    
    var body: some View {
        HStack(spacing: 0) {
            content()
            Spacer()
//            statusRoundRectangle()
        }
        .animation(.easeIn, value: scholarshipBox)
        .frame(maxWidth: .infinity)
        .padding(.top, 20)
        .padding(.bottom, 16)
        .padding(.horizontal, 20)
        .background(.white)
        .onTapGesture {
            pathModel.paths.append(.detailScholarshipView(id: scholarshipBox.id))
        }
    }
}

extension ScholarshipBoxView {
    @ViewBuilder
    private func content() -> some View {
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
                Text(getDDayString())
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
                        .lineLimit(1)
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(.gray60)
                .cornerRadius(4)
                .foregroundStyle(.gray700)
            }
        }
    }
    @ViewBuilder
    private func statusRoundRectangle() -> some View {
        HStack(spacing: 0) {
            if let iconName = scholarshipBox.publicAnnouncementStatus.IconName {
                Icon(name: iconName, color: scholarshipBox.publicAnnouncementStatus.buttonFontColor, size: 16)
                    .padding(.trailing, 4)
            }
            Text(scholarshipBox.publicAnnouncementStatus.title)
                .font(scholarshipBox.publicAnnouncementStatus.fontSize)
        }
        .padding(.horizontal, scholarshipBox.publicAnnouncementStatus.horizontalPadding)
        .padding(.vertical, 8)
        .background(scholarshipBox.publicAnnouncementStatus.buttonColor)
        .cornerRadius(100)
        .foregroundStyle(scholarshipBox.publicAnnouncementStatus.buttonFontColor)
        .onTapGesture {
//            statusButtonPressed(.saved)
        }
    }
}

extension ScholarshipBoxView {
    private func getDDayString() -> String {
        if let dday = scholarshipBox.DDay {
            if dday == "0" {
                return "오늘 마감"
            } else if dday.first == "+" {
                return "마감"
            } else {
                return "D\(dday)"
            }
        } else {
            return "미정"
        }
    }
}
