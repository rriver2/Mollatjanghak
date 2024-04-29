//
//  DetailScholarshipView.swift
//  janghakhere
//
//  Created by Gaeun Lee on 4/16/24.
//

import SwiftUI
import TipKit

struct DetailScholarshipView: View {
    @EnvironmentObject private var pathModel: PathModel
    @Environment(\.dismiss) private var dismiss
    let id: String
    
    @StateObject private var viewModel = DetailScholarshipViewModel()
    @State private var showApplication: Bool = true
    @State private var showSelection: Bool = true
    @State private var showRequirement: Bool = true
    private let effortLevelTip = EffortLevelTip()
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            navigation()
            ScrollView(.vertical) {
                detailThumbnail()
                contentHeader()
                    .padding(.vertical, 23)
                buttons()
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
        .onAppear {
            viewModel.viewOpened(id)
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
            } label: {
                HStack(spacing: 8) {
                    Icon(name: .floppyDisk, color: .mainGray, size: 20)
                    Text("공고저장")
                        .font(.title_xsm)
                }
                .padding(.vertical, 14)
                .padding(.horizontal, 24)
                .foregroundStyle(.mainGray)
                .background(
                    Capsule()
                        .fill(.gray70)
                )
            }
//            Button {
//                
//            } label: {
//                HStack(spacing: 8) {
//                    Icon(name: .floppyDisk, color: .white, size: 20)
//                    Text("저장완료")
//                        .font(.title_xsm)
//                }
//                .padding(.vertical, 14)
//                .padding(.horizontal, 24)
//                .foregroundStyle(.white)
//                .background(
//                    Capsule()
//                        .fill(.subGreen)
//                )
//            }
//            Button {
//                
//            } label: {
//                HStack(spacing: 8) {
//                    Icon(name: .fire, color: .white, size: 20)
//                    Text("지원예정")
//                        .font(.title_xsm)
//                }
//                .padding(.vertical, 14)
//                .padding(.horizontal, 24)
//                .foregroundStyle(.white)
//                .background(
//                    Capsule()
//                        .fill(.subPink)
//                )
//            }
//            Button {
//                // 시트 콜
//            } label: {
//                HStack(spacing: 8) {
//                    Icon(name: .check, color: .white, size: 20)
//                    Text("지원완료")
//                        .font(.title_xsm)
//                }
//                .padding(.vertical, 14)
//                .padding(.horizontal, 24)
//                .foregroundStyle(.white)
//                .background(
//                    Capsule()
//                        .fill(.subPurple)
//                )
//            }
            
            Button {
                // 웹뷰 열기
            } label: {
                HStack(spacing: 8) {
                    Icon(name: .handFist, color: .white, size: 20)
                    Text("지원하기")
                        .font(.title_xsm)
                }
                .padding(.vertical, 14)
                .padding(.horizontal, 24)
                .foregroundStyle(.white)
                .background(
                    Capsule()
                        .fill(.mainGray)
                )
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
                        withAnimation {
                            showSelection.toggle()
                        }
                    }
            }
            .padding(.vertical, 16)
            
