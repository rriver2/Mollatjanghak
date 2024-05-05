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
    
    let isShowPassStatus: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                LazyVStack (spacing: 0) {
                    // 장학금 박스들
                    ForEach(scholarshipList, id: \.self) { scholarship in
                        Button {
                            pathModel.paths.append(.detailScholarshipView(id: scholarship.id))
                        } label: {
                            if !isShowPassStatus {
                                ScholarshipBoxView(scholarshipBox: scholarship)
                            } else {
                                switch scholarship.publicAnnouncementStatus {
                                case  .nothing, .storage, .planned, .non_passed, .passed:
                                    ScholarshipBoxView(scholarshipBox: scholarship)
                                case .applied:
                                    VStack(alignment: .leading, spacing: 0) {
                                        ScholarshipBoxView(scholarshipBox: scholarship)
                                        Button {
                                            self.isShowPassModal = true
                                            self.selectedScholarship = scholarship
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
                        .id(scholarship.id)
                        .onAppear {
                            // 현재 보여진 datum의 index 값을 구하기
                            guard let index = scholarshipList.firstIndex(where: { $0.id == scholarship.id }) else { return }
                            
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
