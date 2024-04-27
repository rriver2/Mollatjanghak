//
//  WebTotalView.swift
//  janghakhere
//
//  Created by Gaeun Lee on 4/27/24.
//

import SwiftUI

struct WebTotalView: View {
    @State var workState = WebView.WorkState.initial
    let url: URL
    
    var body: some View {
    ZStack(alignment: .center) {
        WebView(workState: self.$workState, url: url)
        switch workState {
        case .initial, .working, .tryagain:
            ProgressView()
        case .done:
            EmptyView()
        case .errorOccurred:
            VStack(spacing: 0) {
                Spacer()
                Text("에러 ~~")
                Spacer()
            }
            .frame(maxWidth: .infinity)
        }
    }
    }
}
