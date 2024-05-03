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
    @Binding var isGetMoreScholarshipBox: Bool
    
    var scholarshipList: [ScholarshipBox]
    
    init(isGetMoreScholarshipBox: Binding<Bool>, scholarshipList: [ScholarshipBox]) {
        self._isGetMoreScholarshipBox = isGetMoreScholarshipBox
        self.scholarshipList = scholarshipList
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
                                switch scholarship.publicAnnouncementStatus {
                                case  .nothing, .storage, .toBeSupported, .failed, .passed:
                                    ScholarshipBoxView(scholarshipBox: scholarship)
                                case .supportCompleted:
                                    VStack(alignment: .leading, spacing: 0) {
                                        ScholarshipBoxView(scholarshipBox: scholarship)
                                        Button {
                                            self.isShowPassModal = true
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
                                    .fullScreenCover(isPresented: $isShowPassModal) {
                                        SuccessFailView(scholarshipBox: scholarship, isShowPassModal: $isShowPassModal)
                                    }
                                }
                                
                            }
                            .cornerRadius(8)
                            .padding(.bottom, 16)
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
