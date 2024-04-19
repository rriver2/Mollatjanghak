//
//  ScholarshipBoxListView.swift
//  janghakhere
//
//  Created by Gaeun Lee on 4/17/24.
//

import SwiftUI

struct ScholarshipBoxListView: View {
    @EnvironmentObject private var pathModel: PathModel
    
    private let scholarshipList: [ScholarshipBox]
    
    init(scholarshipList: [ScholarshipBox]) {
        self.scholarshipList = scholarshipList
    }
    
    var body: some View {
        //FIXME: 맞춤 <-> 전체 시 제일 위로 스크롤 되도록
        VStack(spacing: 0) {
            ScrollView {
                // 장학금 박스들
                ForEach(scholarshipList, id: \.self) { scholarship in
                    Button {
                        pathModel.paths.append(.detailScholarshipView(id: scholarship.id))
                    } label: {
                        ScholarshipBoxView(scholarshipBox: scholarship)
                    }
                }
            }
            .scrollIndicators(.hidden)
            .padding(.top, 16)
            .paddingHorizontal()
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .background(Color.gray50)
    }
}

#Preview {
    ScholarshipBoxListView(scholarshipList: [ScholarshipBox.mockAllData,ScholarshipBox.mockAllData,ScholarshipBox.mockAllData,ScholarshipBox.mockAllData,ScholarshipBox.mockAllData])
}
