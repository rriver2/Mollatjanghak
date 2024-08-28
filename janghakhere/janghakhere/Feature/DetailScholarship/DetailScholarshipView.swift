//
//  DetailScholarshipView.swift
//  janghakhere
//
//  Created by Gaeun Lee on 4/16/24.
//

import SwiftUI
import TipKit

struct DetailScholarshipView: View {
    @Environment(\.dismiss) private var dismiss
    
    @EnvironmentObject private var pathModel: PathModel
    @EnvironmentObject private var scholarshipStatusViewModel: ScholarshipStatusViewModel
    
    @StateObject private var viewModel = DetailScholarshipViewModel()
    @State private var showApplication: Bool = true
    @State private var showSelection: Bool = true
    @State private var showRequirement: Bool = true
    
    let id: String
    let status: PublicAnnouncementStatusCategory
    let scholarshipBoxViewModel = ScholarshipBoxViewModel()
    private let effortLevelTip = EffortLevelTip()
    
    var body: some View {
            VStack(alignment: .leading, spacing: 0) {
                navigation()
                ZStack(alignment: .bottom) {
                    switch viewModel.networkStatus {
                    case .loading:
                        ProgressView()
                    case .success:
                        ScrollView(.vertical) {
                            VStack(spacing: 0) {
                                detailThumbnail()
                                contentHeader()
                                    .padding(.vertical, 23)
                                customDivider()
                                    .padding(.vertical, 8)
                                recuirtInfoContent()
                                customDivider()
                                applicationDetail()
                                customDivider()
                                selectionProccess()
                                customDivider()
                                requirementContent()
                                customDivider()
                                    .padding(.bottom, 190)
                            }
                        }
                        buttons()
                    case .failed:
                        VStack {
                            Spacer()
                            ErrorToastView(.network)
                        }
                    }
                }
            }
        .onChange(of: scholarshipBoxViewModel.changedStatus) { oldValue, newValue in
            if let status = scholarshipBoxViewModel.changedStatus {
                viewModel.status = status
            }
        }
        .onAppear {
            viewModel.viewOpened(id, status)
        }
        .navigationBarBackButtonHidden()
    }
}


struct EffortLevelTip: Tip {
    var title: Text {
        //        Text("장학금을 지원하는 데 들어가는 노력 정도를 알려주는 수치예요")
        Text("수치예요")
    }
}

extension DetailScholarshipView {
    @ViewBuilder
    private func buttons() -> some View {
        HStack(spacing: 8) {
            Button {
                // 시트 콜
                viewModel.isStatusSheet = true
            } label: {
                HStack(spacing: 8) {
                    if let name = viewModel.status.IconNameDetailViewButton {
                        Icon(name: name, color: viewModel.status.detailViewButtonTextColor, size: 20)
                    }
                    
                    Text(viewModel.status.title)
                        .font(.title_xsm)
                }
                .padding(.vertical, 14)
                .padding(.horizontal, 24)
                .foregroundStyle(viewModel.status.detailViewButtonTextColor)
                .background(
                    Capsule()
                        .fill(viewModel.status.detailViewButtonColor)
                )
            }
            .sheet(isPresented: $viewModel.isStatusSheet) {
                ScholarshipPostingSheet(category: $viewModel.status, statusButtonPressed: { category in
                    if let detailContent = viewModel.detailContent {
                        scholarshipBoxViewModel.sheetStorageButtonPressed(id: String(detailContent.id), status: category) {
                                scholarshipStatusViewModel.addScholarship(id: String(detailContent.id), status: category)
                        }
                    }
                    viewModel.isStatusSheet = false
                })
            }
            
            if let url = viewModel.detailContent?.homePageUrl {
                Link(destination: URL(string: url )!) {
                    HStack(spacing: 8) {
                        Icon(name: .handFist, color: .white, size: 20)
                        
                        Text("지원하기")
                            .foregroundStyle(Color.white)
                            .font(.title_xsm)
                    }
                    .padding(.vertical, 14)
                    .padding(.horizontal, 24)
                    .background(
                        Capsule()
                            .fill(Color.mainGray)
                    )
                    .onAppear {
                        print(url)
                    }
                }
            }
        }
    }
    
    
    @ViewBuilder
    private func detailThumbnail() -> some View {
        Image("detailDefaultThumbnail")
            .resizable()
    }
    
