//
//  ScholarshipBoxListView.swift
//  janghakhere
//
//  Created by Gaeun Lee on 4/17/24.
//

import SwiftUI

struct ScholarshipBoxListView: View {
    @EnvironmentObject private var pathModel: PathModel
    
    @Binding var isGetMoreScholarshipBox: Bool
    
    var scholarshipList: [ScholarshipBox]
    
    var supportedCategory: SupportedCategory?
    
    init(isGetMoreScholarshipBox: Binding<Bool>, scholarshipList: [ScholarshipBox], supportedCategory: SupportedCategory?) {
        self._isGetMoreScholarshipBox = isGetMoreScholarshipBox
        self.scholarshipList = scholarshipList
        self.supportedCategory = supportedCategory
    }
    
    var body: some View {
        VStack(spacing: 0) {
                ScrollView {
                    LazyVStack (spacing: 0) {
                        // 장학금 박스들
                        ForEach(scholarshipList, id: \.self) { scholarship in
                            Button {
                                pathModel.paths.append(.detailScholarshipView(id: scholarship.id))
                            } label: {
                                if let supportedCategory {
                                    switch supportedCategory {
                                    case .completedApplication:
                                        ScholarshipSupportedBoxView(scholarshipBox: scholarship, supportedCategory: supportedCategory)
                                    case .failed, .passed:
                                        ScholarshipBoxView(scholarshipBox: scholarship, supportedCategory: supportedCategory)
                                    }
                                } else {
                                    ScholarshipBoxView(scholarshipBox: scholarship)
                                }
                            }
                            .id(scholarship.id)
                            .onAppear {
                                // 현재 보여진 datum의 index 값을 구하기
                                guard let index = scholarshipList.firstIndex(where: { $0.id == scholarship.id }) else { return }
                                
                                // 해당 index가 거의 끝으로 왔다면 데이터 추가
                                if index == scholarshipList.count - 1 {
                                    isGetMoreScholarshipBox = true
                                }
                            }
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
