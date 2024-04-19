//
//  ChipsView.swift
//  janghakhere
//
//  Created by Gaeun Lee on 4/19/24.
//

import SwiftUI

struct ChipsGroupView: View {
    var chips: [Chip]

    var body: some View {
        var width = CGFloat.zero
        var height = CGFloat.zero

        GeometryReader { geometry in
            ZStack(alignment: .topLeading) {
                ForEach(chips, id: \.id) { chip in
                    ChipsView(chip: chip)
                        .padding(.horizontal, 5)
                        .padding(.vertical, 5)
                        .alignmentGuide(.leading) { dimension in
                            if abs(width - dimension.width) > geometry.size.width {
                                width = 0
                                height -= dimension.height
                            }
                            let result = width
                            if chip.id == chips.last!.id {
                                width = 0
                            } else {
                                width -= dimension.width
                            }
                            return result
                        }
                        .alignmentGuide(.top) { dimension in
                            let result = height
                            if chip.id == chips.last!.id {
                                height = 0
                            }
                            return result
                        }
                }
                .padding(.horizontal, 16)
            }
        }
    }
}

private struct ChipsView: View {
    var chip: Chip

    var body: some View {
        HStack {
            Text(chip.title)
                .onTapGesture {
                    print("여기서 검색창과 바인딩 하는게 좋을거 같아요")
                    // viewModel.tapChip(chip: chip)
                }
            Button {
                print("viewModel에 있는 chip 삭제")
            } label: {
                Image(systemName: "xmark")
            }
        }
        .font(.text_md)
        .foregroundStyle(.gray500)
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(
            Capsule(style: .circular)
                .stroke(.gray200, lineWidth: 1)
                .fill(.white)
        )
    }
}

#Preview {
    ChipsGroupView(chips: [.init(title: "긴급지원"), .init(title: "성적장학금"), .init(title: "에코"), .init(title: "국가장학금"), .init(title: "시흥시인재양성재단")])
}
