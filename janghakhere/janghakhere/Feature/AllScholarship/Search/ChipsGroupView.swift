//
//  ChipsGroupView.swift
//  janghakhere
//
//  Created by Gaeun Lee on 4/19/24.
//

import SwiftUI

struct ChipsGroupView: View {
    @ObservedObject var viewModel: SearchScholarshipViewModel
    
    @State var lastOverTwoLineCallTime: Date?
    
    var body: some View {
        var width = CGFloat.zero
        var height = CGFloat.zero
        
        GeometryReader { geometry in
            ZStack(alignment: .topLeading) {
                ForEach(viewModel.chips, id: \.id) { chip in
                    ChipView(viewModel: viewModel, chip: chip)
                        .padding(.horizontal, 5)
                        .padding(.vertical, 5)
                        .alignmentGuide(.leading) { dimension in
                            if abs(width - dimension.width) > geometry.size.width {
                                width = 0
                                height -= dimension.height
                            }
                            let result = width
                            if chip.id == viewModel.chips.last!.id {
                                width = 0
                            } else {
                                width -= dimension.width
                            }
                            return result
                        }
                        .alignmentGuide(.top) { dimension in
                            let result = height
                            if chip.id == viewModel.chips.last!.id {
                                height = 0
                            }
                            return result
                        }
                }
            }
        }
    }
}

private struct ChipView: View {
    @ObservedObject var viewModel: SearchScholarshipViewModel
    
    let chip: Chip
    
    var body: some View {
        HStack {
            Text(chip.title)
                .onTapGesture {
                    viewModel.clickedChipButton(chip)
                }
            Button {
                viewModel.clickedChipXButton(chip)
            } label: {
                Icon(name: .x, color: .gray500, size: 16)
            }
        }
        .font(.text_md)
        .foregroundStyle(.gray500)
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(
            Capsule(style: .circular)
                .stroke(.gray200, lineWidth: 1)
                .fill(.white)
        )
    }
}
//
//#Preview {
//    ChipsGroupView(chips: [.init(title: "긴급지원"), .init(title: "성적장학금"), .init(title: "에코"), .init(title: "국가장학금"), .init(title: "시흥시인재양성재단")])
//}
