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
    
    @State var isSelectedPass: selectedButton = .none
    
    let isChangedToPass: () -> Void
    let isChangedToFailed: () -> Void
    
    enum selectedButton {
        case pass
        case failed
        case none
    }
    
    @FocusState private var isKeyBoardOn: Bool
    
    let placeHolder: String = "0"
    
    init(scholarshipBox: Binding<ScholarshipBox?>, isShowPassModal: Binding<Bool>,
         isChangedToPass: @escaping () -> Void, isChangedToFailed: @escaping () -> Void) {
        self._scholarshipBox = scholarshipBox
        self._isShowPassModal = isShowPassModal
        self.isChangedToPass = isChangedToPass
        self.isChangedToFailed = isChangedToFailed
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
                if isSelectedPass == .pass {
                    passedAmmountTextField()
                }
                Spacer()
            }
        }
        .paddingHorizontal()
        .onChange(of: scholarshipBox?.publicAnnouncementStatus) { _,_ in
            print("scholarshipBox?.publicAnnouncementStatus 바뀜", scholarshipBox?.publicAnnouncementStatus)
        }
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
            if !amount.isEmpty {
                Text("완료")
                    .font(.title_xsm)
                    .foregroundStyle(.white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(Color.mainGray)
                    .cornerRadius(4)
                    .onTapGesture {
                        passedFinishedButtonPressed(success: {
                            scholarshipBox!.publicAnnouncementStatus = .passed
                            isShowPassModal = false
                            isChangedToPass()
                        })
                    }
            }
        }
        .padding(.leading, 4)
        .padding(.bottom, 30)
    }
    
    @ViewBuilder
    private func passButton() -> some View {
        Button {
            isSelectedPass = .pass
        } label: {
            Text("합격")
                .multilineTextAlignment(.leading)
                .padding(.vertical, 20)
                .padding(.leading, 24)
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.title_xsm)
                .foregroundStyle( isSelectedPass == .pass ? .white : .gray600)
                .background( isSelectedPass == .pass ? .subGreen : .gray70)
                .cornerRadius(4)
        }
        .padding(.bottom, 20)
    }
    
    @ViewBuilder
    private func failedButton() -> some View {
        Button {
            isSelectedPass = .failed
            failedFinishedButtonPressed {
                scholarshipBox!.publicAnnouncementStatus = .non_passed
                isShowPassModal = false
                isChangedToFailed()
            }
        } label: {
            Text("불합격")
                .padding(.vertical, 20)
                .padding(.leading, 24)
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.title_xsm)
                .foregroundStyle( isSelectedPass == .failed ? .white : .gray600)
                .background( isSelectedPass == .failed ? Color.ectRed : .gray70)
                .cornerRadius(4)
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
                .focused($isKeyBoardOn)
                .foregroundStyle(.black)
                .keyboardType(.numberPad)
                .frame(width: textRect.width)
                .onAppear {
                    isKeyBoardOn = true
                }
            }
        }
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
    private func passedFinishedButtonPressed(success: @escaping () -> Void) {
        if let scholarshipBox {
            viewModel.susseccButtonPressed(scholarship: scholarshipBox, success: success)
        }
    }
    private func failedFinishedButtonPressed(success: @escaping () -> Void) {
        if let scholarshipBox {
            viewModel.failButtonPressed(scholarship: scholarshipBox, success: success)
        }
    }
}
