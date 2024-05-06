//
//  MyInformationView.swift
//  janghakhere
//
//  Created by Taehwan Kim on 5/1/24.
//

import SwiftUI

struct MyInformationView: View {
    @EnvironmentObject private var pathModel: PathModel
    @StateObject private var viewModel = MyInformationViewModel()
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
#if DEBUG
        if #available (iOS 17.1, *) {
            Self._printChanges()
        }
#endif
        return VStack(spacing: 0) {
            navigation()
            ScrollView(.vertical) {
                announceScholarshipCriteria()
                nameSection()
                sexSection()
                militaryServiceSection()
                birthDateSection()
                schoolSection()
                incomeSection()
                sibilingSection()
                etcSection()
            }
            .scrollIndicators(.hidden)
            Spacer()
        }
        .padding(.horizontal, 20)
        .task {
            viewModel.createView()
        }
        .onDisappear {
            viewModel.cancelTasks()
        }
        .ignoresSafeArea(edges: .bottom)
    }
}

extension MyInformationView {
    
    @ViewBuilder
    func nameSection() -> some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 0) {
                Text("이름")
                    .font(.semi_title_md)
                    .foregroundStyle(.gray400)
                    .padding(.leading, 8)
                    .padding(.bottom, 8)
                Spacer()
            }

            TextField("", text: $viewModel.name)
                .font(.text_md)
                .padding(.vertical, 16)
                .padding(.leading, 16)
                .foregroundStyle(.black)
                .autocorrectionDisabled()
                .background(
                    .gray50,
                    in: RoundedRectangle(cornerRadius: 10)
                )
        }
        .padding(.bottom, 16)
    }
    
    @ViewBuilder
    func sexSection() -> some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 0) {
                Text("성별")
                    .font(.semi_title_md)
                    .foregroundStyle(.gray400)
                    .padding(.leading, 8)
                    .padding(.bottom, 8)
                Spacer()
            }
            HStack(spacing: 16) {
                Button {
                    viewModel.sex = .male
                } label: {
                    Text("남자")
                        .font(.text_md)
                        .foregroundStyle(viewModel.sex == .male ? .white : .black)
                        .padding(.vertical, 16)
                        .frame(maxWidth: .infinity)
                        .background(
                            viewModel.sex == .male ? .mainGray : .gray50,
                            in: RoundedRectangle(cornerRadius: 10)
                        )
                }
                
                Button {
                    viewModel.sex = .female
                } label: {
                    Text("여자")
                        .font(.text_md)
                        .foregroundStyle(viewModel.sex == .female ? .white : .black)
                        .padding(.vertical, 16)
                        .frame(maxWidth: .infinity)
                        .background(
                            viewModel.sex == .female ? .mainGray : .gray50,
                            in: RoundedRectangle(cornerRadius: 10)
                        )
                }
            }
        }
