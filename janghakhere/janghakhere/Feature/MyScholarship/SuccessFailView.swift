//
//  SuccessFailView.swift
//  janghakhere
//
//  Created by Gaeun Lee on 4/28/24.
//

import SwiftUI

struct SuccessFailView: View {
    @StateObject var viewModel: SuccessFailViewModel = SuccessFailViewModel()
    
    @Binding var scholarshipBox: ScholarshipBox?
    @Binding var isShowPassModal: Bool
    
    @State var amount: String = ""
    @State private var textRect = CGRect()
    
    @FocusState private var isKeyBoardOn: Bool
    
    let placeHolder: String = "0"
    
    init(scholarshipBox: Binding<ScholarshipBox?>, isShowPassModal: Binding<Bool>) {
        self._scholarshipBox = scholarshipBox
        self._isShowPassModal = isShowPassModal
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            navigationView()
            VStack(alignment: .leading, spacing: 0) {
                Text("합격 여부를 알려주세요")
                    .font(.title_md)
                    .padding(.top, 14)
                    .padding(.bottom, 60)
                
                passButton()
                failedButton()
                    .padding(.bottom, 60)
                if scholarshipBox!.publicAnnouncementStatus == .passed {
                    passedAmmountTextField()
                }
                Spacer()
                if !isKeyBoardOn {
                    submitButton()
                }
            }
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
    private func passedAmmountTextField() -> some View {
        Text("수령 금액")
            .font(.title_xsm)
            .foregroundStyle(.gray600)
            .padding(.bottom, 12)
        HStack(spacing: 0) {
            TextFieldDynamicWidth()
                .font(.title_md)
            Text("원")
                .foregroundStyle(.black)
                .font(.title_md)
            if !isKeyBoardOn {
                Icon(name: .pencilLine, color: .gray300, size: 24)
            }
            Spacer()
        }
        .padding(.leading, 4)
        .padding(.bottom, 30)
    }
    
    @ViewBuilder
    private func passButton() -> some View {
        Button {
            scholarshipBox!.publicAnnouncementStatus = .passed
        } label: {
            Text("합격")
                .multilineTextAlignment(.leading)
                .padding(.vertical, 20)
                .padding(.leading, 24)
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.title_xsm)
                .foregroundStyle( scholarshipBox!.publicAnnouncementStatus == .passed ? .white : .gray600)
                .background( scholarshipBox!.publicAnnouncementStatus == .passed ? .subGreen : .gray70)
                .cornerRadius(4)
        }
        .padding(.bottom, 20)
    }
    
    @ViewBuilder
    private func failedButton() -> some View {
        Button {
            scholarshipBox!.publicAnnouncementStatus = .failed
        } label: {
            Text("불합격")
                .padding(.vertical, 20)
                .padding(.leading, 24)
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.title_xsm)
                .foregroundStyle( scholarshipBox!.publicAnnouncementStatus == .failed ? .white : .gray600)
                .background( scholarshipBox!.publicAnnouncementStatus == .failed ? Color.subRed : .gray70)
                .cornerRadius(4)
        }
    }
    
    @ViewBuilder
    private func submitButton() -> some View {
        Button {
            switch  scholarshipBox!.publicAnnouncementStatus {
            case .failed:
                failedFinishedButtonPressed()
            case .passed:
                passedFinishedButtonPressed()
            default:
                break
            }
        } label: {
            let isSubmitmode = scholarshipBox!.publicAnnouncementStatus == .failed || (scholarshipBox!.publicAnnouncementStatus == .passed && !amount.isEmpty)
            Text("완료")
                .padding(.vertical, 16)
                .frame(maxWidth: .infinity)
                .font(.title_xsm)
                .foregroundStyle(isSubmitmode ? .white :.gray500)
                .background( isSubmitmode ? .mainGray : .gray100)
                .cornerRadius(100)
                .padding(.bottom, 18)
        }
    }
    @ViewBuilder
    private func TextFieldDynamicWidth() -> some View {
        ZStack {
            Text(amount == "" ? placeHolder : amount).background(GlobalGeometryGetter(rect: $textRect)).layoutPriority(1).opacity(0)
            HStack {
                TextField(text: $amount) {
                    Text(placeHolder)
                        .foregroundStyle(.gray300)
                }
                .toolbar {
                    ToolbarItem(placement: .keyboard) {
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
                .focused($isKeyBoardOn)
                .foregroundStyle(.black)
                .keyboardType(.numberPad)
                .frame(width: textRect.width)
            }
        }
        .onChange(of: isKeyBoardOn, { oldValue, newValue in
            print("$isKeyBoardOn", isKeyBoardOn)
        })
        .onChange(of: amount) { oldValue, newValue in
            let filtered = newValue.filter { "0123456789".contains($0) }
            if filtered != newValue {
                self.amount = filtered
            }
            formatNumber()
        }
    }
    
    private func formatNumber() {
        if let number = Int(amount) {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            if let formatted = formatter.string(from: NSNumber(value: number)) {
                amount = formatted
            }
        }
    }
}

extension SuccessFailView {
    private func passedFinishedButtonPressed() {
        if let scholarshipBox {
            viewModel.susseccButtonPressed(scholarship: scholarshipBox)
        }
        self.isShowPassModal = false
    }
    private func failedFinishedButtonPressed() {
        if let scholarshipBox {
            viewModel.failButtonPressed(scholarship: scholarshipBox)
        }
        self.isShowPassModal = false
    }
}
