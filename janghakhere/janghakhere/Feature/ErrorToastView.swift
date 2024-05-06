//
//  ErrorToastView.swift
//  janghakhere
//
//  Created by Gaeun Lee on 5/6/24.
//

import SwiftUI

enum ErrorToastCategory {
    case network
    
    var title: String {
        switch self {
        case .network:
            "네트워크 연결이 불안정해요"
        }
    }
    
    var icon: ImageResource {
        switch self {
        case .network:
                .wifi
        }
    }
}

struct ErrorToastView: View {
    let error: ErrorToastCategory
    @State var isShowAlert = true
    
    init(_ category: ErrorToastCategory = .network) {
        self.error = category
    }
    
    var body: some View {
        VStack(spacing: 0) {
            if isShowAlert {
                HStack(spacing: 8) {
                    Icon(name: error.icon, size: 20)
                    Text(error.title)
                        .font(.semi_title_md)
                        .foregroundStyle(.white)
                }
                .padding(.vertical, 12)
                .padding(.horizontal, 16)
                .background(.mainGray)
                .cornerRadius(8)
                .padding(.bottom, 16)
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        isShowAlert = false
                    }
                }
            } else {
                EmptyView()
            }
        }
        .animation(.easeOut(duration: 0.3), value: isShowAlert)
    }
}

#Preview {
    ErrorToastView()
}