//        .padding(.bottom, 32)
        .padding(.bottom, 24)
    }
    
    @ViewBuilder
    func militaryServiceSection() -> some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 0) {
                Text("병역")
                    .font(.semi_title_md)
                    .foregroundStyle(.gray400)
                    .padding(.leading, 8)
                    .padding(.bottom, 8)
                Spacer()
            }
            
            HStack(spacing: 16) {
                Button {
                    viewModel.militaryStatus = .served
                } label: {
                    Text("군필")
                        .font(.text_md)
                        .foregroundStyle(viewModel.militaryStatus == .served ? .white : .black)
                        .padding(.vertical, 16)
                        .frame(maxWidth: .infinity)
                        .background(
                            viewModel.militaryStatus == .served ? .mainGray : .gray50,
                            in: RoundedRectangle(cornerRadius: 10)
                        )
                }
                Button {
                    viewModel.militaryStatus = .notServed
                } label: {
                    Text("미필")
                        .font(.text_md)
                        .foregroundStyle(viewModel.militaryStatus == .notServed ? .white : .black)
                        .padding(.vertical, 16)
                        .frame(maxWidth: .infinity)
                        .background(
                            viewModel.militaryStatus == .notServed ? .mainGray : .gray50,
                            in: RoundedRectangle(cornerRadius: 10)
                        )
                }
                Button {
                    viewModel.militaryStatus = .exempt
                } label: {
                    Text("면제자")
                        .font(.text_md)
                        .foregroundStyle(viewModel.militaryStatus == .exempt ? .white : .black)
                        .padding(.vertical, 16)
                        .frame(maxWidth: .infinity)
                        .background(
                            viewModel.militaryStatus == .exempt ? .mainGray : .gray50,
                            in: RoundedRectangle(cornerRadius: 10)
                        )
                }
            }
        }
        .padding(.bottom, 24)
    }
    
    @ViewBuilder
    func birthDateSection() -> some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 0) {
                Text("생년월일")
                    .font(.semi_title_md)
                    .foregroundStyle(.gray400)
                    .padding(.leading, 8)
                    .padding(.bottom, 8)
                Spacer()
            }
            Button {
                // TODO: 생년월일
            } label: {
                HStack(spacing: 0) {
                    Text(String(viewModel.birth))
                    Spacer()
                    Icon(name: .chevronRight, color: .black, size: 16)
                }
                .font(.text_md)
                .foregroundStyle(.black)
                .padding(.vertical, 16)
                .padding(.horizontal, 16)
                .background(
                    .gray50,
                    in: RoundedRectangle(cornerRadius: 10)
                )
            }
        }
        .padding(.bottom, 24)
    }
    
    @ViewBuilder
    func horizontalDivider() -> some View {
        Rectangle()
            .frame(height: 1)
            .foregroundStyle(.gray100)
    }
    
    @ViewBuilder
    func schoolSection() -> some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 0) {
                Text("학교정보")
                    .font(.semi_title_md)
                    .foregroundStyle(.gray400)
                    .padding(.leading, 8)
                    .padding(.bottom, 8)
                Spacer()
            }
            VStack(spacing:16) {
                
                Button {
                    // 학교 호출
                } label: {
                    HStack(spacing: 0) {
                        Text("학교")
                            .font(.semi_title_md)
                            .foregroundStyle(.gray600)
                        Spacer()
                        Text(viewModel.schoolName.description)
                            .font(.text_md)
                            .foregroundStyle(.black)
                            .padding(.trailing, 16)
                        Icon(name: .chevronRight, color: .black, size: 16)
                    }
                }
                horizontalDivider()
                
                Button {
                    // 학년 교정 시트
                } label: {
                    HStack(spacing: 0) {
                        Text("학년")
                            .font(.semi_title_md)
                            .foregroundStyle(.gray600)
                        Spacer()
                        Text(viewModel.schoolYear.description)
                            .font(.text_md)
                            .foregroundStyle(.black)
                            .padding(.trailing, 16)
                        Icon(name: .chevronRight, color: .black, size: 16)
                    }
                }
                
                
                horizontalDivider()
                Button {
                    // 학교 호출
                } label: {
                    HStack(spacing: 0) {
                        Text("전공계열")
                            .font(.semi_title_md)
                            .foregroundStyle(.gray600)
                        Spacer()
                        Text(viewModel.majorField.description)
                            .font(.text_md)
                            .foregroundStyle(.black)
                            .padding(.trailing, 16)
                        Icon(name: .chevronRight, color: .black, size: 16)
                    }
                }
                
                
                horizontalDivider()
                
                VStack(spacing: 0) {
                    Button {
                        // 학점 기준
                    } label: {
                        HStack(spacing: 0) {
                            Text("학점기준")
                                .font(.semi_title_md)
                                .foregroundStyle(.gray600)
                            Spacer()
                            Icon(name: .chevronRight, color: .black, size: 16)
                        }
                    }
                    .padding(.bottom, 12)
                    
                    HStack(spacing: 0) {
                        Text("직전학기")
                            .font(.text_md)
                            .foregroundStyle(.gray700)
                        
                        Spacer()
                        
                        Text(viewModel.lastSemesterGrade)
                            .font(.text_md)
                            .foregroundStyle(.gray700)
                    }
                    .padding(.vertical, 8)
                    .padding(.leading, 16)
                    .padding(.trailing, 18)
                    .background(
                        .gray70,
                        in: RoundedRectangle(cornerRadius: 6)
                    )
                    .padding(.bottom, 8)
                    
                    HStack(spacing: 0) {
                        Text("전체학기")
                            .font(.text_md)
                            .foregroundStyle(.gray700)
                        
                        Spacer()
                        
                        Text(viewModel.totalGrade)
                            .font(.text_md)
                            .foregroundStyle(.gray700)
                    }
                    .padding(.vertical, 8)
                    .padding(.leading, 16)
                    .padding(.trailing, 18)
                    .background(
                        .gray70,
                        in: RoundedRectangle(cornerRadius: 6)
                    )
                }
                
                horizontalDivider()
                Button {
                    // 학교 호출
                } label: {
                    HStack(spacing: 0) {
                        Text("총 학점")
                            .font(.semi_title_md)
                            .foregroundStyle(.gray600)
                        Spacer()
                        Text(viewModel.totalGrade)
                            .font(.text_md)
                            .foregroundStyle(.black)
                            .padding(.trailing, 16)
                        Icon(name: .chevronRight, color: .black, size: 16)
                    }
                }
            }
            .padding(16)
            .background(
                .gray50,
                in: RoundedRectangle(cornerRadius: 10)
            )
        }
        .padding(.bottom, 32)
    }
    
    @ViewBuilder
    func incomeSection() -> some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 0) {
                Text("소득구간")
                    .font(.semi_title_md)
                    .foregroundStyle(.gray400)
                    .padding(.leading, 8)
                    .padding(.bottom, 8)
                Spacer()
            }
            Button {
                // TODO: 생년월일
            } label: {
                HStack(spacing: 0) {
                    Text(viewModel.incomeStatus.description)
                    Spacer()
                    Icon(name: .chevronRight, color: .black, size: 16)
                }
                .font(.text_md)
                .foregroundStyle(.black)
                .padding(.vertical, 20)
                .padding(.horizontal, 16)
                .background(
                    .gray50,
                    in: RoundedRectangle(cornerRadius: 10)
                )
            }
        }
        .padding(.bottom, 32)
    }
    
    @ViewBuilder
    func sibilingSection() -> some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 0) {
                Text("형제")
                    .font(.semi_title_md)
                    .foregroundStyle(.gray400)
                    .padding(.leading, 8)
                    .padding(.bottom, 8)
                Spacer()
            }
            Button {
                // TODO: 생년월일
            } label: {
                HStack(spacing: 0) {
                    Text(viewModel.siblingStatus.description)
                    Spacer()
                    Icon(name: .chevronRight, color: .black, size: 16)
                }
                .font(.text_md)
                .foregroundStyle(.black)
                .padding(.vertical, 20)
                .padding(.horizontal, 16)
                .background(
                    .gray50,
                    in: RoundedRectangle(cornerRadius: 10)
                )
            }
        }
        .padding(.bottom, 32)
    }
    
    @ViewBuilder
    func etcSection() -> some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 0) {
                Text("기타")
                    .font(.semi_title_md)
                    .foregroundStyle(.gray400)
                    .padding(.leading, 8)
                    .padding(.bottom, 8)
                Spacer()
            }
            .padding(.bottom, 8)
            
            // 칩을 넣기
        }
        .padding(.bottom, 184)
    }
    
    @ViewBuilder
    func announceScholarshipCriteria() -> some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                Icon(
                    name: .megaphone,
                    color: Color(hex: "D19204") ?? .etcOrange,
                    size: 20)
                Text("장학금 안내 기준")
                    .font(.semi_title_md)
                    .padding(.leading, 6)
                Spacer()
            }
            .padding(.top, 16)
            .foregroundStyle(Color(hex: "D19204") ?? .etcOrange)
            Text("여깄장학은 입력된 정보를 바탕으로 \(viewModel.name)님에게 적절한 장학금을 선별해서 추천해 드려요.")
                .lineSpacing(/*@START_MENU_TOKEN@*/10.0/*@END_MENU_TOKEN@*/)
                .font(.text_sm)
                .padding(.top, 8)
                .padding(.bottom, 16)
                .foregroundStyle(Color(hex: "D19204") ?? .etcOrange)
        }
        .padding(.horizontal, 16)
        .background(
            Color(hex: "FEF8EC") ?? .etcLightOrange,
            in: RoundedRectangle(cornerRadius: 10)
        )
        .padding(.top, 16)
        .padding(.bottom, 16)
    }
    
    @ViewBuilder
    private func navigation() -> some View {
        HStack(spacing: 0) {
            Icon(name: .arrowLeft, color: .black, size: 28)
                .padding(.vertical, 14)
                .onTapGesture{ dismiss() }
            Spacer()
            Text("내 정보")
                .font(.title_xsm)
                .foregroundStyle(.black)
            Spacer()
            Button {
                // TODO: 저장 기능
            } label: {
                Text("저장")
                    .font(.title_xsm)
                    .foregroundStyle(.black)
            }
        }
    }
}

#Preview {
    MyInformationView()
}
