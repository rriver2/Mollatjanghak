//
//  ScholarshipBoxListView.swift
//  janghakhere
//
//  Created by Gaeun Lee on 4/17/24.
//

import SwiftUI

struct ScholarshipBoxListView: View {
    @EnvironmentObject private var pathModel: PathModel
    
    @State var isShowPassModal: Bool = false
    @State var isStatusSheet: Bool = false
    @State var selectedScholarship: ScholarshipBox? = nil
    @Binding var isGetMoreScholarshipBox: Bool
    @Binding var scholarshipList: [ScholarshipBox]
    let boxCategory: BoxCategory
    
    let isShowPassStatus: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                LazyVStack (spacing: 0) {
                    // 장학금 박스들
                    ForEach(scholarshipList.indices, id: \.self) { index in
                        Button {
                            pathModel.paths.append(.detailScholarshipView(id: scholarshipList[index].id))
                        } label: {
                            if !isShowPassStatus {
                                ScholarshipBoxView(scholarshipBox: $scholarshipList[index], category: boxCategory)
                            } else {
                                switch scholarshipList[index].publicAnnouncementStatus {
                                case  .nothing, .saved, .planned, .non_passed, .passed:
                                    ScholarshipBoxView(scholarshipBox: $scholarshipList[index], category: boxCategory)
                                case .applied:
                                    VStack(alignment: .leading, spacing: 0) {
                                        ScholarshipBoxView(scholarshipBox: $scholarshipList[index], category: boxCategory)
                                        Button {
                                            self.isShowPassModal = true
                                            self.selectedScholarship = scholarshipList[index]
                                        } label: {
                                            Text("합격 여부 입력")
                                                .padding(.vertical, 13)
                                                .frame(maxWidth: .infinity)
                                                .font(.semi_title_md)
                                                .foregroundStyle(.gray700)
                                                .background(.gray70)
                                                .cornerRadius(8)
                                                .padding(.top, 16)
                                                .paddingHorizontal()
                                                .padding(.bottom, 16)
                                        }
                                    }
                                    .background(.white)
                                }
                            }
                        }
                        .cornerRadius(8)
                        .padding(.top, 16)
                        .shadow(color: Color(red: 0.51, green: 0.55, blue: 0.58).opacity(0.1), radius: 4, x: 0, y: 0)
                        .id(scholarshipList[index].id)
                        .onAppear {
                            // 해당 index가 거의 끝으로 왔다면 데이터 추가
                            if index == scholarshipList.count - 1 {
                                isGetMoreScholarshipBox = true
                            }
                        }
                        .fullScreenCover(isPresented: $isShowPassModal) {
                            if let selectedScholarship {
                                SuccessFailView(scholarshipBox: $selectedScholarship, isShowPassModal: $isShowPassModal)
                                    .onDisappear {
                                        if let index = scholarshipList.firstIndex(where: { $0.id == selectedScholarship.id }) {
                                            scholarshipList[index].publicAnnouncementStatus = selectedScholarship.publicAnnouncementStatus
                                        }
                                        self.selectedScholarship = nil
                                    }
                            }
                        }
                    }
                }
            }
            .scrollIndicators(.hidden)
            .paddingHorizontal()
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .background(Color.gray50)
    }
}
