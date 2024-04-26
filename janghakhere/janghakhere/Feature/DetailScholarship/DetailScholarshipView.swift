//
//  DetailScholarshipView.swift
//  janghakhere
//
//  Created by Gaeun Lee on 4/16/24.
//

import SwiftUI

struct DetailScholarshipView: View {
    @EnvironmentObject private var pathModel: PathModel
    @Environment(\.dismiss) private var dismiss
    let id: String
    
    @StateObject private var viewModel = DetailScholarshipViewModel()
    
    var body: some View {
        VStack(spacing: 0) {
            navigation()
            Spacer()
        }
        .onAppear {
            viewModel.viewOpened(id)
        }
        .navigationBarBackButtonHidden()
    }
}

extension DetailScholarshipView {
    @ViewBuilder
    func navigation() -> some View {
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
        .padding(.top, 12)
        .padding(.bottom, 16)
        .background(.white)
    }
}

#Preview {
    DetailScholarshipView(id: UUID().uuidString)
}
