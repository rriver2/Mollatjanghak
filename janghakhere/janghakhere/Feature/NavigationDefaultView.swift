//
//  NavigationDefaultView.swift
//  janghakhere
//
//  Created by Gaeun Lee on 4/27/24.
//

import SwiftUI

struct NavigationDefaultView: View {
    @Environment(\.dismiss) private var dismiss
    
    let title: String
    
    var body: some View {
        HStack(spacing: 0) {
            Icon(name: .arrowLeft, color: .black, size: 28)
                .onTapGesture {
                    dismiss()
                }
            Spacer()
            Text(title)
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
}
