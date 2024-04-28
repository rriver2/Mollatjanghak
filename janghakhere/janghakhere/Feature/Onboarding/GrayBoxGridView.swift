//
//  GrayBoxGridView.swift
//  janghakhere
//
//  Created by Gaeun Lee on 4/17/24.
//

import SwiftUI

struct GrayBoxGridView<T: Hashable & CustomStringConvertible>: View {
    
    enum ColumnCategory {
        case three
        case two
        
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
    let titleList: [T]
    let action: (() -> Void)
    @Binding var selectedElement: T
    
    var body: some View {
        LazyVGrid(
            columns: column.gridItemList,
            spacing: column.verticalPadding
        ) {
            ForEach(
                titleList.filter { $0.description != "선택 안 됨" },
                id : \.self){ title in
                Button {
                    selectedElement = title
                    action()
                } label: {
                    Text(title.description)
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
        @State var element: EnrollmentStatus = .notSelected
        
        var body: some View {
            GrayBoxGridView<EnrollmentStatus>(
                column: .three,
                titleList: EnrollmentStatus.allCases,
                action: {},
                selectedElement: $element
            )
        }
    }
    return GrayBoxGridPreviewContainer()
}

