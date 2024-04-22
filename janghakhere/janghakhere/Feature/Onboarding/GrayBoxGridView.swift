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
    
     let column: ColumnCategory
     let titleList: [String]
     let clickedButton: (() -> Void)
    @Binding var selectedElement: String
    
//    init(
//        column: ColumnCategory,
//        titleList: [String],
//        clickedButton: @escaping () -> Void,
//        selectedElement: Binding<String>
//    ) {
//        self.titleList = titleList
//        self.clickedButton = clickedButton
//        self.column = column
//        self.selectedElement = selectedElement
//    }
    
    
    
    var body: some View {
        LazyVGrid(
            columns: column.gridItemList,
            spacing: column.verticalPadding
        ) {
            ForEach(titleList, id : \.self){ title in
                Button {
                    self.selectedElement = title
                    clickedButton()
                } label: {
                    Text(title)
                        .font(.title_xsm)
                        .padding(.vertical, 13)
                        .foregroundStyle(
                            selectedElement == title
                            ? .white
                            : .gray600
                        )
                        .frame(maxWidth: .infinity)
                        .background(
                            selectedElement == title
                            ? .mainGray
                            : .gray70
                        )
                        .cornerRadius(4)
                }
            }
        }
    }
}

#Preview {
    struct GrayBoxGridPreviewContainer: View {
        @State var element: String = ""
        
        var body: some View {
            GrayBoxGridView(column: .three, titleList: [], clickedButton: {}, selectedElement: $element)
//            GrayBoxGridView(
//                column: .three,
//                titleList: ["인문", "사회", "교육", "자연", "공학", "의약", "예체능", "기타"],
//                clickedButton: {},
//                selectedElement: $element.wrappedValue
//            )
        }
    }
    return GrayBoxGridPreviewContainer()
}

