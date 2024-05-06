//
//  ServiceAgreementView.swift
//  janghakhere
//
//  Created by Taehwan Kim on 5/6/24.
//

import SwiftUI

struct ServiceAgreementView: View {
    @EnvironmentObject private var pathModel: PathModel
    @Environment(\.dismiss) var dismiss
    @State private var totalAgree: Bool = false
    @State private var serviceAgree: Bool = false
    @State private var privacyAgree: Bool = false
    @State private var ageAgree: Bool = false
    let serviceUrl = Bundle.main.url(forResource: "ServiceAgreement", withExtension: "pdf")!
    let privacyUrl = Bundle.main.url(forResource: "PrivacyAgreement", withExtension: "pdf")!
    @State private var showService = false
    @State private var showPrivacy = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("여깄장학 사용을 위해\n약관 동의가 필요해요!")
                .font(.title_md)
                .foregroundStyle(.black)
                .padding(.top, 48)
                .padding(.bottom, 32)
            HStack(spacing: 0) {
                Icon(
                    name: .check,
                    color: totalAgree
                    ? .white
                    : .gray300,
                    size: 16
                )
                .padding(.leading, 20)
                .padding(.trailing, 12)
                
                Text("전체동의")
                    .font(.title_xsm)
                    .foregroundStyle(
                        totalAgree
                        ? .white
                        : .black)
                    .padding(.vertical, 19)
                Spacer()
            }
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(
                        totalAgree
                        ? .mainGray
                        : .gray60)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(totalAgree ? .mainGray : .gray300, lineWidth: 1)
                    )
            )
            .padding(.bottom, 32)
            .onTapGesture {
                totalAgree.toggle()
            }
            
            VStack(alignment: .leading, spacing: 12) {
                Text("장학금 추천 서비스 이용을 위한 약관")
                    .font(.title_xsm)
                    .foregroundStyle(.black)
                    .padding(.bottom, 16)
                
                HStack(spacing: 0) {
                    HStack(spacing: 12) {
                        Icon(
                            name: .check,
                            color: serviceAgree
                            ? .mainGray
                            : .gray300,
                            size: 16
                        )
                        Text("[필수] 서비스 이용 약관 및 동의")
                            .font(.text_md)
                            .foregroundStyle(.black)
                    }
                    .onTapGesture {
                        serviceAgree.toggle()
                    }
                    
                    Spacer()
                    Text("보기")
                        .font(.semi_title_md)
                        .foregroundStyle(.gray600)
                        .underline()
                        .onTapGesture {
                            showService.toggle()
                        }
                }
                HStack(spacing: 0) {
                    HStack(spacing: 12) {
                        Icon(
                            name: .check,
                            color: privacyAgree
                            ? .mainGray
                            : .gray300,
                            size: 16
                        )
                        Text("[필수] 개인정보 수집 이용 동의")
                            .font(.text_md)
                            .foregroundStyle(.black)
                    }
                    .onTapGesture {
                        privacyAgree.toggle()
                    }
                    Spacer()
                    Text("보기")
                        .font(.semi_title_md)
                        .foregroundStyle(.gray600)
                        .underline()
                        .onTapGesture {
                            showPrivacy.toggle()
                        }
                }
                
                HStack(spacing: 0) {
                    HStack(spacing: 12) {
                        Icon(
                            name: .check,
                            color: ageAgree
                            ? .mainGray
                            : .gray300,
                            size: 16
                        )
                        Text("[필수] 만 14세 이상입니다")
                            .font(.text_md)
                            .foregroundStyle(.black)
                    }
                    .onTapGesture {
                        ageAgree.toggle()
                    }
                    Spacer()
                }
            }
            .padding(.leading, 20)
            
            Spacer()
            
            MainButtonView(
                title: "확인",
                action: {
                    dismiss()
                    pathModel.paths.append(.onboardingMainView)
                },
                disabled: !totalAgree || !(serviceAgree && privacyAgree && ageAgree)
            )
            .padding(.bottom, 12)
        }
        .padding(.horizontal, 28)
        .presentationDetents([.large])
        .onChange(of: totalAgree) { oldValue, newValue in
            if oldValue == false && newValue == true {
                serviceAgree = true
                privacyAgree = true
                ageAgree = true
            } else {
                serviceAgree = false
                privacyAgree = false
                ageAgree = false
            }
        }
        .onChange(of: serviceAgree) { oldValue, newValue in
            if privacyAgree, ageAgree, newValue {
                totalAgree = true
            } else {
                totalAgree = false
            }
        }
        .onChange(of: privacyAgree) { oldValue, newValue in
            if serviceAgree, ageAgree, newValue {
                totalAgree = true
            } else {
                totalAgree = false
            }
        }
        .onChange(of: ageAgree) { oldValue, newValue in
            if privacyAgree, serviceAgree, newValue {
                totalAgree = true
            } else {
                totalAgree = false
            }
        }
        .sheet(isPresented: $showService) {
            PDFViewerView(url: serviceUrl)
        }
        .sheet(isPresented: $showPrivacy) {
            PDFViewerView(url: privacyUrl)
        }
    }
    
    
    private func updateAgreements() {
        if serviceAgree && privacyAgree && ageAgree {
            totalAgree = true
        } else {
            totalAgree = false
        }
    }
}

#Preview {
    ServiceAgreementView()
}
