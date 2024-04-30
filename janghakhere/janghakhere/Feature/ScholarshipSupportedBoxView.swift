//
//  ScholarshipSupportedBoxView.swift
//  janghakhere
//
//  Created by Gaeun Lee on 4/28/24.
//

import SwiftUI

struct ScholarshipSupportedBoxView: View {
    @EnvironmentObject private var pathModel: PathModel
    @State var scholarshipBox: ScholarshipBox
    @State var isShowPassModal: Bool = false
    
    @State var supportedCategory: SupportedCategory
    
    @State var amount: String = "0"
    
    init(scholarshipBox: ScholarshipBox, supportedCategory: SupportedCategory) {
        self._scholarshipBox = State(initialValue: scholarshipBox)
        self.supportedCategory = supportedCategory
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ScholarshipBoxView(scholarshipBox: scholarshipBox, supportedCategory: supportedCategory)
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
        .cornerRadius(8)
        .shadow(color: Color(red: 0.51, green: 0.55, blue: 0.58).opacity(0.1), radius: 4, x: 0, y: 0)
        .padding(.bottom, 16)
        .fullScreenCover(isPresented: $isShowPassModal) {
            successFailView()
        }
    }
}

extension ScholarshipSupportedBoxView {
    @ViewBuilder
    private func statusButton() -> some View {
        HStack(spacing: 0) {
            Icon(name: scholarshipBox.publicAnnouncementStatus.IconName, color: scholarshipBox.publicAnnouncementStatus.buttonFontColor, size: 16)
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
    @ViewBuilder
    private func successFailView() -> some View {
        VStack(alignment: .leading, spacing: 0) {
            navigationView()
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    Text("합격 여부를 알려주세요")
                        .font(.title_md)
                        .padding(.top, 28)
                        .padding(.bottom, 60)
                    
                    passButton()
                    failedButton()
                    if supportedCategory == .passed {
                        passedAmmountTextField()
                    }
                    Spacer()
                    if supportedCategory == .failed {
                        submitButton()
                    }
                }
            }
            .scrollIndicators(.hidden)
        }
        .paddingHorizontal()
    }
    @ViewBuilder
    private func navigationView() -> some View {
        HStack(spacing: 0) {
            Spacer()
            Icon(name: .exit, color: .black, size: 28)
                .onTapGesture {
                    self.isShowPassModal = false
                }
        }
        .foregroundStyle(.black)
        .padding(.vertical, 28)
    }
    
    @ViewBuilder
    private func passButton() -> some View {
        Button {
            supportedCategory = .passed
        } label: {
            Text("합격")
                .padding(.vertical, 13)
                .frame(maxWidth: .infinity)
                .font(.title_xsm)
                .foregroundStyle(supportedCategory == .passed ? .white : .gray600)
                .background(supportedCategory == .passed ? .subGreen : .gray70)
                .cornerRadius(8)
        }
        .padding(.bottom, 20)
    }
    
    @ViewBuilder
    private func passedAmmountTextField() -> some View {
        Text("수령 금액")
            .font(.title_xsm)
            .foregroundStyle(.gray600)
            .padding(.bottom, 12)
        HStack(spacing: 0) {
            TextFieldDynamicWidth(title: "0", text: $amount)
                .toolbar {
                    ToolbarItemGroup(placement: .keyboard) {
                        Spacer()
                        Button {
                            passedFinishedButtonPressed()
                        } label: {
                            Text("완료")
                                .font(UIFont.systemFont(ofSize: 17, weight: .semibold))
                                .foregroundStyle(Color(hex: "3478F6") ?? .blue)
                        }
                    }
                }
                .foregroundStyle(.black)
                .keyboardType(.numberPad)
                .font(.title_md)
            Text("원")
                .foregroundStyle(.black)
                .font(.title_md)
            if amount == "0" {
                Icon(name: .pencilLine, color: .gray300, size: 24)
            }
            Spacer()
        }
        .padding(.leading, 4)
        .padding(.bottom, 30)
    }
    
    @ViewBuilder
    private func failedButton() -> some View {
        Button {
            supportedCategory = .failed
        } label: {
            Text("불합격")
                .padding(.vertical, 13)
                .frame(maxWidth: .infinity)
                .font(.title_xsm)
                .foregroundStyle(supportedCategory == .failed ? .white : .gray600)
                .background(supportedCategory == .failed ? Color(hex: "FF6464") : .gray70)
                .cornerRadius(8)
        }
        .padding(.bottom, 60)
    }
    
    @ViewBuilder
    private func submitButton() -> some View {
        Button {
            switch supportedCategory {
            case .completedApplication:
                break
            case .failed:
                failedFinishedButtonPressed()
            case .passed:
                passedFinishedButtonPressed()
            }
        } label: {
            let isSubmitmode = supportedCategory == .failed || supportedCategory == .passed
            Text("완료")
                .padding(.vertical, 16)
                .frame(maxWidth: .infinity)
                .font(.title_xsm)
                .foregroundStyle(isSubmitmode ? .white :.gray500)
                .background( isSubmitmode ? .mainGray : .gray100)
                .cornerRadius(100)
        }
    }
}

extension ScholarshipSupportedBoxView {
    private func passedFinishedButtonPressed() {
        //FIXME: 저장 API
        self.isShowPassModal = false
    }
    private func failedFinishedButtonPressed() {
        //FIXME: 저장 API
        self.isShowPassModal = false
    }
}