    @ViewBuilder
    private func requirementContent() -> some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 0) {
                Text("자격요건")
                    .font(.title_xsm)
                    .foregroundStyle(.black)
                
                Spacer()
                // FIXME: 클릭시 chevron 방향 역전해야함
                Icon(name: .chevronDown, color: .black, size: 16)
                    .onTapGesture {
                        showRequirement.toggle()
                    }
            }
            .padding(.vertical, 16)
            
            if showRequirement {
                withAnimation {
                    VStack(alignment: .leading, spacing: 0) {
                        if let detailContent = viewModel.detailContent {
                            Text("[제출서류]")
                                .padding(.top, 8)
                                .padding(.bottom, 12)
                            Text(detailContent.universityCategory ?? "데이터 없음")
                                .padding(.bottom, 16)
                            Text("[학년구분]")
                                .padding(.top, 8)
                                .padding(.bottom, 12)
                            Text(detailContent.grade ?? "데이터 없음")
                                .padding(.bottom, 24)
                            Text("[학과구분]")
                                .padding(.top, 8)
                                .padding(.bottom, 12)
                            Text(detailContent.majorCategory ?? "데이터 없음")
                                .padding(.bottom, 24)
                            Text("[소득기준]")
                                .padding(.top, 8)
                                .padding(.bottom, 12)
                            Text(detailContent.incomeDetails ?? "데이터 없음")
                                .padding(.bottom, 24)
                            Text("[특정자격]")
                                .padding(.top, 8)
                                .padding(.bottom, 12)
                            
//                            Text(detailContent.specificQualificationDetails ?? "데이터 없음")
                            Text(formatCategory(detailContent.specificQualificationDetails))
                                .padding(.bottom, 24)
                            Text("[성적기준]")
                                .padding(.top, 8)
                                .padding(.bottom, 12)
//                            Text(detailContent.gradeDetails ?? "데이터 없음")
                            Text(formatCategory(detailContent.gradeDetails))
                                .padding(.bottom, 24)
                            Text("[지역기준여부]")
                                .padding(.top, 8)
                                .padding(.bottom, 12)
//                            Text(detailContent.localResidencyDetails ?? "데이터 없음")
                            Text(formatCategory(detailContent.localResidencyDetails))
                                .padding(.bottom, 24)
                            Text("[추천필요여부]")
                                .padding(.top, 8)
                                .padding(.bottom, 12)
//                            Text(detailContent.recommendationRequiredDetails ?? "데이터 없음")
                            Text(formatCategory(detailContent.recommendationRequiredDetails))
                                .padding(.bottom, 24)
                            if let restrictionDetail = detailContent.eligibilityRestrictionDetails,
                               restrictionDetail != "해당없음" {
                                VStack(spacing: 0) {
                                    HStack(spacing: 0) {
                                        Icon(name: .siren, color: .orange, size: 20)
                                        Text("자격제한")
                                            .font(.semi_title_md)
                                            .padding(.leading, 6)
                                        Spacer()
                                    }
                                    .padding(.top, 16)
                                    .foregroundStyle(.etcOrange)
                                    
//                                    Text(detailContent.eligibilityRestrictionDetails ?? "데이터 없음")
                                    Text(formatCategory(detailContent.eligibilityRestrictionDetails))
                                        .font(.text_sm)
                                        .padding(.top, 8)
                                        .padding(.bottom, 16)
                                        .foregroundStyle(.etcOrange)
                                }
                                .padding(.horizontal, 16)
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(.etcLightOrange)
                                )
                                .padding(.bottom, 24)
                            }
                        }
                    }
                    .font(.text_sm)
                    .foregroundStyle(.gray700)
                }
            }
        }
        .paddingHorizontal()
    }
    
    @ViewBuilder
    private func selectionProccess() -> some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 0) {
                Text("선발방법")
                    .font(.title_xsm)
                    .foregroundStyle(.black)
                
                Spacer()
                // FIXME: 클릭시 chevron 방향 역전해야함
                Icon(name: .chevronDown, color: .black, size: 16)
                    .onTapGesture {
                        showSelection.toggle()
                    }
            }
            .padding(.vertical, 16)
            
            if showSelection {
                if let detailContent = viewModel.detailContent {
                    withAnimation {
                        VStack(alignment: .leading, spacing: 0) {
                            Text("[제출서류]")
                                .padding(.top, 8)
                                .padding(.bottom, 12)
                            Text(formatCategory(detailContent.requiredDocumentDetails))
//                            Text(detailContent.requiredDocumentDetails ?? "데이터 없음")
                                .padding(.bottom, 16)
                            Text("[선발방법]")
                                .padding(.top, 8)
                                .padding(.bottom, 12)
//                            Text(detailContent.selectionMethodDetails ?? "데이터 없음")
                            Text(formatCategory(detailContent.selectionMethodDetails))
                                .padding(.bottom, 24)
                        }
                        .font(.text_sm)
                        .foregroundStyle(.gray700)
                    }
                }
            }
        }
        .paddingHorizontal()
    }
    
    @ViewBuilder
    private func customDivider() -> some View {
        Rectangle()
            .frame(height: 6)
            .foregroundStyle(.gray50)
    }
    
    @ViewBuilder
    private func applicationDetail() -> some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 0) {
                Text("지원내역")
                    .font(.title_xsm)
                    .foregroundStyle(.black)
                
                Spacer()
                // FIXME: 클릭시 chevron 방향 역전해야함
                Icon(name: .chevronDown, color: .black, size: 16)
                    .onTapGesture {
                        showApplication.toggle()
                    }
            }
            .padding(.vertical, 16)
            
            if showApplication {
                if let detailContent = viewModel.detailContent {
                    withAnimation {
                        VStack(alignment: .leading, spacing: 0) {
                            Text("[지원종류]")
                                .padding(.top, 8)
                                .padding(.bottom, 12)
                            
//                            Text(detailContent.recommendationRequiredDetails ?? "데이터 없음")
                            Text(formatCategory(detailContent.recommendationRequiredDetails))
                                .padding(.bottom, 24)
                        }
                        .font(.text_sm)
                        .foregroundStyle(.gray700)
                    }
                }
            }
        }
        .paddingHorizontal()
    }
    
    @ViewBuilder
    private func recuirtInfoContent() -> some View {
        VStack(alignment: .leading, spacing: 0) {
                
            HStack(spacing: 0) {
                Text("모집정보")
                    .font(.title_xsm)
                    .foregroundStyle(.black)
                    .padding(.vertical, 16)
                Spacer()
            }
            if let detailContent = viewModel.detailContent {
                VStack(alignment: .leading, spacing: 0) {
                    Text("[모집일자]")
                        .padding(.top, 8)
                    
                    Text("\(detailContent.startDate ?? "미정") ~ \(detailContent.endDate ?? "미정")")
                        .padding(.top, 12)
                    
                    Text("[수혜인원]")
                        .padding(.top, 24)
                    
//                    Text(detailContent.selectionCountDetails ?? "데이터 없음")
                    Text(formatCategory(detailContent.selectionCountDetails))
                        .padding(.top, 12)
                        .padding(.bottom, 24)
                }
                .font(.text_sm)
                .foregroundStyle(.gray700)
            }
        }
        .paddingHorizontal()
    }
    
    @ViewBuilder
    private func contentHeader() -> some View {
        if let detailContent = viewModel.detailContent {
            VStack(spacing: 0) {
                HStack {
                    Text(detailContent.organization ?? "데이터 없음")
                        .font(.semi_title_md)
                    Spacer()
                    HStack(spacing: 4) {
                        Icon(name: .eye, color: .gray400, size: 16)
                        Text("\(detailContent.viewCount ?? 0)")
                            .font(.text_caption)
                    }
                }
                .foregroundStyle(.gray500)
                
                HStack {
                    Text(detailContent.productName ?? "데이터 없음")
                        .font(.title_xmd)
                        .padding(.top, 8)
                    Spacer()
                }
                .foregroundStyle(.black)
                .padding(.bottom, 32)
                
                HStack(spacing: 0) {
                    Spacer()
                    VStack(spacing: 12) {
                        Text("마감일")
                            .foregroundStyle(.black)
                        
                        if detailContent.endDate != nil {
                            Text(
                                Date()
                                    .calculationDday(endDateString: detailContent.endDate!) == "0"
                                ? "D-Day"
                                : "D\(Date().calculationDday(endDateString: detailContent.endDate!))")
                                .foregroundStyle(.destructiveRed)
                        }
                    }
                    .font(.semi_title_md)
                    
                    Spacer()
                    Rectangle()
                        .frame(width: 1, height: 50)
                        .foregroundStyle(.gray100)
                    Spacer()
                    
                    VStack(spacing: 12) {
                        Text("지원금액")
                            .foregroundStyle(.black)
                        Text(detailContent.formattedSupportDetails ?? "상세 공고 확인")
                    }
                    .font(.semi_title_md)
                    
                    Spacer()
                    Rectangle()
                        .frame(width: 1, height: 50)
                        .foregroundStyle(.gray100)
                    Spacer()
                    
                    VStack(spacing: 4) {
                        
                        HStack(spacing: 4) {
                            Text("노력지수")
                                .foregroundStyle(.black)
                            // TODO: 팝오버 만들기
                            Icon(name: .question, size: 16)
                        }
                        .font(.semi_title_md)
                        
                        HStack(spacing: 4) {
                            // TODO: 노력지수 꾸미기
                            Text("중")
                            Icon(name: .batteryMedium, size: 28)
                        }
                        
                    }
                    Spacer()
                }
            }
            .paddingHorizontal()
        }
    }
    
    @ViewBuilder
    private func navigation() -> some View {
        HStack(spacing: 0) {
            Icon(name: .arrowLeft, color: .black, size: 28)
                .onTapGesture {
                    dismiss()
                }
            Spacer()
            Text("상세")
                .font(.title_xsm)
            Spacer()
            Icon(name: .share, color: .black, size: 28)
                .onTapGesture {
                    viewModel.shareButtonPressed()
                }
        }
        .paddingHorizontal()
        .foregroundStyle(.black)
        .backgroundStyle(.white)
        .padding(.top, 12)
        .padding(.bottom, 16)
    }
    
    func formatCategory(_ category: String?) -> String {
        guard let category = category, category.contains("○") else {
            return category ?? "데이터 없음"
        }
        
        let bulletPoints = category.components(separatedBy: "○")
            .filter { !$0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
        
        return bulletPoints.enumerated().map { index, point in
            let trimmedPoint = point.trimmingCharacters(in: .whitespacesAndNewlines)
            return index == 0 ? "• \(trimmedPoint)" : "\n• \(trimmedPoint)"
        }.joined()
    }
}

#Preview {
    DetailScholarshipView(id: "22", status: .applied)
        .environmentObject(PathModel())
}
