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
                    Text("D-\(scholarshipBox.DDay)")
                        .font(.semi_title_sm)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(.destructiveRed.opacity(0.08))
                        .cornerRadius(4)
                        .foregroundStyle(.destructiveRed)
                        .padding(.trailing, 8)
                    HStack(spacing: 0) {
                        Icon(name: .exempleIcon, color: .gray700, size: 11)
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
            Spacer()
            HStack(spacing: 0) {
                Icon(name: .exempleIcon, color: scholarshipBox.publicAnnouncementStatus.buttonFontColor, size: 11)
                    .padding(.trailing, 4)
                Text(scholarshipBox.publicAnnouncementStatus.title)
                    .font(.semi_title_sm)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(scholarshipBox.publicAnnouncementStatus.buttonColor)
            .cornerRadius(100)
            .foregroundStyle(scholarshipBox.publicAnnouncementStatus.buttonFontColor)
            .onTapGesture {
                // 예시로
                var status: PublicAnnouncementStatusCategory = .Nothing
                switch scholarshipBox.publicAnnouncementStatus {
                case .Nothing:
                    status = .Storage
                case .Storage:
                    status = .ToBeSupported
                case .ToBeSupported:
                    status = .SupportCompleted
                case .SupportCompleted:
                    status = .Nothing
                }
                scholarshipBox.publicAnnouncementStatus = ScholarshipBoxManager.scholarshipStatusButtonPressed(status: publicAnnouncementStatus(id: scholarshipBox.id, status: status))
            }
        }
        .animation(.easeIn, value: scholarshipBox)
        .frame(maxWidth: .infinity)
        .padding(.top, 20)
        .padding(.bottom, 26)
        .padding(.horizontal, 20)
        .background(.white)
        .cornerRadius(8)
        .shadow(color: Color(red: 0.51, green: 0.55, blue: 0.58).opacity(0.1), radius: 4, x: 0, y: 0)
        .padding(.bottom, 16)
        .onTapGesture {
            pathModel.paths.append(.detailScholarshipView(id: scholarshipBox.id))
        }
    }
}
