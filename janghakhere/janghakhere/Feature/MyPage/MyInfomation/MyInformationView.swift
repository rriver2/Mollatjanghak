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
    
    var body: some View {
#if DEBUG
        if #available (iOS 17.1, *) {
            Self._printChanges()
        }
#endif
        return VStack(spacing: 0) {
            subView()
        }
        .task {
            viewModel.createView()
        }
        .onDisappear {
            viewModel.cancelTasks()
        }
    }
}

extension MyInformationView {
    @ViewBuilder
    func subView() -> some View {
        VStack(spacing: 0) {
            Text("MyInformationView")
        }
    }
}

#Preview {
    MyInformationView()
}
