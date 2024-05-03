//
//  AlarmView.swift
//  janghakhere
//
//  Created by Gaeun Lee on 4/22/24.
//

import SwiftUI

struct AlarmView: View {
    @EnvironmentObject private var pathModel: PathModel
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = AlarmViewModel()
    
    var body: some View {
        VStack(spacing: 0) {
            NavigationDefaultView(title: "알림")
            grayLine()
            ScrollView {
                VStack(spacing: 0) {
                    ForEach(viewModel.alarmList, id: \.self) { alarm in
                        alarmInfoCell(alarm)
                            .onTapGesture {
                                dismiss()
                            }
                    }
                }
            }
            .scrollIndicators(.hidden)
        }
        .navigationBarBackButtonHidden()
        .onAppear {
            NotificationManager.instance.deleteBadgeNumber()
        }
        .onDisappear {
            viewModel.disAppearView()
        }
        .task {
            viewModel.createView()
        }
    }
}

extension AlarmView {
    @ViewBuilder
    func alarmInfoCell(_ alarm: AlarmScholarship) -> some View {
        VStack(spacing: 0) {
            HStack(alignment: .top, spacing: 0) {
                Icon(name: alarm.category.imageName, size: 28)
                    .padding(.trailing, 8)
                VStack(alignment: .leading, spacing: 0) {
                    Text(alarm.category.title)
                        .font(.semi_title_md)
                        .foregroundStyle(.gray700)
                        .padding(.bottom, 6.5)
                    Text(alarm.content)
                        .font(.text_sm)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                Text("\(alarm.interverDate)")
                    .font(.text_caption)
                    .foregroundStyle(.gray500)
                    .padding(.top, 3)
            }
            .padding(.top, 24)
            .padding(.bottom, 16)
            .padding(.leading, 40)
            .padding(.trailing, 20)
            grayLine()
        }
        .background(getIsNotReaded(date: alarm.DDayDate) ? .white : .gray50)
    }
    @ViewBuilder
    func grayLine() -> some View {
        Rectangle()
            .frame(height: 1)
            .frame(maxWidth: .infinity)
            .foregroundStyle(.gray200)
    }
    
    private func getIsNotReaded(date: Date) -> Bool {
        if let lastAlertCheckedDate = UserDefaults.getValueFromDevice(key: .lastAlertCheckedDate, Date.self),
           lastAlertCheckedDate >= date {
            return false
        } else {
            return true
        }
    }
}

#Preview {
    AlarmView()
}
