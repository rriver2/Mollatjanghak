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
            ScholarshipBoxLeadingView(scholarshipBox)
            Spacer()
            HStack(spacing: 0) {
                if let iconName = scholarshipBox.publicAnnouncementStatus.IconName {
                    Icon(name: iconName, color: scholarshipBox.publicAnnouncementStatus.buttonFontColor, size: 16)
                        .padding(.trailing, 4)
                }
                    Text(scholarshipBox.publicAnnouncementStatus.title)
                //FIXME: 각각에 맞게 수정하기
                        .font(.semi_title_sm)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(scholarshipBox.publicAnnouncementStatus.buttonColor)
            .cornerRadius(100)
            .foregroundStyle(scholarshipBox.publicAnnouncementStatus.buttonFontColor)
            .onTapGesture {
                //FIXME: 예시로
//                    var status: PublicAnnouncementStatusCategory = .Nothing
//                    switch scholarshipBox.publicAnnouncementStatus {
//                    case .Nothing:
//                        status = .Storage
//                    case .Storage:
//                        status = .ToBeSupported
//                    case .ToBeSupported:
//                        status = .SupportCompleted
//                    case .SupportCompleted:
//                        status = .Nothing
//                    }
//                    scholarshipBox.publicAnnouncementStatus = ScholarshipBoxManager.scholarshipStatusButtonPressed(status: publicAnnouncementStatus(id: scholarshipBox.id, status: status))
            }
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
