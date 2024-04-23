//
//  AlarmView.swift
//  janghakhere
//
//  Created by Gaeun Lee on 4/22/24.
//

import SwiftUI

struct AlarmView: View {
    @EnvironmentObject private var pathModel: PathModel
    @StateObject private var viewModel = AlarmViewModel()
    
    var body: some View {
        VStack(spacing: 0) {
            navigation()
            grayLine()
            ScrollView {
                VStack(spacing: 0) {
                    ForEach(Alarm.mockList, id: \.self) { alarm in
                        alarmInfoCell(alarm)
                    }
                }
            }
            .scrollIndicators(.hidden)
        }
        .navigationBarBackButtonHidden()
        .task {
            viewModel.createView()
        }
        .onDisappear {
            viewModel.cancelTasks()
        }
    }
}

extension AlarmView {
    @ViewBuilder
    func navigation() -> some View {
        HStack(spacing: 0) {
            Icon(name: .arrowLeft, color: .black, size: 28)
                .onTapGesture {
                    pathModel.paths.removeLast()
                }
            Spacer()
            Text("알림")
                .font(.title_xsm)
            Spacer()
            Rectangle()
                .foregroundColor(.clear)
                .frame(width: 28, height: 28)
        }
        .paddingHorizontal()
        .foregroundStyle(.black)
        .padding(.vertical, 14)
        .background(.white)
    }
    @ViewBuilder
    func alarmInfoCell(_ alarm: Alarm) -> some View {
        VStack(spacing: 0) {
            HStack(alignment: .top, spacing: 0) {
                Icon(name: alarm.IconName, size: 24)
                    .padding(.trailing, 8)
                VStack(alignment: .leading, spacing: 0) {
                    Text(alarm.title)
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
        .background(alarm.isReaded ? .gray50 : .white)
    }
    @ViewBuilder
    func grayLine() -> some View {
        Rectangle()
            .frame(height: 1)
            .frame(maxWidth: .infinity)
            .foregroundStyle(.gray200)
    }
}

#Preview {
    AlarmView()
}
