//
//  ScholarshipSupportedBoxView.swift
//  janghakhere
//
//  Created by Gaeun Lee on 4/28/24.
//

import SwiftUI

struct SuccessFailView: View {
    @State var scholarshipBox: ScholarshipBox
    @FocusState private var isKeyboardOn: Bool
    @Binding var isShowPassModal: Bool
    
    @State var amount: String = ""
    
    init(scholarshipBox: ScholarshipBox, isShowPassModal: Binding<Bool>) {
        self._scholarshipBox = State(initialValue: scholarshipBox)
        self._isShowPassModal = isShowPassModal
    }
    
    var body: some View {
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
                    if scholarshipBox.publicAnnouncementStatus == .passed {
                        passedAmmountTextField()
                    }
                    Spacer()
                    if  scholarshipBox.publicAnnouncementStatus == .failed {
                        submitButton()
                    }
                }
            }
            .scrollIndicators(.hidden)
        }
        .paddingHorizontal()
    }
}

extension SuccessFailView {
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
            scholarshipBox.publicAnnouncementStatus = .passed
        } label: {
            Text("합격")
                .padding(.vertical, 13)
                .frame(maxWidth: .infinity)
                .font(.title_xsm)
                .foregroundStyle( scholarshipBox.publicAnnouncementStatus == .passed ? .white : .gray600)
                .background( scholarshipBox.publicAnnouncementStatus == .passed ? .subGreen : .gray70)
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
            scholarshipBox.publicAnnouncementStatus = .failed
        } label: {
            Text("불합격")
                .padding(.vertical, 13)
                .frame(maxWidth: .infinity)
                .font(.title_xsm)
                .foregroundStyle( scholarshipBox.publicAnnouncementStatus == .failed ? .white : .gray600)
                .background( scholarshipBox.publicAnnouncementStatus == .failed ? Color.subRed : .gray70)
                .cornerRadius(8)
        }
        .padding(.bottom, 60)
    }
    
    @ViewBuilder
    private func submitButton() -> some View {
        Button {
            switch  scholarshipBox.publicAnnouncementStatus {
            case .failed:
                failedFinishedButtonPressed()
            case .passed:
                passedFinishedButtonPressed()
            default:
                break
            }
        } label: {
            let isSubmitmode =  scholarshipBox.publicAnnouncementStatus == .failed ||  scholarshipBox.publicAnnouncementStatus == .passed
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

extension SuccessFailView {
    private func passedFinishedButtonPressed() {
        //FIXME: 저장 API
        self.isShowPassModal = false
    }
    private func failedFinishedButtonPressed() {
        //FIXME: 저장 API
        self.isShowPassModal = false
    }
}
