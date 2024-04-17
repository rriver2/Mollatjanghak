//
//  GrayBoxGridView.swift
//  janghakhere
//
//  Created by Gaeun Lee on 4/17/24.
//

import SwiftUI

struct GrayBoxGridView: View {
    
    enum ColumnCategory {
        case two
        case three
        
        var verticalPadding: CGFloat{
            switch self {
            case .two:
                20
            case .three:
                16
            }
        }
        
        var gridItemList: [GridItem] {
            let gridItem = GridItem(.flexible(), spacing: 16, alignment: .leading)
            switch self {
            case .two:
                return Array(repeating: gridItem, count: 2)
            case .three:
                return Array(repeating: gridItem, count: 3)
            }
        }
    }
    
    private let column: ColumnCategory
    private let titleList: [String]
    private let clickedButton: (() -> Void)
    
    init(column: ColumnCategory, titleList: [String], clickedButton: @escaping () -> Void) {
        self.titleList = titleList
        self.clickedButton = clickedButton
        self.column = column
    }
    
    var body: some View {
        LazyVGrid(columns: column.gridItemList, spacing: column.verticalPadding) {
            ForEach(titleList, id : \.self){ title in
                Button {
                    clickedButton()
                } label: {
                    Text(title)
                        .font(.title_xsm)
                        .padding(.vertical, 13)
                        .foregroundStyle(.gray600)
                        .frame(maxWidth: .infinity)
                        .background(Color.gray70)
                        .cornerRadius(4)
                }
            }
        }
    }
}

#Preview {
    GrayBoxGridView(column: .three, titleList: ["인문", "사회", "교육", "자연", "공학", "의약", "예체능", "기타"], clickedButton: {})
}