            if showSelection {
                withAnimation {
                    VStack(alignment: .leading, spacing: 0) {
                        Text("[제출서류]")
                            .padding(.top, 8)
                            .padding(.bottom, 12)
                        Text(viewModel.universityCategory)
                            .padding(.bottom, 16)
                        Text("[학년구분]")
                            .padding(.top, 8)
                            .padding(.bottom, 12)
                        Text(viewModel.grade)
                            .padding(.bottom, 24)
                        Text("[학과구분]")
                            .padding(.top, 8)
                            .padding(.bottom, 12)
                        Text(viewModel.majorCategory)
                            .padding(.bottom, 24)
                        Text("[소득기준]")
                            .padding(.top, 8)
                            .padding(.bottom, 12)
                        Text(viewModel.incomeDetails)
                            .padding(.bottom, 24)
                        Text("[특정자격]")
                            .padding(.top, 8)
                            .padding(.bottom, 12)
                        Text(viewModel.specificQualificationDetails)
                            .padding(.bottom, 24)
                        Text("[성적기준]")
                            .padding(.top, 8)
                            .padding(.bottom, 12)
                        Text(viewModel.gradeDetails)
                            .padding(.bottom, 24)
                        Text("[지역기준여부]")
                            .padding(.top, 8)
                            .padding(.bottom, 12)
                        Text(viewModel.localResidencyDetails)
                            .padding(.bottom, 24)
                        Text("[추천필요여부]")
                            .padding(.top, 8)
                            .padding(.bottom, 12)
                        Text(viewModel.recommendationRequiredDetails)
                            .padding(.bottom, 24)
                        
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
                            Text(viewModel.eligibilityRestrictionDetails)
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
                    .font(.text_sm)
                    .foregroundStyle(.gray500)
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
                        withAnimation {
                            showSelection.toggle()
                        }
                    }
            }
            .padding(.vertical, 16)
            
            if showSelection {
                withAnimation {
                    VStack(alignment: .leading, spacing: 0) {
                        Text("[제출서류]")
                            .padding(.top, 8)
                            .padding(.bottom, 12)
                        Text(viewModel.requiredDocumentDetails)
                            .padding(.bottom, 16)
                        Text("[선발방법]")
                            .padding(.top, 8)
                            .padding(.bottom, 12)
                        Text(viewModel.selectionMethodDetails)
                            .padding(.bottom, 24)
                    }
                    .font(.text_sm)
                    .foregroundStyle(.gray500)
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
                        withAnimation {
                            showApplication.toggle()
                        }
                    }
            }
            .padding(.vertical, 16)
            
            if showApplication {
                withAnimation {
                    VStack(alignment: .leading, spacing: 0) {
                        Text("[지원종류]")
                            .padding(.top, 8)
                            .padding(.bottom, 12)
                        Text(viewModel.recommendationRequiredDetails)
                            .padding(.bottom, 24)
                    }
                    .font(.text_sm)
                    .foregroundStyle(.gray500)
                }
            }
        }
        .paddingHorizontal()
    }
    
    @ViewBuilder
    private func recuirtInfoContent() -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("모집정보")
                .font(.title_xsm)
                .foregroundStyle(.black)
                .padding(.vertical, 16)
            
            VStack(alignment: .leading, spacing: 0) {
                Text("[모집일자]")
                    .padding(.top, 8)
                Text("\(viewModel.startDate) ~ \(viewModel.endDate)")
                    .padding(.top, 12)
                
                Text("[수혜인원]")
                    .padding(.top, 24)
                Text(viewModel.selectionCountDetails)
                    .padding(.top, 12)
                    .padding(.bottom, 24)
            }
            .font(.text_sm)
            .foregroundStyle(.gray500)
        }
        .paddingHorizontal()
    }
    
    @ViewBuilder
    private func contentHeader() -> some View {
        VStack(spacing: 0) {
            HStack {
                Text(viewModel.organization)
                    .font(.semi_title_md)
                Spacer()
                HStack(spacing: 4) {
                    Icon(name: .eye, color: .gray400, size: 16)
                    Text(viewModel.viewCount)
                        .font(.text_caption)
                }
            }
            .foregroundStyle(.gray400)
            
            HStack {
                Text(viewModel.productName)
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
                    
                    Text(viewModel.deadline)
                        .foregroundStyle(.destructiveRed)
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
                    
                    Text(viewModel.money)
                }
                .font(.semi_title_md)
                
                Spacer()
                Rectangle()
                    .frame(width: 1, height: 50)
                    .foregroundStyle(.gray100)
                Spacer()
                
                VStack(spacing: 12) {
                    HStack(spacing: 4) {
                        Text("노력지수")
                            .foregroundStyle(.black)
                        // TODO: 팝오버 만들기
                        Icon(name: .question, size: 16)
                    }
                    .font(.semi_title_md)
                    
                    HStack {
                        // TODO: 노력지수 꾸미기
                        Text("중")
                    }
                }
                Spacer()
            }
        }
        .paddingHorizontal()
    }
    
    @ViewBuilder
    private func navigation() -> some View {
        HStack(spacing: 0) {
            Icon(name: .arrowLeft, color: .black, size: 28)
                .padding(.trailing, 10)
                .onTapGesture {
                    dismiss()
                }
            Spacer()
            Text("상세")
                .font(.title_xsm)
            Spacer()
            Icon(name: .share, color: .black, size: 28)
                .padding(.trailing, 10)
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
}

#Preview {
    DetailScholarshipView(id: UUID().uuidString)
}
