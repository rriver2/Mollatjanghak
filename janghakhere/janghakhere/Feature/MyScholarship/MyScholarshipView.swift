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
        
        VStack {
            ChipsGroupView(chips: [.init(title: "긴급지원"), .init(title: "성적장학금"), .init(title: "에코"), .init(title: "국가장학금"), .init(title: "시흥시인재양성재단")])
            Button {
                pathModel.paths.append(.detailScholarshipView(id: "id"))
                // 삭제시에는 pathModel.paths.removeLast()
            } label: {
                Text("이거 버튼이 텍스트가 Hello World라 뭔가 싶었네요 ㅋㅋ")
            }
        }
    }
}

#Preview {
    MyScholarshipView()
}
