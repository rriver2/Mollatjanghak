//
//  ScholarshipBoxView.swift
//  janghakhere
//
//  Created by Gaeun Lee on 4/16/24.
//

import SwiftUI

enum BoxCategory {
    case AllScholarship
    case MyScholarship
    case DetailScholarship
    case SearchScholarship
}

struct ScholarshipBoxView: View {
    @EnvironmentObject private var pathModel: PathModel
    
    @Binding var scholarshipBox: ScholarshipBox
    @StateObject var viewModel: ScholarshipBoxViewModel = ScholarshipBoxViewModel()
    
    let category: BoxCategory
    
    init(scholarshipBox: Binding<ScholarshipBox>, category: BoxCategory) {
        self._scholarshipBox = scholarshipBox
        self.category = category
    }
    
    var body: some View {
        HStack(spacing: 0) {
            content()
            Spacer()
            statusRoundRectangle()
        }
        .animation(.easeIn, value: scholarshipBox)
        .frame(maxWidth: .infinity)
        .padding(.top, 20)
        .padding(.bottom, 16)
        .padding(.horizontal, 20)
        .background(.white)
        .onTapGesture {
            pathModel.paths.append(.detailScholarshipView(id: scholarshipBox.id))
        }
    }
}

extension ScholarshipBoxView {
    @ViewBuilder
    private func content() -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(scholarshipBox.sponsor)
                .font(.semi_title_sm)
                .foregroundStyle(Color.gray400)
                .padding(.bottom, 4)
                .multilineTextAlignment(.leading)
            Text(scholarshipBox.title)
                .font(.title_xsm)
                .foregroundStyle(Color.black)
                .padding(.bottom, 24)
                .multilineTextAlignment(.leading)
            HStack(spacing: 0) {
                Text(getDDayString())
                    .font(.semi_title_sm)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(.destructiveRed.opacity(0.08))
                    .cornerRadius(4)
                    .foregroundStyle(.destructiveRed)
                    .padding(.trailing, 8)
                HStack(spacing: 0) {
                    Icon(name: .currencyKrw, color: .gray700, size: 16)
                        .padding(.trailing, 5)
                    Text(scholarshipBox.prize)
                        .font(.semi_title_sm)
                        .lineLimit(1)
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(.gray60)
                .cornerRadius(4)
                .foregroundStyle(.gray700)
            }
        }
    }
    @ViewBuilder
    private func statusRoundRectangle() -> some View {
        HStack(spacing: 0) {
            if let iconName = scholarshipBox.publicAnnouncementStatus.IconName {
                Icon(name: iconName, color: scholarshipBox.publicAnnouncementStatus.buttonFontColor, size: 16)
                    .padding(.trailing, 4)
            }
            Text(scholarshipBox.publicAnnouncementStatus.title)
                .font(scholarshipBox.publicAnnouncementStatus.fontSize)
        }
        .padding(.horizontal, scholarshipBox.publicAnnouncementStatus.horizontalPadding)
        .padding(.vertical, 8)
        .background(scholarshipBox.publicAnnouncementStatus.buttonColor)
        .cornerRadius(100)
        .foregroundStyle(scholarshipBox.publicAnnouncementStatus.buttonFontColor)
        .onTapGesture {
            switch category {
            case .AllScholarship, .SearchScholarship:
                if scholarshipBox.publicAnnouncementStatus == .nothing {
                    viewModel.mainStorageButtonPressed(id: scholarshipBox.id)
                } else {
                    viewModel.isStatusSheet = true
                }
            case .DetailScholarship, .MyScholarship:
                viewModel.isStatusSheet = true
            }
        }
        .sheet(isPresented: $viewModel.isStatusSheet) {
            ScholarshipPostingSheet(category: $scholarshipBox.publicAnnouncementStatus, statusButtonPressed: { category in
                viewModel.sheetStorageButtonPressed(id: scholarshipBox.id, status: category)
                viewModel.isStatusSheet = false
            })
        }
        .onChange(of: viewModel.changedStatus) { oldValue, newValue in
            if let status = viewModel.changedStatus {
                scholarshipBox.publicAnnouncementStatus = status
            }
        }
    }
}

extension ScholarshipBoxView {
    private func getDDayString() -> String {
        if let dday = scholarshipBox.DDay {
            if dday == "0" {
                return "오늘 마감"
            } else if dday.first == "+" {
                return "마감"
            } else {
                return "D\(dday)"
            }
        } else {
            return "미정"
        }
    }
}
