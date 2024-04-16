//
//  MyScholarshipView.swift
//  janghakhere
//
//  Created by Gaeun Lee on 4/16/24.
//

import SwiftUI

struct MyScholarshipView: View {
    @EnvironmentObject private var pathModel: PathModel
    
    var body: some View {
        Button {
            pathModel.paths.append(.detailScholarshipView(id: "id"))
            // 삭제시에는 pathModel.paths.removeLast()
        } label: {
            Text("Hello, World!")
        }
    }
}

#Preview {
    MyScholarshipView()
}
